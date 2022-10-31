use strict;
use warnings;

use Data::Commons::Vote::Competition;
use Data::Commons::Vote::Person;
use DateTime;
use English;
use Error::Pure::Utils qw(clean);
use Tags::HTML::Commons::Vote::Competition;
use Tags::Output::Structure;
use Test::More 'tests' => 4;
use Test::NoWarnings;
use Unicode::UTF8 qw(decode_utf8);

# Common.
my $creator = Data::Commons::Vote::Person->new(
	'name' => decode_utf8('Michal Josef Špaček'),
);

# Test.
my $tags = Tags::Output::Structure->new;
my $obj = Tags::HTML::Commons::Vote::Competition->new(
	'tags' => $tags,
);
$obj->process;
my $ret_ar = $tags->flush(1);
is_deeply(
	$ret_ar,
	[
		['d', "Competition doesn't exist."],
	],
	'Competition HTML code (no competition).',
);

# Test.
$tags = Tags::Output::Structure->new;
$obj = Tags::HTML::Commons::Vote::Competition->new(
	'tags' => $tags,
);
$obj->process(
	Data::Commons::Vote::Competition->new(
		'created_by' => $creator,
		'id' => 1,
		'name' => 'Czech Wiki Photo',
	),
);
$ret_ar = $tags->flush(1);
is_deeply(
	$ret_ar,
	[
		['b', 'div'],
		['a', 'class', 'competition'],
		['b', 'div'],
		['a', 'class', 'right button-list'],
		['b', 'a'],
		['a', 'class', 'button'],
		['a', 'href', '/competition_form/1'],
		['d', 'Edit competition'],
		['e', 'a'],
		['b', 'a'],
		['a', 'class', 'button'],
		['a', 'href', '/logs/1'],
		['d', 'View logs'],
		['e', 'a'],
		['e', 'div'],
		['b', 'h1'],
		['d', 'Czech Wiki Photo'],
		['e', 'h1'],
		['b', 'dl'],
		['b', 'dt'],
		['d', 'Voting types'],
		['e', 'dt'],
		['b', 'dd'],
		['b', 'a'],
		['a', 'class', 'button'],
		['a', 'href', '/voting_form/?competition_id=1'],
		['d', 'Add voting type'],
		['e', 'a'],
		['e', 'dd'],
		['b', 'dt'],
		['d', 'Roles'],
		['e', 'dt'],
		['b', 'dd'],
		['b', 'a'],
		['a', 'class', 'button'],
		['a', 'href', '/role_form/?competition_id=1'],
		['d', 'Add role'],
		['e', 'a'],
		['e', 'dd'],
		['b', 'dt'],
		['d', 'Sections'],
		['e', 'dt'],
		['b', 'dd'],
		['b', 'a'],
		['a', 'class', 'button'],
		['a', 'href', '/section_form/?competition_id=1'],
		['d', 'Add section'],
		['e', 'a'],
		['e', 'dd'],
		['b', 'dt'],
		['d', 'Validations'],
		['e', 'dt'],
		['b', 'dd'],
		['b', 'a'],
		['a', 'class', 'button'],
		['a', 'href', '/validation_form/?competition_id=1'],
		['d', 'Add validation'],
		['e', 'a'],
		['e', 'dd'],
		['e', 'dl'],
		['e', 'div'],
	],
	'Competition HTML code (no competition).',
);

# Test.
$tags = Tags::Output::Structure->new;
$obj = Tags::HTML::Commons::Vote::Competition->new(
	'tags' => $tags,
);
eval {
	$obj->process('bad');
};
is($EVAL_ERROR, "Bad competition object.\n", "Bad competition object.");
