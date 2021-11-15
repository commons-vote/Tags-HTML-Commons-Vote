use strict;
use warnings;

use Tags::HTML::Commons::Vote::Utils;
use Test::More 'tests' => 2;
use Test::NoWarnings;

# Test.
is($Tags::HTML::Commons::Vote::Utils::VERSION, 0.01, 'Version.');
