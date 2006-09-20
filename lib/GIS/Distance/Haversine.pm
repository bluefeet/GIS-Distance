package GIS::Distance::Haversine;

=head1 NAME

GIS::Distance::Haversine - Exact spherical distance calculations.

=head1 SYNOPSIS

  my $calc = GIS::Distance::Haversine->new();
  my $distance = $calc->distance( $lon1, $lat1 => $lon2, $lat2 );

=head1 DESCRIPTION

This is the default distance calculation for L<GIS::Distance> as
it keeps a good balance between speed and accuracy.

=head1 FORMULA

  dlon = lon2 - lon1
  dlat = lat2 - lat1
  a = (sin(dlat/2))^2 + cos(lat1) * cos(lat2) * (sin(dlon/2))^2
  c = 2 * atan2( sqrt(a), sqrt(1-a) )
  d = R * c 

=cut

use strict;
use warnings;

use base qw( GIS::Distance );

use Class::Measure::Length;
use Math::Trig qw( deg2rad );

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

    my $dlon = $lon2 - $lon1;
    my $dlat = $lat2 - $lat1;
    my $a = (sin($dlat/2)) ** 2 + cos($lat1) * cos($lat2) * (sin($dlon/2)) ** 2;
    my $c = 2 * atan2(sqrt($a), sqrt(1-$a));

    return length( $self->kilometer_rho() * $c, 'km' );
}

1;
__END__

=head1 RESOURCES

L<http://mathforum.org/library/drmath/view/51879.html>

L<http://www.faqs.org/faqs/geography/infosystems-faq/>

=head1 AUTHOR

Aran Clary Deltac <bluefeet@cpan.org>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

