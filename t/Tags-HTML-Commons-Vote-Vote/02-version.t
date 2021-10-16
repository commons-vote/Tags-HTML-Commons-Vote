use strict;
use warnings;

use Tags::HTML::Commons::Vote::Vote;
use Test::More 'tests' => 2;
use Test::NoWarnings;

# Test.
is($Tags::HTML::Commons::Vote::Vote::VERSION, 0.01, 'Version.');
