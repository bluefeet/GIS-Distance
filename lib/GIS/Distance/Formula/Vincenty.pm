package GIS::Distance::Formula::Vincenty;

=head1 NAME

GIS::Distance::Formula::Vincenty - Thaddeus Vincenty distance calculations.

=head1 DESCRIPTION

For the benefit of the terminally obsessive (as well as the genuinely needy),
Thaddeus Vincenty devised formulae for calculating geodesic distances between
a pair of latitude/longitude points on the earth's surface, using an accurate
ellipsoidal model of the earth.

Vincenty's formula is accurate to within 0.5mm, or 0.000015", on the ellipsoid
being used. Calculations based on a spherical model, such as the (much simpler)
Haversine, are accurate to around 0.3% (which is still good enough for most
purposes, of course).

Note: the accuracy quoted by Vincenty applies to the theoretical ellipsoid
being used, which will differ (to varying degree) from the real earth geoid.
If you happen to be located in Colorado, 2km above msl, distances will be 0.03%
greater. In the UK, if you measure the distance from Land's End to John O'
Groats using WGS-84, it will be 28m - 0.003% - greater than using the Airy
ellipsoid, which provides a better fit for the UK.

NOTE: This formula is still considered alpha quality in GIS::Distance as it
hasn't been tested all that much.

Normally this module is not used directly.  Instead L<GIS::Distance>
is used which in turn interfaces with the various formula classes.

=head1 FORMULA

    a, b = major & minor semiaxes of the ellipsoid
    f = flattening (a-b)/a
    L = lon2 - lon1
    u1 = atan((1-f) * tan(lat1))
    u2 = atan((1-f) * tan(lat2))
    sin_u1 = sin(u1)
    cos_u1 = cos(u1)
    sin_u2 = sin(u2)
    cos_u2 = cos(u2)
    lambda = L
    lambda_pi = 2PI
    while abs(lambda-lambda_pi) > 1e-12
        sin_lambda = sin(lambda)
        cos_lambda = cos(lambda)
        sin_sigma = sqrt((cos_u2 * sin_lambda) * (cos_u2*sin_lambda) + 
            (cos_u1*sin_u2-sin_u1*cos_u2*cos_lambda) * (cos_u1*sin_u2-sin_u1*cos_u2*cos_lambda))
        cos_sigma = sin_u1*sin_u2 + cos_u1*cos_u2*cos_lambda
        sigma = atan2(sin_sigma, cos_sigma)
        alpha = asin(cos_u1 * cos_u2 * sin_lambda / sin_sigma)
        cos_sq_alpha = cos(alpha) * cos(alpha)
        cos2sigma_m = cos_sigma - 2*sin_u1*sin_u2/cos_sq_alpha
        cc = f/16*cos_sq_alpha*(4+f*(4-3*cos_sq_alpha))
        lambda_pi = lambda
        lambda = L + (1-cc) * f * sin(alpha) *
            (sigma + cc*sin_sigma*(cos2sigma_m+cc*cos_sigma*(-1+2*cos2sigma_m*cos2sigma_m)))
    }
    usq = cos_sq_alpha*(a*a-b*b)/(b*b);
    aa = 1 + usq/16384*(4096+usq*(-768+usq*(320-175*usq)))
    bb = usq/1024 * (256+usq*(-128+usq*(74-47*usq)))
    delta_sigma = bb*sin_sigma*(cos2sigma_m+bb/4*(cos_sigma*(-1+2*cos2sigma_m*cos2sigma_m)-
      bb/6*cos2sigma_m*(-3+4*sin_sigma*sin_sigma)*(-3+4*cos2sigma_m*cos2sigma_m)))
    c = b*aa*(sigma-delta_sigma)

=cut

use Any::Moose;
use namespace::autoclean;

with 'GIS::Distance::Formula';

use Class::Measure::Length qw( length );
use Math::Trig qw( deg2rad pi tan atan asin );

=head1 METHODS

=head2 distance

This method is called by L<GIS::Distance>'s distance() method.

=cut

sub distance {
    my($self,$lat1,$lon1,$lat2,$lon2) = @_;
    return length(0,'km') if (($lon1==$lon2) and ($lat1==$lat2));
    $lon1 = deg2rad($lon1); $lat1 = deg2rad($lat1);
    $lon2 = deg2rad($lon2); $lat2 = deg2rad($lat2);

    my($a,$b,$f) = (6378137,6356752.3142,1/298.257223563);
    my $l = $lon2 - $lon1;
    my $u1 = atan((1-$f) * tan($lat1));
    my $u2 = atan((1-$f) * tan($lat2));
    my $sin_u1 = sin($u1); my $cos_u1 = cos($u1);
    my $sin_u2 = sin($u2); my $cos_u2 = cos($u2);
    my $lambda = $l;
    my $lambda_pi = 2 * pi;
    my $iter_limit = 20;
    my($cos_sq_alpha,$sin_sigma,$cos2sigma_m,$cos_sigma,$sigma) = (0,0,0,0,0);
    while( abs($lambda-$lambda_pi) > 1e-12 && --$iter_limit>0 ){
        my $sin_lambda = sin($lambda); my $cos_lambda = cos($lambda);
        $sin_sigma = sqrt(($cos_u2*$sin_lambda) * ($cos_u2*$sin_lambda) + 
            ($cos_u1*$sin_u2-$sin_u1*$cos_u2*$cos_lambda) * ($cos_u1*$sin_u2-$sin_u1*$cos_u2*$cos_lambda));
        $cos_sigma = $sin_u1*$sin_u2 + $cos_u1*$cos_u2*$cos_lambda;
        $sigma = atan2($sin_sigma, $cos_sigma);
        my $alpha = asin($cos_u1 * $cos_u2 * $sin_lambda / $sin_sigma);
        $cos_sq_alpha = cos($alpha) * cos($alpha);
        $cos2sigma_m = $cos_sigma - 2*$sin_u1*$sin_u2/$cos_sq_alpha;
        my $cc = $f/16*$cos_sq_alpha*(4+$f*(4-3*$cos_sq_alpha));
        $lambda_pi = $lambda;
        $lambda = $l + (1-$cc) * $f * sin($alpha) *
            ($sigma + $cc*$sin_sigma*($cos2sigma_m+$cc*$cos_sigma*(-1+2*$cos2sigma_m*$cos2sigma_m)));
    }
    my $usq = $cos_sq_alpha*($a*$a-$b*$b)/($b*$b);
    my $aa = 1 + $usq/16384*(4096+$usq*(-768+$usq*(320-175*$usq)));
    my $bb = $usq/1024 * (256+$usq*(-128+$usq*(74-47*$usq)));
    my $delta_sigma = $bb*$sin_sigma*($cos2sigma_m+$bb/4*($cos_sigma*(-1+2*$cos2sigma_m*$cos2sigma_m)-
            $bb/6*$cos2sigma_m*(-3+4*$sin_sigma*$sin_sigma)*(-3+4*$cos2sigma_m*$cos2sigma_m)));
    my $c = $b*$aa*($sigma-$delta_sigma);

    return length( $c, 'm' );
}

__PACKAGE__->meta->make_immutable;

1;
__END__

=head1 SEE ALSO

L<GIS::Distanc>

L<GIS::Distance::Formula::Vincenty::Fast>

=head1 RESOURCES

L<http://www.ngs.noaa.gov/PUBS_LIB/inverse.pdf>

L<http://www.movable-type.co.uk/scripts/LatLongVincenty.html>

=head1 AUTHOR

Aran Clary Deltac <bluefeet@cpan.org>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

