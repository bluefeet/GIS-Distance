package GIS::Distance::GreatCircle;

=head1 NAME

GIS::Distance::GreatCircle - Great circle distance calculations.

=head1 SYNOPSIS

  my $calc = GIS::Distance::GreatCircle->new();
  my $distance = $calc->distance( $lon1, $lat1 => $lon2, $lat2 );

=head1 DESCRIPTION

=head1 FORMULA

  c = 2 * asin( sqrt(
    ( sin(( lat1 - lat2 )/2) )^2 + 
    cos( lat1 ) * cos( lat2 ) * 
    ( sin(( lon1 - lon2 )/2) )^2
  ) )

=cut

use strict;
use warnings;

use base qw( GIS::Distance );

use Class::Measure::Length;
use Math::Trig qw( deg2rad asin );

sub distance {
    my($self,$lon1,$lat1,$lon2,$lat2) = @_;
    $lon1 = deg2rad($lon1); $lat1 = deg2rad($lat1);
    $lon2 = deg2rad($lon2); $lat2 = deg2rad($lat2);

    my $c = 2*asin( sqrt(
        ( sin(($lat1-$lat2)/2) )^2 + 
        cos($lat1) * cos($lat2) * 
        ( sin(($lon1-$lon2)/2) )^2
    ) );

    return length( $self->kilometer_rho() * $c, 'km' );
}

1;
__END__

=head1 AUTHOR

Aran Clary Deltac <bluefeet@cpan.org>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

