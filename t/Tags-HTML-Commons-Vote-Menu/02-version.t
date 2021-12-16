use strict;
use warnings;

use Tags::HTML::Commons::Vote::Menu;
use Test::More 'tests' => 2;
use Test::NoWarnings;

# Test.
is($Tags::HTML::Commons::Vote::Menu::VERSION, 0.01, 'Version.');
