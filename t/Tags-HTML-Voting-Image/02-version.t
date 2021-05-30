use strict;
use warnings;

use Tags::HTML::Voting::Image;
use Test::More 'tests' => 2;
use Test::NoWarnings;

# Test.
is($Tags::HTML::Voting::Image::VERSION, 0.01, 'Version.');
