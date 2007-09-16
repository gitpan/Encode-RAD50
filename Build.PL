use strict;
use warnings;

use Module::Build;
use Config;
use FileHandle;

our $VERSION = '0.002';

my $bldr = Module::Build->new (
	dist_author => 'Tom Wyant (wyant at cpan dot org)',
	dist_abstract => 'Convert to and from the Rad50 character set',
	module_name => 'Encode::RAD50',
	requires => {
	    Encode	=> 0,
	    'Encode::Encoding' => 0,
	},
#	dist_version_from => 'ECI.pm',
#	dynamic_config => 1,
	license => 'perl',
	);

$bldr->create_build_script ();
