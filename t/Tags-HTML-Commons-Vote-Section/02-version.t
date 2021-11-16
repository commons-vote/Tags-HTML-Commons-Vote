use strict;
use warnings;

use Tags::HTML::Commons::Vote::Section;
use Test::More 'tests' => 2;
use Test::NoWarnings;

# Test.
is($Tags::HTML::Commons::Vote::Section::VERSION, 0.01, 'Version.');
