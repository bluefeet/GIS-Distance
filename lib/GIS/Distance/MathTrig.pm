package GIS::Distance::MathTrig;

=head1 NAME

GIS::Distance::MathTrig - Great cirlce distance calculations using Math::Trig.

=head1 SYNOPSIS

  my $calc = GIS::Distance::MathTrig->new();
  my $distance = $calc->distance( $lon1, $lat1 => $lon2, $lat2 );

=head1 DESCRIPTION

This formula uses L<Math::Trig>'s great_circle_distance function which
at this time uses math almost exactly the same as the
L<GIS::Distance::Cosine> formula.  If you want to use the
L<GIS::Distance::Cosine> formula you may find that this module will
calculate faster (untested assumption).  For some reason this and
the Cosine formula return slight differences at very close distances.
This formula has the same drawbacks as the Cosine formula.

=head1 FORMULA

  lat0 = 90 degrees - phi0
  lat1 = 90 degrees - phi1
  d = R * arccos(cos(lat0) * cos(lat1) * cos(lon1 - lon01) + sin(lat0) * sin(lat1))

As stated in the L<Math::Trig> POD.

=cut

use strict;
use warnings;

use base qw( GIS::Distance );

use Class::Measure::Length;
use Math::Trig qw( great_circle_distance deg2rad );

=head1 METHODS

=head2 distance

  my $distance = $calc->distance( $lon1, $lat1 => $lon2, $lat2 );

This method accepts two lat/lon sets (in degrees) and returns a
L<Class::Measure::Length> object containing the distance
between the two points.

=cut

sub distance {
    my($self,$lon1,$lat1,$lon2,$lat2) = @_;

    return length(
        great_circle_distance(
            deg2rad($lon1),
            deg2rad(90 - $lat1),
            deg2rad($lon2),
            deg2rad(90 - $lat2),
            $self->kilometer_rho(),
        ),
        'km'
    );
}

1;
__END__

=head1 AUTHOR

Aran Clary Deltac <bluefeet@cpan.org>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

