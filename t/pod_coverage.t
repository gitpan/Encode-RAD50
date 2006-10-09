use strict;
use warnings;

my $ok;
BEGIN {
eval "use Test::More";
$ok = !$@;
}

if ($ok) {
    eval "use Test::Pod::Coverage";
    plan skip_all => "Test::Pod::Coverage required to test POD coverage." if $@;
    plan tests => 1;
    pod_coverage_ok ('Encode::RAD50');
    }
  else {
    print <<eod;
1..1
ok 1 # skip Test::More required for testing POD coverage.
eod
    }
