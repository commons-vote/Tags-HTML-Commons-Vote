use strict;
use warnings;

use Tags::HTML::Commons::Vote::CompetitionForm;
use Tags::Output::Raw;
use Test::More 'tests' => 3;
use Test::NoWarnings;

# Test.
my $obj = Tags::HTML::Commons::Vote::CompetitionForm->new;
isa_ok($obj, 'Tags::HTML::Commons::Vote::CompetitionForm');

# Test.
$obj = Tags::HTML::Commons::Vote::CompetitionForm->new(
	'tags' => Tags::Output::Raw->new,
);
isa_ok($obj, 'Tags::HTML::Commons::Vote::CompetitionForm');
