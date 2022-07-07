#!/usr/bin/env perl

use strict;
use warnings;

use Data::Commons::Vote::Competition;
use DateTime;
use Tags::HTML::Commons::Vote::Competitions;
use Tags::Output::Indent;

# Object.
my $tags = Tags::Output::Indent->new;
my $obj = Tags::HTML::Commons::Vote::Competitions->new(
        'tags' => $tags,
);

# Process list of competitions.
$obj->process([
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
        Data::Commons::Vote::Competition->new(
                'id' => 2,
                'name' => 'Foo Bar',
                'dt_from' => DateTime->new(
                        'day' => 30,
                        'month' => 10,
                        'year' => 2021,
                ),
                'dt_to' => DateTime->new(
                        'day' => 20,
                        'month' => 11,
                        'year' => 2021,
                ),
        ),
]);

# Print out.
print $tags->flush;

# Output:
# TODO