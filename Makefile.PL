use ExtUtils::MakeMaker;

WriteMakefile(
    NAME            => 'GIS::Distance',
    AUTHOR          => 'Aran Clary Deltac <bluefeet@cpan.org>',
    VERSION_FROM    => 'lib/GIS/Distance.pm',
    ABSTRACT_FROM   => 'lib/GIS/Distance.pm',
    PREREQ_PM => {
        'Test::More' => 0,
        'Class::Measure' => 0,
        'Class::Data::Accessor' => 0,
    },
);

