package GIS::Distance::Polar;

=head1 NAME

GIS::Distance::Polar - Polar coordinate flat-earth distance calculations.

=head1 SYNOPSIS

  my $calc = GIS::Distance::Polar->new();
  my $distance = $calc->distance( $lon1, $lat1 => $lon2, $lat2 );

=head1 DESCRIPTION

Supposedly this is a formula to better calculate distances at the
poles.

While implimented, this formula has not been tested much.  If you use it 
PLEASE share your results with the author.

=head1 FORMULA

  a = pi/2 - lat1
  b = pi/2 - lat2
  c = sqrt( a^2 + b^2 - 2 * a * b * cos(lon2 - lon1) )
  d = R * c

=cut

use strict;
use warnings;

use base qw( GIS::Distance );

use Class::Measure::Length;
use Math::Trig qw( deg2rad pi );

=head1 METHODS

=head2 distance

  my $distance = $calc->distance( $lon1, $lat1 => $lon2, $lat2 );

This method accepts two lat/lon sets (in decimal degrees) and returns a
L<Class::Measure::Length> object containing the distance
between the two points.

=cut

sub distance {
    my($self,$lon1,$lat1,$lon2,$lat2) = @_;
    $lon1 = deg2rad($lon1); $lat1 = deg2rad($lat1);
    $lon2 = deg2rad($lon2); $lat2 = deg2rad($lat2);
    my $a = pi/2 - $lat1;
    my $b = pi/2 - $lat2;
    my $c = sqrt( $a ** 2 + $b ** 2 - 2 * $a * $b * cos($lon2 - $lon1) );
    return length( $self->kilometer_rho() * $c, 'km' );
}

1;
__END__

=head1 AUTHOR

Aran Clary Deltac <bluefeet@cpan.org>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

