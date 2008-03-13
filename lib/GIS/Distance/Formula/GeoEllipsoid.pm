package GIS::Distance::Formula::GeoEllipsoid;

=head1 NAME

GIS::Distance::Formula::GeoEllipsoid - Geo::Ellipsoid distance calculations.

=head1 SYNOPSIS

  my $gis = GIS::Distance->new();
  
  $gis->formula( 'GeoEllipsoid', { ellipsoid => 'WGS84' } );

=head1 DESCRIPTION

This module is a wrapper around L<Geo::Ellipsoid> for
L<GIS::Distance>.

Normally this module is not used directly.  Instead L<GIS::Distance>
is used which in turn interfaces with the various formula classes.

=head1 FORMULA

See the documentation for L<Geo::Ellipsoid>.

=cut

use Moose;
extends 'GIS::Distance::Formula';

use Class::Measure::Length;
use Geo::Ellipsoid;

=head1 ATTRIBUTES

=head2 ellipsoid

  $calc->ellipsoid( 'AIRY' );

Set and retrieve the ellipsoid object.  If a string is passed
then it will be coerced in to an object.

=cut

__PACKAGE__->mk_classaccessor( 'ellipsoid_obj' );

subtype 'Geo-Ellipsoid'
    => as 'Object'
    => where { $_->isa('Geo::Ellipsoid') };

coerce 'Geo-Ellipsoid'
    => from 'Str'
        => via {
            my $type = $_;
            return Geo::Ellipsoid->new(
                units => 'degrees',
                ( $type ? (ellipsoid=>$type) : () ),
            );
        };

has 'ellipsoid' => (
    is      => 'rw',
    isa     => 'Geo-Ellipsoid',
    default => '',
    coerce  => 1,
);

=head1 METHODS

=head2 distance

This method is called by L<GIS::Distance>'s distance() method.

=cut

sub distance {
    my $self = shift;

    return length(
        $self->ellipsoid->range( @_ ),
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

