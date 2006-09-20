package GIS::Distance::Cosine;

=head1 NAME

GIS::Distance::Cosine - Cosine distance calculations.

=head1 SYNOPSIS

  my $calc = GIS::Distance::Cosine->new();
  my $distance = $calc->distance( $lon1, $lat1 => $lon2, $lat2 );

=head1 DESCRIPTION

Although this formula is mathematically exact, it is unreliable for
small distances because the inverse cosine is ill-conditioned.

=head1 FORMULA

  a = sin(lat1) * sin(lat2)
  b = cos(lat1) * cos(lat2) * cos(lon2 - lon1)
  c = arccos(a + b)
  d = R * c

=cut

use strict;
use warnings;

use base qw( GIS::Distance );

use Class::Measure::Length;
use Math::Trig qw( deg2rad acos );

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

    my $a = sin($lat1) * sin($lat2);
    my $b = cos($lat1) * cos($lat2) * cos($lon2 - $lon1);
    my $c = acos($a + $b);

    return length( $self->kilometer_rho() * $c, 'km' );
}

1;
__END__

=head1 AUTHOR

Aran Clary Deltac <bluefeet@cpan.org>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

