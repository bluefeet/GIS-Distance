use strict;
use warnings;

use inc::Module::Install;

name     'GIS-Distance';
perl_version '5.008003';
all_from 'lib/GIS/Distance.pm';
readme_from 'lib/GIS/Distance.pm';
githubmeta;

requires 'Moose' => 0.39;
requires 'Class::Measure';
requires 'Math::Complex';

test_requires 'Test::More' => 0.94;

recommends 'Geo::Ellipsoid' => 0.902;
recommends 'GIS::Distance::Fast' => 0.04;

WriteAll;

