#!/usr/bin/perl

use strict;
use warnings;

use Fcntl qw{SEEK_SET};
use File::Temp;
use Test;


my $test_num = 1;
my %odd_os = map {$_ => 1} qw{};
my $skip = $odd_os{$^O} ? "binmode doesn't work under $^O" : '';

################### We start with some black magic to print on failure.

# (It may become useful if the test is moved to ./t subdirectory.)


my $loaded;
my @tests;

use constant ENCODING => 'RAD50';

BEGIN {

# Caveat: The code assumes we're dealing with exactly three characters.

@tests = (
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

$| = 1;

plan (tests => @tests * 2 + 2);
print "# Test 1 - Loading the library.\n"}
END {print "not ok 1\n" unless $loaded;}

use Encode;
use Encode::RAD50;

$loaded = 1;
ok ($loaded);

######################### End of black magic.

my $fh;
unless ($skip) {
    $fh = File::Temp->new ();
    $skip = "Can't create temp file: $!" unless $fh;
    }
my $origin = tell $fh unless $skip;
Encode::RAD50->silence_warnings (1);

$test_num++;
print "# Test $test_num - Put temp file in RAD50 mode.\n";
skip ($skip, binmode $fh, ":encoding(@{[ENCODING]})");

while (@tests) {
    my $string = shift @tests;
    my $value = shift @tests;
    my $output = $string;
    my $bytes = length ($string) * 2 / 3;	# assumes $string a multiple of 3.
    my $tplt = 'n';		# 16 bits, big-endian. Assumes 3 characters only.
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
    seek $fh, $origin, SEEK_SET;
    print $fh $string;
    seek $fh, $origin, SEEK_SET;
    binmode $fh, ':raw';
    read $fh, $buffer, $bytes;
    $buffer = unpack ($tplt, $buffer);
    print "#          File contained value $buffer\n";
    skip ($skip, $buffer == $value);

    $test_num++;
    print "# Test $test_num - Read file in @{[ENCODING]}, and check value.\n";
    seek $fh, $origin, SEEK_SET;
    binmode $fh, ":encoding(@{[ENCODING]})";
    read $fh, $buffer, length ($string);
    skip ($skip2, $buffer eq $output);

    }
