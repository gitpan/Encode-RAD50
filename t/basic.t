package main;

use strict;
use warnings;

use Test;


my $test_num = 1;
my %odd_os = map {$_ => 1} qw{};
my $skip = $odd_os{$^O} ? "binmode doesn't work under $^O" : '';

use constant ENCODING => 'RAD50';

use Encode;

my @tests = (
    '   ' => 0,
    FOO => 10215,
    BAR => 3258,
    'A B' => 1602,
    '  A' => 1,
    ' AB' => 42,
    'A#C' => 2763,	# Invalid, encodes as 'A?C'.
    'AXM' => 2573,	# <cr><lf>
    '  J' => 10,	# <lf>
);

my $loaded = eval {
    require Encode::RAD50;
    1;
};

if ($loaded) {
    plan (tests => @tests * 2 + 2);
} else {
    plan (tests => 1);
}

print "# Test 1 - Loading Encode::RAD50\n";
ok ($loaded);
$loaded or exit;

my $written = '';
unless ($skip) {
    open (my $fh, '>', \$written) or $skip = "PerlIO unsupported";
    close $fh;
}
Encode::RAD50->silence_warnings (1);

$test_num++;
print "# Test $test_num - Put temp file in RAD50 mode.\n";
{
    $written = '';
    $skip or open (my $fh, '>', \$written);
    skip ($skip, binmode $fh, ":encoding(@{[ENCODING]})");
    $skip or close $fh;
}

while (@tests) {
    my $string = shift @tests;
    my $value = shift @tests;
    my $output = $string;
##  my $bytes = length ($string) * 2 / 3;  # assumes $string a multiple of 3.
    my $tplt = 'n';		# 16 bits, big-endian. Assumes 3 chars only.
    $output =~ tr/A-Z0-9.$ /?/c;

    $test_num++;
    print "# Test $test_num - '$string' should encode to $value.\n";
    ok (unpack ($tplt, encode (ENCODING, $string)) == $value);

    $test_num++;
    print "# Test $test_num - $value should decode to '$output'.\n";
    ok (decode (ENCODING, pack $tplt, $value) eq $output);

    $test_num++;
    print "# Test $test_num - Print '$string' to file, and check output.\n";
    my ($buffer, $skip2) = ('0', $skip);
    my $fh;
    my $written = '';
    $skip2 or open ($fh, ">:encoding(@{[ENCODING]})", \$written)
	or $skip2 = "Failed to open file: $!";
    unless ($skip2) {
	print $fh $string;
	close $fh;
	$buffer = unpack ($tplt, $written);
    }
    print "#          File contained value $buffer\n";
    print "#                Expected value $value\n";
    skip ($skip2, $buffer == $value);

    $test_num++;
    print "# Test $test_num - Read file in @{[ENCODING]}, and check value.\n";
    unless ($skip2) {
	open ($fh, "<:encoding(@{[ENCODING]})", \$written)
	    or $skip2 = "Failed to reopen file: $!";
	$skip2 or read $fh, $buffer, length ($string);
	close $fh;
    }
    skip ($skip2, $buffer eq $output);
}

1;
