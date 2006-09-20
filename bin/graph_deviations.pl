#!/usr/bin/perl -w
use strict;
use warnings;

use Chart::Graph::Gnuplot qw(gnuplot);

my $focus_class = 'GIS::Distance::GreatCircle';

my @calcs;
my %datasets;

foreach my $formula (qw(
    Cosine GeoEllipsoid GreatCircle Haversine MathTrig Polar Vincenty
)) {
    my $class = "GIS::Distance::$formula";
    eval("require $class");
    push( @calcs, $class->new() );
    $datasets{$class} = [
        { title=>$class, type=>'matrix',
            style=>($class eq $focus_class ? 'points' : 'lines')
        }, []
    ];
}

my $start_lon = -180;
my $end_lon = 180;
my $start_lat = -90;
my $end_lat = 90;

my $lon_step = 60;
my $lat_step = 30;

my $x = 0;

for (my $lon1=$start_lon; $lon1<=$end_lon; $lon1+=$lon_step) {
for (my $lat1=$start_lat; $lat1<=$end_lat; $lat1+=$lat_step) {
    for (my $lon2=$start_lon; $lon2<=$end_lon; $lon2+=$lon_step) {
    for (my $lat2=$start_lat; $lat2<=$end_lat; $lat2+=$lat_step) {

        $x ++;
        my $x_shift = 0;

        foreach my $calc (@calcs) {
            push(
                @{$datasets{ref($calc)}->[1]},
                [$x+$x_shift, $calc->distance($lon1,$lat1,$lon2,$lat2)->km() ],
            );
            $x_shift ++;
        }

    }}
}}

gnuplot(
    {
        'title'         => 'stuff',
        'x-axis label'  => 'step',
        'y-axis label'  => 'kilometers',
        'output type'   => 'png',
        'output file'   => 'deviations.png',
        'size'          => [40,2],
#        'xrange'        => [650,700],
    },
    map { $datasets{$_} } keys(%datasets)
);

