#!/usr/bin/env perl

use strict;
use warnings;

use Tags::HTML::Commons::Vote::Competition;
use Tags::Output::Indent;

# Object.
my $tags = Tags::Output::Indent->new;
my $obj = Tags::HTML::Commons::Vote::Competition->new(
        'tags' => $tags,
);

# Process list of competitions.
$obj->process({
        'id' => 1,
        'name' => 'Czech Wiki Photo',
        'date_from' => '10.10.2021',
        'date_to' => '20.11.2021',
}]);

# Print out.
print $tags->flush;

# Output:
# TODO