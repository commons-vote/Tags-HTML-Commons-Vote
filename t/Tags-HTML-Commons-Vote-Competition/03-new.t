use strict;
use warnings;

use Tags::HTML::Commons::Vote::Competition;
use Tags::Output::Raw;
use Test::More 'tests' => 3;
use Test::NoWarnings;

# Test.
my $obj = Tags::HTML::Commons::Vote::Competition->new;
isa_ok($obj, 'Tags::HTML::Commons::Vote::Competition');

# Test.
$obj = Tags::HTML::Commons::Vote::Competition->new(
	'tags' => Tags::Output::Raw->new,
);
isa_ok($obj, 'Tags::HTML::Commons::Vote::Competition');
