use strict;
use warnings;

use inc::Module::Install;

name     'GIS-Distance';
perl_version '5.008003';
all_from 'lib/GIS/Distance.pm';

requires 'Moose' => 0.39;
requires 'Class::Measure';
requires 'Math::Complex';

build_requires 'Test::More' => 0.62;

recommends 'Geo::Ellipsoid' => 0.902;
recommends 'GIS::Distance::Fast';
recommends 'Test::Pod' => 1.22;

WriteAll;

