package GIS::Distance;

=head1 NAME

GIS::Distance - Calculate geographic distances.

=head1 SYNOPSIS

  use GIS::Distance;
  my $calc = GIS::Distance->new();
  my $distance = $calc->distance( $lon1,$lat1 => $lon2,$lat2 );

=head1 DESCRIPTION

This perl library aims to provide as many tools to make it as simple as possible to calculate
distances between geographic points, and anything that can be derived from that.

Please note that this is alpha software.  This module will become the
replacement for L<Geo::Distance>.  So, until this module is
well tested and production worthy I would recommend using that.

=cut

use strict;
use warnings;

use base qw( Class::Data::Accessor );
use Carp qw( croak );

our $VERSION = '0.01001';

# Number of kilometers around the equator of the earth.
__PACKAGE__->mk_classaccessor( kilometer_rho => 6371.64 );

# Number of units in a single decimal degree (lat or lon) at the equator.
# Derived from: $geo->distance( 10,0 => 11,0 )->km() / $geo->kilometer_rho()
__PACKAGE__->mk_classaccessor( deg_ratio => 0.0174532925199433 );

=head1 METHODS

=head2 new

  my $calc = GIS::Distance->new();

Returns a blessed L<GIS::Distance::Haversine> object by
default.  If you want to use a different formula, such as the
L<GIS::Distance::Vincenty>, then call new() on that class.

=cut

sub new {
    my $class = shift;
    if ($class eq 'GIS::Distance') {
        $class = 'GIS::Distance::Haversine';
    }
    return bless( {}, $class );
}

1;
__END__

=head2 distance

  my $distance = $calc->distance( $lon1,$lat1 => $lon2,$lat2 );

Calculates the distance between two lon/lat points in decimal degree
format.  In return you will receive an L<Class::Measure::Length>
object.

=head1 FORMULAS

L<GID::Distance::Cosine>

L<GID::Distance::GeoEllipsoid>

L<GID::Distance::GreatCircle>

L<GID::Distance::Haversine>

L<GID::Distance::MathTrig>

L<GID::Distance::Polar>

L<GID::Distance::Vincenty>

=head1 TODO

Create a GIS::Coord class that represents a geographic coordinate.  Then modify
this module to accept input as either lon/lat pairs, or as GIS::Coord objects.

Create an extension to DBIx::Class with the same goal as L<Geo::Distance>'s
closest() method.

=head1 BUGS

The graphs produce by graph_deviations.pl script show that the
L<GIS::Distance::GreatCircle> formula is not performing well at
all.  In most cases it is either returning a distance of 0 or a
distance of 20,000 km.

=head1 AUTHOR

Aran Clary Deltac <bluefeet@cpan.org>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

