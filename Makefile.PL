use lib '.';
use strict;
use warnings;

use inc::Module::Install;

# Definition.
abstract 'Tags helper classes for Wikimedia Commons voting.';
author 'Michal Josef Spacek <skim@cpan.org>';
author_requires 'English' => 0;
author_requires 'File::Object' => 0.03;
author_requires 'Test::More' => 0;
author_requires 'Test::NoWarnings' => 0;
author_requires 'Test::Pod' => 0;
author_requires 'Test::Pod::Coverage' => 0;
license 'bsd';
name 'Tags-HTML-Commons-Vote';
readme_from 'Vote.pm';
recursive_author_tests('xt');
requires 'Class::Utils' => 0.02;
requires 'Commons::Link' => 0;
requires 'Data::HTML::Element::Form' => 0;
requires 'Data::HTML::Element::Input' => 0;
requires 'Data::HTML::Element::Select' => 0;
requires 'Data::HTML::Element::Option' => 0;
requires 'Data::HTML::Element::Textarea' => 0;
requires 'DateTime::Format::Strptime' => 0;
requires 'Error::Pure' => 0.07;
requires 'Readonly' => 0;
requires 'Scalar::Util' => 0;
requires 'Tags::HTML' => 0.06;
requires 'Tags::HTML::Element::Form' => 0;
requires 'Tags::HTML::Image' => 0;
requires 'Unicode::UTF8' => 0;
requires 'perl' => '5.8.0';
resources 'bugtracker' => 'https://github.com/michal-josef-spacek/Tags-HTML-Commons-Vote/issues';
resources 'homepage' => 'https://github.com/michal-josef-spacek/Tags-HTML-Commons-Vote';
resources 'repository' => 'git://github.com/michal-josef-spacek/Tags-HTML-Commons-Vote';
test_requires 'English' => 0;
test_requires 'Error::Pure::Utils' => 0.22;
test_requires 'File::Object' => 0.03;
test_requires 'Tags::Output::Raw' => 0;
test_requires 'Test::More' => 0;
test_requires 'Test::NoWarnings' => 0;
tests_recursive;
version '0.01';

# Run.
WriteAll();
