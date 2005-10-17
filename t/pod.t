use strict;
use warnings;

use Test::More;
eval "use Test::Pod";
plan skip_all => "Test::Pod required for testing POD validity." if $@;
plan tests => 1;
pod_file_ok( 'RAD50.pm', "Valid POD file" );
