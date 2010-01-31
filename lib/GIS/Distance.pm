package GIS::Distance;

=head1 NAME

GIS::Distance - Calculate geographic distances.

=head1 SYNOPSIS

  use GIS::Distance;
  
  my $gis = GIS::Distance->new();
  
  $gis->formula( 'Polar' );  # Optional, default is Haversine.
  
  my $distance = $gis->distance( $lat1,$lon1 => $lat2,$lon2 );
  
  print $distance->meters();

=head1 DESCRIPTION

This perl library aims to provide as many tools to make it as simple as possible to calculate
distances between geographic points, and anything that can be derived from that.

=cut

use Moose;
use namespace::autoclean;

use Moose::Util::TypeConstraints;
use Carp qw( croak );

our $VERSION = '0.05';

=head1 METHODS

=head2 distance

  my $distance = $gis->distance( $lat1,$lon1 => $lat2,$lon2 );

Returns a L<Class::Measure::Length> object for the distance between the
two degree lats/lons.  The distance is calculated using whatever formula
the object is set to use.

=head1 ATTRIBUTES

=head2 formula

This is an object who's class inherits from L<GIS::Distance::Formula>.  This
object is used to calculate distance.  The formula may be specified as either
a blessed object, or as a string, such as "Haversine" or any of the other formulas.

If you specify the formula as a string then a few different class names will be
searched for.  So, if you did:

  $gis->formula( 'Haversine' );

Then this list of packages would automatically be looked for.  The first one that
exists will be created and used:

  GIS::Distance::Formula::Haversine::Fast
  GIS::Distance::Formula::Haversine
  Haversine

If you are using your own custom formula class make sure it extends() (L<Moose>)
the L<GIS::Distance::Formula> class.

Note that a ::Fast version of the class will be looked for first.  By default
the ::Fast versions of the formulas, written in C, are not available and the
pure perl ones will be used instead.  If you would like the ::Fast formulas
then install L<GIS::Distance::Fast> and they will be automatically used.

=cut

subtype 'GISDistanceFormula'
    => as 'Object';

coerce 'GISDistanceFormula'
    => from 'Str'
        => via {
            my $class = $_;
            foreach my $full_class (
                "GIS::Distance::Formula::${class}::Fast",
                "GIS::Distance::Formula::$class",
                $class,
            ) {
                eval( "require $full_class" );
                if (!$@) {
                    return $full_class->new();
                }
            }
            die( qq{The GIS::Distance formula "$class" can not be found} );
        };

has 'formula' => (
    is      => 'rw',
    isa     => 'GISDistanceFormula',
    default => 'Haversine',
    handles => ['distance'],
    coerce  => 1,
);

__PACKAGE__->meta->make_immutable;

1;
__END__

=head1 SEE ALSO

L<GIS::Distance::Fast> - C implmentation of some of the formulas
shipped with GIS::Distance.  This greatly increases the speed at
which distance calculations can be made.

=head1 FORMULAS

L<GIS::Distance::Formula::Cosine>

L<GIS::Distance::Formula::GeoEllipsoid>

L<GIS::Distance::Formula::GreatCircle>

L<GIS::Distance::Formula::Haversine>

L<GIS::Distance::Formula::MathTrig>

L<GIS::Distance::Formula::Polar>

L<GIS::Distance::Formula::Vincenty>

=head1 TODO

=over 4

=item *

Create a GIS::Coord class that represents a geographic coordinate.  Then modify
this module to accept input as either lat/lon pairs, or as GIS::Coord objects.

=item *

Create an extension to DBIx::Class with the same goal as L<Geo::Distance>'s
closest() method.

=item *

Write a super accurate formula module called GIS::Distance::Geoid.  Some
very useful info is at L<http://en.wikipedia.org/wiki/Geoid>.

=back

=head1 BUGS

Both the L<GIS::Distance::Formula::GreatCircle> and L<GIS::Distance::Formula::Polar> formulas are
broken.  Read their respective man pages for details.

=head1 TEST COVERAGE

  ---------------------------- ------ ------ ------ ------ ------ ------ ------
  File                           stmt   bran   cond    sub    pod   time  total
  ---------------------------- ------ ------ ------ ------ ------ ------ ------
  blib/lib/GIS/Distance.pm      100.0    n/a    n/a  100.0  100.0   24.0  100.0
  ...b/GIS/Distance/Formula.pm   75.0    n/a    n/a   66.7  100.0    1.9   75.0
  ...istance/Formula/Cosine.pm  100.0    n/a    n/a  100.0  100.0    5.9  100.0
  ...e/Formula/GeoEllipsoid.pm  100.0    n/a    n/a  100.0  100.0    3.6  100.0
  ...ce/Formula/GreatCircle.pm  100.0    n/a    n/a  100.0  100.0    5.9  100.0
  ...ance/Formula/Haversine.pm  100.0    n/a    n/a  100.0  100.0    9.1  100.0
  ...tance/Formula/MathTrig.pm  100.0    n/a    n/a  100.0  100.0    2.4  100.0
  ...Distance/Formula/Polar.pm  100.0    n/a    n/a  100.0  100.0    2.7  100.0
  ...tance/Formula/Vincenty.pm  100.0   50.0   50.0  100.0  100.0   44.6   93.1
  Total                          98.8   50.0   50.0   97.2  100.0  100.0   96.7
  ---------------------------- ------ ------ ------ ------ ------ ------ ------

=head1 AUTHOR

Aran Clary Deltac <bluefeet@cpan.org>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

