#!/usr/bin/env perl

use strict;
use warnings;

use Tags::HTML::Commons::Vote::Vote;
use Tags::Output::Indent;

# Object.
my $tags = Tags::Output::Indent->new;
my $obj = Tags::HTML::Commons::Vote::Vote->new(
        'tags' => $tags,
);

# Process stars.
$obj->process([{
        'author' => 'Zuzana Zónová',
        'url' => 'https://upload.wikimedia.org/wikipedia/commons/a/a4/Michal_from_Czechia.jpg',
}, {
        'author' => 'Michal Josef Špaček',
        'url' => 'https://upload.wikimedia.org/wikipedia/commons/f/f4/Michal_Josef_%C5%A0pa%C4%8Dek_-_self_photo.jpg',
}, {
        'url' => 'https://upload.wikimedia.org/wikipedia/commons/7/76/Michal_Josef_%C5%A0pa%C4%8Dek_-_self_photo_3.jpg',
}]);

# Print out.
print $tags->flush;

# Output:
# TODO