package Tags::HTML::Commons::Vote::Main;

use base qw(Tags::HTML);
use strict;
use warnings;

use Class::Utils qw(set_params split_params);
use Commons::Link;
use Error::Pure qw(err);

our $VERSION = 0.01;

# Constructor.
sub new {
	my ($class, @params) = @_;

	# Create object.
	my ($object_params_ar, $other_params_ar) = split_params(
		['css_main', 'lang', 'text'], @params);
	my $self = $class->SUPER::new(@{$other_params_ar});

	$self->{'css_main'} = 'main';

	# Language.
	$self->{'lang'} = 'eng';

	# Language texts.
	$self->{'text'} = {
		'eng' => {
			'create_competition' => 'Create competition',
			'my_competitions' => 'My competitions',
		},
	};

	# Process params.
	set_params($self, @{$object_params_ar});

	# Object.
	return $self;
}

# Process 'Tags'.
sub _process {
	my ($self, $competition) = @_;

	$self->{'tags'}->put(
		['b', 'div'],
		['a', 'class', $self->{'css_main'}],

		['b', 'div'],
		['a', 'class', 'page-header'],

		['b', 'a'],
		['a', 'href', '/competition_form'],
		['d', $self->_text('create_competition')],
		['e', 'a'],

		['b', 'h1'],
		['d', $self->_text('my_competitions')],
		['e', 'h1'],

		['e', 'div'],

		['e', 'div'],
	);

	return;
}

sub _process_css {
	my $self = shift;

	$self->{'css'}->put(
		['s', '.'.$self->{'css_main'}],
		['d', 'margin', '1em'],
		['e'],

		['s', '.page-header'],
		['d', 'border-bottom', '1px solid #eee'],
		['d', 'padding-bottom', '20px'],
		['d', 'margin', '40px 0 20px 0'],
		['e'],

		['s', '.page-header a'],
		['d', 'display', 'inline-block'],
		['d', 'color', '#fff'],
		['d', 'background-color', '#337ab7'],
		['d', 'text-shadow', '0 -1px 0 rgb(0 0 0 / 20%)'],
		['d', 'box-shadow', 'inset 0 1px 0 rgb(255 255 255 / 15%), 0 1px 1px rgb(0 0 0 / 8%)'],
		['d', 'float', 'right'],
		['d', 'cursor', 'pointer'],
		['d', 'border', '1px solid transparent'],
		['d', 'border-radius', '4px'],
		['d', 'padding', '6px 12px'],
		['d', 'margin-bottom', 0],
		['d', 'font-size', '14px'],
		['d', 'font-weight', '400'],
		['d', 'text-align', 'center'],
		['d', 'white-space', 'nowrap'],
		['d', 'line-height', '1.42857143'],
		['d', 'text-decoration', 'none'],
		['e'],
	);

	return;
}

sub _text {
	my ($self, $key) = @_;

	if (! exists $self->{'text'}->{$self->{'lang'}}->{$key}) {
		err "Text for lang '$self->{'lang'}' and key '$key' doesn't exist.";
	}

	return $self->{'text'}->{$self->{'lang'}}->{$key};
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

Tags::HTML::Commons::Vote::Main - Tags helper for main page.

=head1 SYNOPSIS

 use Tags::HTML::Commons::Vote::Main;

 my $obj = Tags::HTML::Commons::Vote::Main->new(%params);
 $obj->process($competition_hr);

=head1 METHODS

=head2 C<new>

 my $obj = Tags::HTML::Commons::Vote::Main->new(%params);

Constructor.

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

 $obj->process($competition_hr);

Process Tags structure for output with competition structure.
Structure consists from:
 {
         'id' => __COMPETITION_ID__ (required)
         'name' => __NAME__ (required)
         'date_from' => __DATE_FROM__ (required)
         'date_to' => __DATE_TO__ (required)
 }

Returns undef.

=head1 ERRORS

 new():
         From Class::Utils::set_params():
                 Unknown parameter '%s'.

=head1 EXAMPLE1

 use strict;
 use warnings;

 use Tags::HTML::Commons::Vote::Main;
 use Tags::Output::Indent;

 # Object.
 my $tags = Tags::Output::Indent->new;
 my $obj = Tags::HTML::Commons::Vote::Main->new(
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

=head1 DEPENDENCIES

L<Class::Utils>,
L<Error::Pure>,
L<Tags::HTML>.

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
