package GIS::Distance;

=head1 NAME

GIS::Distance - Calculate geographic distances.

=head1 SYNOPSIS

  use GIS::Distance;
  my $gis = GIS::Distance->new();
  $gis->formula( 'Polar' );  # Optional, default is Haversine.
  my $distance = $gis->distance( $lat1,$lon1 => $lat2,$lon2 );

=head1 DESCRIPTION

This perl library aims to provide as many tools to make it as simple as possible to calculate
distances between geographic points, and anything that can be derived from that.

=cut

use Moose;
use Moose::Util::TypeConstraints;
use Carp qw( croak );

our $VERSION = '0.02';

=head1 METHODS

=head2 distance

  my $distance = $gis->distance( $lat1,$lon1 => $lat2,$lon2 );

Returns a L<Class::Measure::Length> object for the distance between the
two degree lats/lons.  The distance is calculated using whatever formula
the object is set to use.

=cut

sub distance {
    my $self = shift;

    return $self->formula->distance( @_ );
}

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

subtype 'GIS-Distance-Formula'
    => as 'Object'
    => where { $_->isa('GIS::Distance::Formula') };

coerce 'GIS-Distance-Formula'
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
    isa     => 'GIS-Distance-Formula',
    default => 'Haversine',
    coerce  => 1,
);

1;
__END__

=head1 FORMULAS

L<GID::Distance::Formula::Cosine>

L<GID::Distance::Formula::GeoEllipsoid>

L<GID::Distance::Formula::GreatCircle>

L<GID::Distance::Formula::Haversine>

L<GID::Distance::Formula::MathTrig>

L<GID::Distance::Formula::Polar>

L<GID::Distance::Formula::Vincenty>

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

Both the L<GIS::Distance::Formula::GreatCircle> and L<GIS::Distance::Formuka::Polar> formulas are
broken.  Read their respective man pages for details.

=head1 AUTHOR

Aran Clary Deltac <bluefeet@cpan.org>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

