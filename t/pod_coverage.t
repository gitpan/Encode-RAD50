use strict;
use warnings;

use Test::More;
eval "use Test::Pod::Coverage";
plan skip_all => "Test::Pod::Coverage required to test POD coverage." if $@;

plan tests => 1;
pod_coverage_ok ('Encode::RAD50');

