# NAME

GIS::Distance - Calculate geographic distances.

# SYNOPSIS

    use GIS::Distance;
    
    my $gis = GIS::Distance->new();
    $gis->formula( 'Polar' );  # Optional, default is Haversine.
    
    # Or:
    my $gis = GIS::Distance->new( 'Polar' );
    
    my $distance = $gis->distance( $lat1,$lon1 => $lat2,$lon2 );
    
    print $distance->meters();

# DESCRIPTION

This module calculates distances between geographic points on, at the moment,
plant Earth.  Various formulas are available that provide different levels of
accuracy versus calculation speed tradeoffs.

All distances are returned as [Class::Measure](https://metacpan.org/pod/Class::Measure) objects.

# METHODS

## distance

    my $distance = $gis->distance( $lat1,$lon1 => $lat2,$lon2 );

Returns a [Class::Measure::Length](https://metacpan.org/pod/Class::Measure::Length) object for the distance between the
two degree lats/lons.  The distance is calculated using whatever formula
the object is set to use.

# ATTRIBUTES

## formula

This is an object who's class inherits from [GIS::Distance::Formula](https://metacpan.org/pod/GIS::Distance::Formula).  This
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

If you are using your own custom formula class make sure it applies
the [GIS::Distance::Formula](https://metacpan.org/pod/GIS::Distance::Formula) role.

Note that a ::Fast version of the class will be looked for first.  By default
the ::Fast versions of the formulas, written in C, are not available and the
pure perl ones will be used instead.  If you would like the ::Fast formulas
then install [GIS::Distance::Fast](https://metacpan.org/pod/GIS::Distance::Fast) and they will be automatically used.

# SEE ALSO

[GIS::Distance::Fast](https://metacpan.org/pod/GIS::Distance::Fast) - C implmentation of some of the formulas
shipped with GIS::Distance.  This greatly increases the speed at
which distance calculations can be made.

# FORMULAS

[GIS::Distance::Formula::Cosine](https://metacpan.org/pod/GIS::Distance::Formula::Cosine)

[GIS::Distance::Formula::GeoEllipsoid](https://metacpan.org/pod/GIS::Distance::Formula::GeoEllipsoid)

[GIS::Distance::Formula::GreatCircle](https://metacpan.org/pod/GIS::Distance::Formula::GreatCircle)

[GIS::Distance::Formula::Haversine](https://metacpan.org/pod/GIS::Distance::Formula::Haversine)

[GIS::Distance::Formula::MathTrig](https://metacpan.org/pod/GIS::Distance::Formula::MathTrig)

[GIS::Distance::Formula::Polar](https://metacpan.org/pod/GIS::Distance::Formula::Polar)

[GIS::Distance::Formula::Vincenty](https://metacpan.org/pod/GIS::Distance::Formula::Vincenty)

# TODO

- Create a GIS::Coord class that represents a geographic coordinate.  Then modify
this module to accept input as either lat/lon pairs, or as GIS::Coord objects.
- Create an extension to DBIx::Class with the same goal as [Geo::Distance](https://metacpan.org/pod/Geo::Distance)'s
closest() method.
- Write a super accurate formula module called GIS::Distance::Geoid.  Some
very useful info is at [http://en.wikipedia.org/wiki/Geoid](http://en.wikipedia.org/wiki/Geoid).

# BUGS

Both the [GIS::Distance::Formula::GreatCircle](https://metacpan.org/pod/GIS::Distance::Formula::GreatCircle) and [GIS::Distance::Formula::Polar](https://metacpan.org/pod/GIS::Distance::Formula::Polar) formulas are
broken.  Read their respective man pages for details.

# SUPPORT

Please submit bugs and feature requests to the GIS-Distance GitHub issue tracker:

[https://github.com/bluefeet/GIS-Distance/issues](https://github.com/bluefeet/GIS-Distance/issues)

# AUTHORS

    Aran Clary Deltac <bluefeet@cpan.org>

# LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.
