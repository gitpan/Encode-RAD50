use Config;
use ExtUtils::MakeMaker;

##my $vers = $] >= 5.008 ? '-5.8' : '';
my $vers = '';

WriteMakefile (
	NAME => 'Encode::RAD50',
	VERSION_FROM => 'RAD50.pm',
	PREREQ_PM => {
			Encode	=> 0,
			Encode::Encoding => 0,
			},
#	'linkext' => {LINKTYPE => ''},
	'dist' => {COMPRESS => 'gzip', SUFFIX => 'gz'},
	$] >= 5.005 ? (
		AUTHOR => 'Tom Wyant (wyant@cpan.org)',
		ABSTRACT => 'Convert to and from the Rad50 character set',
##		BINARY_LOCATION => "$Config{archname}$vers/Encode-RAD50.tar.gz",
		) : (),
	);

