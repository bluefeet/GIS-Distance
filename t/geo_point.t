#!/usr/bin/env perl
use 5.008001;
use strictures 2;
use Test2::V0;

use Test2::Require::Module 'Geo::Point';
use Geo::Point;
use GIS::Distance;

my $gis = GIS::Distance->new('GIS::Distance::Haversine');

my @coords1 = (-33.446339, -70.63591); # Santiago
my @coords2 = (-22.902981, -43.213177); # Rio de Janeiro

my $point1 = Geo::Point->latlong( @coords1 );
my $point2 = Geo::Point->latlong( @coords2 );

my $expected = $gis->distance( @coords1, @coords2 );

is(
    $gis->distance( $point1, @coords2 ),
    $expected,
    'Geo::Point as first argument works',
);

is(
    $gis->distance( @coords1, $point2 ),
    $expected,
    'Geo::Point as second argument works',
);

is(
    $gis->distance( $point1, $point2 ),
    $expected,
    'Geo::Point as both arguments works',
);

done_testing;
