#!/usr/bin/env perl

use strict;
use warnings;

use CSS::Struct::Output::Indent;
use Tags::HTML::Commons::Vote::Login;
use Tags::Output::Indent;

# Object.
my $css = CSS::Struct::Output::Indent->new;
my $tags = Tags::Output::Indent->new;
my $obj = Tags::HTML::Commons::Vote::Login->new(
        'css' => $css,
        'tags' => $tags,
);

# Process HTML and CSS..
$obj->process;
$obj->process_css;

# Print out.
print $tags->flush;
print "\n\n";
print $css->flush;

# Output:
# TODO