package GIS::Distance::GeoEllipsoid;
use 5.008001;
use strictures 2;
our $VERSION = '0.09';

use Geo::Ellipsoid;
use namespace::clean;

my $cache = {};

my $ellipsoid_args = {
    units          => 'degrees' ,
    distance_units => 'kilometer',
    longitude      => 0,
    bearing        => 0,
};

sub distance {
    my $ellipsoid = (@_ == 5) ? shift() : undef;

    $ellipsoid ||= 'WGS84';

    my $instance = $cache->{$ellipsoid} ||= Geo::Ellipsoid->new(
        %$ellipsoid_args,
        ellipsoid => $ellipsoid,
    );

    return $instance->range( @_ );
}

1;
__END__

=encoding utf8

=head1 NAME

GIS::Distance::GeoEllipsoid - Geo::Ellipsoid distance calculations.

=head1 SYNOPSIS

    # Use the default WGS84 ellipsoid:
    my $gis = GIS::Distance->new( 'GeoEllipsoid' );
    
    # Set to a custom ellipsoid:
    my $gis = GIS::Distance->new( 'GeoEllipsoid', 'NAD27' );

=head1 DESCRIPTION

This module is a wrapper around L<Geo::Ellipsoid> for L<GIS::Distance>.

Normally this module is not used directly.  Instead L<GIS::Distance>
is used which in turn interfaces with the various formula modules.

=head1 ARGUMENTS

An optional argument may be passed which must be, as shown in the
L</SYNOPSIS>, an ellipsoid name as defined at
L<Geo::Ellipsoid/DEFINED ELLIPSOIDS>.

Otherwise the default, C<WGS84>, will be used.

=head1 FORMULA

This module is just a thin wrapper, so go see L<Geo::Ellipsoid> for
details about how it works.

=head1 SEE ALSO

L<GIS::Distanc>

L<Geo::Ellipsoid>

=head1 AUTHORS AND LICENSE

See L<GIS::Distance/AUTHORS> and L<GIS::Distance/LICENSE>.

=cut

