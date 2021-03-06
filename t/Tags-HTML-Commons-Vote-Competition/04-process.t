use strict;
use warnings;

use Data::Commons::Vote::Competition;
use DateTime;
use English;
use Error::Pure::Utils qw(clean);
use Tags::HTML::Commons::Vote::Competition;
use Tags::Output::Structure;
use Test::More 'tests' => 4;
use Test::NoWarnings;
use Unicode::UTF8 qw(decode_utf8);

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
		'id' => 1,
		'name' => 'Czech Wiki Photo',
		'dt_from' => DateTime->new(
			'day' => 10,
			'month' => 10,
			'year' => 2021,
		),
		'dt_to' => DateTime->new(
			'day' => 20,
			'month' => 11,
			'year' => 2021,
		),
	),
);
$ret_ar = $tags->flush(1);
is_deeply(
	$ret_ar,
	[
		['b', 'div'],
		['a', 'class', 'competition'],
		['b', 'a'],
		['a', 'class', 'button right'],
		['a', 'href', '/competition_form/1'],
		['d', 'Edit competition'],
		['e', 'a'],
		['b', 'h1'],
		['d', 'Czech Wiki Photo'],
		['e', 'h1'],
		['b', 'dl'],
		['b', 'dt'],
		['d', 'Date from'],
		['e', 'dt'],
		['b', 'dd'],
		['d', '2021-10-10T00:00:00'],
		['e', 'dd'],
		['b', 'dt'],
		['d', 'Date to'],
		['e', 'dt'],
		['b', 'dd'],
		['d', '2021-11-20T00:00:00'],
		['e', 'dd'],
		['b', 'dt'],
		['d', 'Sections'],
		['e', 'dt'],
		['b', 'dd'],
		['b', 'a'],
		['a', 'class', 'button'],
		['a', 'href', '/section_form/?action=add&competition_id=1'],
		['d', 'Add section'],
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
