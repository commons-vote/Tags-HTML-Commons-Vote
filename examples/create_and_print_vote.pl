#!/usr/bin/env perl

use strict;
use warnings;

use Commons::Link;
use CSS::Struct::Output::Indent;
use Data::Commons::Vote::Image;
use Data::Commons::Vote::Person;
use Data::Commons::Vote::Vote;
use Data::Commons::Vote::VoteType;
use Tags::HTML::Commons::Vote::Vote;
use Tags::Output::Indent;

# Object.
my $css = CSS::Struct::Output::Indent->new;
my $tags = Tags::Output::Indent->new;
my $obj = Tags::HTML::Commons::Vote::Vote->new(
        'css' => $css,
        'tags' => $tags,
);

# Vote object.
my $db_creator = Data::Commons::Vote::Person->new(
        'name' => 'Michal Josef Spacek',
);
my $uploader = Data::Commons::Vote::Person->new(
        'name' => 'Zuzana Zonova',
);
my $voter = Data::Commons::Vote::Person->new(
        'name' => 'Jan Novak',
);
my $image = Data::Commons::Vote::Image->new(
        'comment' => 'Michal from Czechia',
        'id' => 1,
        'image' => 'Michal from Czechia.jpg',
        'uploader' => $uploader,
);
my $vote_type = Data::Commons::Vote::VoteType->new(
        'created_by' => $db_creator,
        'type' => 'public_voting',
);
my $vote = Data::Commons::Vote::Vote->new(
        'image' => $image,
        'person' => $voter,
        'vote_type' => $vote_type,
);

# Process vote.
$obj->process_css;
$obj->process($vote);

# Print out.
print "CSS\n";
print $css->flush;
print "\n\n";
print "HTML\n";
print $tags->flush;

# Output:
# CSS
# .voting-info {
#         text-align: center;
#         color: green;
#         font-size: 2em;
#         margin: 1em;
# }
# .image img {
#         width: 100%;
# }
# .voting-form {
#         border-radius: 5px;
#         background-color: #f2f2f2;
#         padding: 20px;
# }
# .voting-form input[type=submit]:hover {
#         background-color: #45a049;
# }
# .voting-form input[type=submit] {
#         width: 100%;
#         background-color: #4CAF50;
#         color: white;
#         padding: 14px 20px;
#         margin: 8px 0;
#         border: none;
#         border-radius: 4px;
#         cursor: pointer;
# }
# .voting-form input, select, textarea {
#         width: 100%;
#         padding: 12px 20px;
#         margin: 8px 0;
#         display: inline-block;
#         border: 1px solid #ccc;
#         border-radius: 4px;
#         box-sizing: border-box;
# }
# .voting-form-required {
#         color: red;
# }
# 
# HTML
# <div class="voting">
#   <div class="voting-info">
#     Not voted
#   </div>
#   <div class="image">
#     <img src="Michal from Czechia.jpg">
#     </img>
#   </div>
#   <form class="voting-form" method="get">
#     <p>
#       <input type="hidden" name="image_id" id="image_id" value="1">
#       </input>
#     </p>
#     <p>
#       <input type="submit" value="Vote">
#       </input>
#     </p>
#   </form>
# </div>