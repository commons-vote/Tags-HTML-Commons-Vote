#!/usr/bin/env perl

use strict;
use warnings;

use Tags::HTML::Commons::Vote::Menu;
use Tags::Output::Indent;

# Object.
my $tags = Tags::Output::Indent->new;
my $obj = Tags::HTML::Commons::Vote::Menu->new(
        'logout_url' => 'https://example.com/logout',
        'tags' => $tags,
);

# Process list of competitions.
$obj->process({
        'login_name' => 'Skim',
        'section' => 'Application',
});

# Print out.
print $tags->flush;

# Output:
# <header class="menu">
#   <div id="container">
#     <span id="menu-left">
#       <img id="logo" src=
#         "http://upload.wikimedia.org/wikipedia/commons/thumb/7/79/Wikimedia_CZ_-_vertical_logo_-_Czech_version.svg/100px-Wikimedia_CZ_-_vertical_logo_-_Czech_version.png"
#         alt="logo">
#       </img>
#       <span id="section">
#         Application
#       </span>
#     </span>
#     <span id="menu-right">
#       <span id="login">
#         Skim
#         (
#         <a href="https://example.com/logout">
#           Log out
#         </a>
#         )
#       </span>
#     </span>
#   </div>
# </header>