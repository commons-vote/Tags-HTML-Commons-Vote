package Tags::HTML::Commons::Vote::Menu;

use base qw(Tags::HTML);
use strict;
use warnings;

use Class::Utils qw(set_params split_params);
use Commons::Link;
use Error::Pure qw(err);
use Tags::HTML::Commons::Vote::Utils qw(text);

our $VERSION = 0.01;

# Constructor.
sub new {
	my ($class, @params) = @_;

	# Create object.
	my ($object_params_ar, $other_params_ar) = split_params(
		['css_main', 'lang', 'logo', 'logout_url', 'text'], @params);
	my $self = $class->SUPER::new(@{$other_params_ar});

	$self->{'css_main'} = 'menu';

	# Language.
	$self->{'lang'} = 'eng';

	# Logo.
	# TODO Change default.
	$self->{'logo'} = 'Wikimedia CZ - vertical logo - Czech version.svg';

	# Logo width in pixels.
	$self->{'logo_width'} = 100;

	# Logout URL.
	$self->{'logout_url'} = undef;

	# Language texts.
	$self->{'text'} = {
		'eng' => {
			'logout' => 'Log out',
		},
	};

	# Process params.
	set_params($self, @{$object_params_ar});

	# Check logout url.
	if (! defined $self->{'logout_url'}) {
		err "Parameter 'logout_url' is required.";
	}

	# Commons::Link.
	$self->{'commons_link'} = Commons::Link->new;

	# Object.
	return $self;
}

# Process 'Tags'.
sub _process {
	my ($self, $data_hr) = @_;

	$self->{'tags'}->put(
		['b', 'header'],
		['a', 'class', $self->{'css_main'}],

		['b', 'div'],
		['a', 'id', 'container'],

		# Left menu part.
		['b', 'span'],
		['a', 'id', 'menu-left'],

		# Logo.
		['b', 'img'],
		['a', 'id', 'logo'],
		['a', 'src', $self->{'commons_link'}->thumb_link($self->{'logo'}, $self->{'logo_width'})],
		['a', 'alt', 'logo'],
		['e', 'img'],

		# Actual section.
		defined $data_hr->{'section'} ? (
			['b', 'span'],
			['a', 'id', 'section'],
			['d', $data_hr->{'section'}],
			['e', 'span'],
		) : (),

		['e', 'span'],

		# Right menu part.
		defined $data_hr->{'login_name'} ? (
			['b', 'span'],
			['a', 'id', 'menu-right'],

			['b', 'span'],
			['a', 'id', 'login'],
			# Login name
			['d', $data_hr->{'login_name'}],
			# Logout link
			['d', '('],
			['b', 'a'],
			['a', 'href', $self->{'logout_url'}],
			['d', text($self, 'logout')],
			['e', 'a'],
			['d', ')'],
			['e', 'span'],

			['e', 'span'],
		) : (),

		['e', 'div'],

		['e', 'header'],
	);

	return;
}

sub _process_css {
	my $self = shift;

	$self->{'css'}->put(
		['s', '.'.$self->{'css_main'}],
		['d', 'border-bottom', '1px solid black'],
		['d', 'line-height', '100px'],
		['e'],

		['s', '#menu-left #logo'],
		['d', 'vertical-align', 'middle'],
		['e'],

		['s', '#menu-left #section'],
		['d', 'vertical-align', 'middle'],
		['d', 'padding-left', '10px'],
		['e'],

		['s', '#menu-right'],
		['d', 'float', 'right'],
		['e'],

		['s', '#menu-right #login'],
		['d', 'vertical-align', 'middle'],
		['e'],
	);

	return;
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

Tags::HTML::Commons::Vote::Menu - Tags helper for menu.

=head1 SYNOPSIS

 use Tags::HTML::Commons::Vote::Menu;

 my $obj = Tags::HTML::Commons::Vote::Menu->new(%params);
 $obj->process($data_hr);

=head1 METHODS

=head2 C<new>

 my $obj = Tags::HTML::Commons::Vote::Menu->new(%params);

Constructor.

Returns instance of object.

=over 8

=item * C<css_competition>

CSS class for root div element.

Default value is 'competition'.

=item * C<TODO>

TODO

=item * C<tags>

'Tags::Output' object.

Default value is undef.

=back

=head2 C<process>

 $obj->process($data_hr);

Process Tags structure for output with information about menu.
Structure consists from:
 {
         'login_name' => __LOGIN_NAME__ (optional - default is 'Login name')
         'section' => __SECTION__ (optional - default is 'Section')
 }

Returns undef.

=head1 ERRORS

 new():
         From Class::Utils::set_params():
                 Unknown parameter '%s'.
         Parameter 'logout_url' is required.

=head1 EXAMPLE1

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

=head1 DEPENDENCIES

L<Class::Utils>,
L<Commons::link>,
L<Error::Pure>,
L<Tags::HTML>,
L<Tags::HTML::Commons::Vote::Utils>.

=head1 SEE ALSO

=over

TODO

=back

=head1 REPOSITORY

L<https://github.com/michal-josef-spacek/Tags-HTML-Commons-Vote>

=head1 AUTHOR

Michal Josef Špaček L<mailto:skim@cpan.org>

L<http://skim.cz>

=head1 LICENSE AND COPYRIGHT

© Michal Josef Špaček 2021

BSD 2-Clause License

=head1 VERSION

0.01

=cut
