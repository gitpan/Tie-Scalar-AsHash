# Load the Module::Install bundled in ./inc/
use inc::Module::Install;

# Define metadata
name           'Tie-Scalar-AsHash';
all_from       'lib/Tie/Scalar/AsHash.pm';

requires       'Carp';
requires       'Scalar::Util';

build_requires 'Test::More';
build_requires 'parent';

auto_install;
WriteAll;

