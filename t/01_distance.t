#!/usr/bin/perl
use strict;
use warnings;

use Test::More tests => 2;

use_ok('GIS::Distance');

my $calc = eval{ GIS::Distance->new() };
isa_ok( $calc, 'GIS::Distance::Haversine' );

