use strict;
use warnings;

my $ok;
BEGIN {
eval "use Test::More";
$ok = !$@;
}

if ($ok) {
    eval "use Test::Pod";
    plan skip_all => "Test::Pod required for testing POD validity." if $@;
    plan tests => 1;
    pod_file_ok( 'lib/Encode/RAD50.pm', "Valid POD file" );
    }
  else {
    print <<eod;
1..1
ok 1 # skip Test::More required for testing POD validity.
eod
    }
