package Tags::HTML::Commons::Vote::Login;

use base qw(Tags::HTML);
use strict;
use warnings;

use Class::Utils qw(set_params split_params);
use Tags::HTML::Commons::Vote::Utils qw(text);
use Tags::HTML::Login::Button;

our $VERSION = 0.01;

# Constructor.
sub new {
	my ($class, @params) = @_;

	# Create object.
	my ($object_params_ar, $other_params_ar) = split_params(
		['css_login', 'lang', 'text'], @params);
	my $self = $class->SUPER::new(@{$other_params_ar});

	$self->{'css_login'} = 'login';

	# Language.
	$self->{'lang'} = 'eng';

	# Login link.
	$self->{'login_link'} = 'login';

	# Language texts.
	$self->{'text'} = {
		'eng' => {
			'login_button_title' => 'Login with OAuth2'
		},
	};

	# Process params.
	set_params($self, @{$object_params_ar});

	$self->{'_html_login'} = Tags::HTML::Login::Button->new(
		'css' => $self->{'css'},
		'link' => $self->{'login_link'},
		'tags' => $self->{'tags'},
		'title' => text($self, 'login_button_title'),
	);

	# Object.
	return $self;
}

# Process 'Tags'.
sub _process {
	my $self = shift;

	# TODO Background.
	# TODO Information about author to background.
	# TODO Rectangle over login button

	$self->{'tags'}->put(
		['b', 'div'],
		['a', 'class', $self->{'css_login'}],
	);
	$self->{'_html_login'}->process;
	$self->{'tags'}->put(
		['e', 'div'],
	);

	return;
}

sub _process_css {
	my $self = shift;

	$self->{'css'}->put(
		['s', '.'.$self->{'css_login'}],
		['d', 'margin', '1em'],
		['e'],
	);
	$self->{'_html_login'}->process_css;

	return;
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

Tags::HTML::Commons::Vote::Login - Tags helper for login page.

=head1 SYNOPSIS

 use Tags::HTML::Commons::Vote::Login;

 my $obj = Tags::HTML::Commons::Vote::Login->new(%params);
 $obj->process;
 $obj->process_css;

=head1 METHODS

=head2 C<new>

 my $obj = Tags::HTML::Commons::Vote::Login->new(%params);

Constructor.

=over 8

=item * C<css>

TODO

=item * C<css_login>

CSS class for root div element.

Default value is 'login'.

=item * C<lang>

TODO

=item * C<lang>

TODO

=item * C<login_link>

TODO

=item * C<text>

TODO

=item * C<tags>

'Tags::Output' object.

Default value is undef.

=back

=head2 C<process>

 $obj->process;

Process Tags structure for output of login page.

Returns undef.

=head1 ERRORS

 new():
         From Class::Utils::set_params():
                 Unknown parameter '%s'.

=head1 EXAMPLE1

=for comment filename=commons_vote_login.pl

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

=head1 DEPENDENCIES

L<Class::Utils>,
L<Tags::HTML>,
L<Tags::HTML::Commons::Vote::Utils>,
L<Tags::HTML::Login::Button>.

=head1 REPOSITORY

L<https://github.com/michal-josef-spacek/Tags-HTML-Commons-Vote>

=head1 AUTHOR

Michal Josef Špaček L<mailto:skim@cpan.org>

L<http://skim.cz>

=head1 LICENSE AND COPYRIGHT

© 2021-2022 Michal Josef Špaček

BSD 2-Clause License

=head1 VERSION

0.01

=cut
