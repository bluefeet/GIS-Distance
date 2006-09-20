package GIS::Distance::GeoEllipsoid;

=head1 NAME

GIS::Distance::GeoEllipsoid - Geo::Ellipsoid distance calculations.

=head1 SYNOPSIS

  my $calc = GIS::Distance::GeoEllipsoid->new( 'WGS84' );
  my $distance = $calc->distance( $lon1, $lat1 => $lon2, $lat2 );
  $calc->ellipsoid_obj->set_ellipsoid( 'AIRY' );

=head1 DESCRIPTION

This module is a wrapper around the L<Geo::Ellipsoid> for
L<GIS::Distance>.

=head1 FORMULA

See the documentation for L<Geo::Ellipsoid>.

=cut

use strict;
use warnings;

use base qw( GIS::Distance );

use Class::Measure::Length;
use Geo::Ellipsoid;

=head1 ACCESSORS

=head2 ellipsoid_obj

  $calc->ellipsoid_obj->set_ellipsoid( 'AIRY' );

=cut

__PACKAGE__->mk_classaccessor( 'ellipsoid_obj' );

=head1 METHODS

=head2 new

  my $calc = GIS::Distance::GeoEllipsoid->new( 'WGS84' );

The new() constructor in L<GIS::Distance> is overriden so that after
blessing a new L<Geo::Ellipsoid> object is assigned to the ellipsoid_obj()
accessor.

This method accepts one optional argument - the ellipsoid type.  This can
be any of the ellipsoids that L<Geo::Ellipsoid> supports.  If you want
to specify a custom ellipsoid then you will need to first create a
GIS::Distance::GeoEllipsoid object then modify the L<Geo::Ellipsoid>
object through the ellipsiod_obj() accessor.

=cut

sub new {
    my $class = shift;
    my $self = $class->SUPER::new();
    $self->ellipsoid_obj(
        Geo::Ellipsoid->new(
            units => 'degrees',
            ( @_ ? (ellipsoid=>shift()) : () ),
        )
    );
    return $self;
}

=head2 distance

  my $distance = $calc->distance( $lon1, $lat1 => $lon2, $lat2 );

This method accepts two lat/lon sets (in decimal degrees) and returns a
L<Class::Measure::Length> object containing the distance (or "range")
between the two points.

=cut

sub distance {
    my($self,$lon1,$lat1,$lon2,$lat2) = @_;

    return length(
        $self->ellipsoid_obj->range( $lat1, $lon1, $lat2, $lon2 ),
        'm'
    );
}

1;
__END__

=head1 AUTHOR

Aran Clary Deltac <bluefeet@cpan.org>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

