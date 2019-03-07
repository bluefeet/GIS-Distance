requires 'namespace::clean' => '0.24';
requires 'perl' => '5.008001';
requires 'strictures' => '2.000000';

requires 'Class::Measure::Length';
requires 'Math::Trig';

recommends 'GIS::Distance::Fast' => '0.04';
recommends 'Geo::Ellipsoid' => '0.902';

on test => sub {
    requires 'Test2::V0' => '0.000094';
};
