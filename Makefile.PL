use Config;
use ExtUtils::MakeMaker;

##my $vers = $] >= 5.008 ? '-5.8' : '';
my $vers = '';

WriteMakefile (
	NAME => 'Encode::RAD50',
	VERSION_FROM => 'lib/Encode/RAD50.pm',
	PREREQ_PM => {
			Encode	=> 0,
			Encode::Encoding => 0,
			},
	PL_FILES => {},	# Prevent old MakeMaker from running Build.PL
	'dist' => {COMPRESS => 'gzip', SUFFIX => 'gz'},
	$] >= 5.005 ? (
		AUTHOR => 'Tom Wyant (wyant@cpan.org)',
		ABSTRACT => 'Convert to and from the Rad50 character set',
##		BINARY_LOCATION => "$Config{archname}$vers/Encode-RAD50.tar.gz",
		(ExtUtils::MakeMaker->VERSION >= 6.31 ?
		    (LICENSE => 'perl') : ())
		) : (),
	);

