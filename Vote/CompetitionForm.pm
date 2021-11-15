package Tags::HTML::Commons::Vote::CompetitionForm;

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
		['css_competition', 'form_link', 'form_method',
		'lang', 'text'], @params);
	my $self = $class->SUPER::new(@{$other_params_ar});

	$self->{'css_competition'} = 'competition';

	# Form link.
	$self->{'form_link'} = undef;

	# Form method.
	$self->{'form_method'} = 'get';

	# Language.
	$self->{'lang'} = 'eng';

	# Language texts.
	$self->{'text'} = {
		'eng' => {
			'competition_name' => 'Competition name',
			'date_from' => 'Date from',
			'date_to' => 'Date to',
			'logo' => 'Competition logo from Wikimedia Commons',
			'number_of_votes' => 'Number of votes',
			'organizer' => 'Organizer',
			'organizer_logo' => 'Organizer logo from Wikimedia Commons',
			'sections' => 'Sections',
			'submit' => 'Save',
			'title' => 'Create competition',
		},
	};

	# Process params.
	set_params($self, @{$object_params_ar});

	$self->{'_commons_link'} = Commons::Link->new;

	# Object.
	return $self;
}

# Process 'Tags'.
sub _process {
	my ($self, $competition) = @_;

	$self->{'tags'}->put(
		['b', 'div'],
		['a', 'class', $self->{'css_competition'}],
		['b', 'form'],
		['a', 'enctype', 'application/x-www-form-urlencoded'],
	);
	if (defined $self->{'form_link'}) {
		$self->{'tags'}->put(
			['a', 'action', $self->{'form_link'}],
		);
	}
	if (defined $self->{'form_method'}) {
		$self->{'tags'}->put(
			['a', 'method', $self->{'form_method'}],
		);
	}
	$self->{'tags'}->put(
		['b', 'fieldset'],

		['b', 'legend'],
		['d', $self->_text('title')],
		['e', 'legend'],
	);
	$self->_tags_input('competition_name', 'text', {'req' => 1});
	$self->_tags_input('date_from', 'text', {'req' => 1});
	$self->_tags_input('date_to', 'text', {'req' => 1});
	$self->_tags_input('logo');
	$self->_tags_input('organizer');
	$self->_tags_input('organizer_logo');
	$self->_tags_textarea('sections', {'req' => 1});
	$self->{'tags'}->put(
		['b', 'button'],
		['a', 'type', 'submit'],
		['d', $self->_text('submit')],
		['e', 'button'],

		['e', 'fieldset'],
		['e', 'form'],
		['e', 'div'],
	);

	return;
}

sub _process_css {
	my $self = shift;

	$self->{'css'}->put(
		['s', '.'.$self->{'css_competition'}],
		['d', 'background-color', '#f2f2f2'],
		['e'],

		['s', '.'.$self->{'css_competition'}.' label'],
		['d', 'width', '20%'],
		['e'],

		['s', '.'.$self->{'css_competition'}.' input'],
		['d', 'float', 'right'],
		['d', 'width', '75%'],
		['e'],

		['s', '.'.$self->{'css_competition'}.' textarea'],
		['d', 'float', 'right'],
		['d', 'width', '75%'],
		['e'],

		['s', '.req'],
		['d', 'border', '1px solid red'],
		['e'],
	);

	return;
}

sub _tags_input {
	my ($self, $key, $input_type, $opts_hr) = @_;

	$input_type ||= 'text';

	$self->{'tags'}->put(
		['b', 'p'],

		['b', 'label'],
		['a', 'for', $key],
		['d', $self->_text($key)],
		['e', 'label'],

		['b', 'input'],
		['a', 'type', $input_type],
		['a', 'id', $key],
		['a', 'name', $key],
		(exists $opts_hr->{'req'} && $opts_hr->{'req'}) ? (
			['a', 'class', 'req'],
		) : (),
		exists $opts_hr->{'size'} ? (
			['a', 'size', $opts_hr->{'size'}],
		) : (),
		['e', 'input'],

		['e', 'p'],
	);

	return;
}

sub _tags_textarea {
	my ($self, $key, $opts_hr) = @_;

	$self->{'tags'}->put(
		['b', 'p'],

		['b', 'label'],
		['a', 'for', $key],
		['d', $self->_text($key)],
		['e', 'label'],

		['b', 'textarea'],
		['a', 'id', $key],
		['a', 'name', $key],
		(exists $opts_hr->{'req'} && $opts_hr->{'req'}) ? (
			['a', 'class', 'req'],
		) : (),
		exists $opts_hr->{'cols'} ? (
			['a', 'cols', $opts_hr->{'cols'}],
		) : (),
		exists $opts_hr->{'rows'} ? (
			['a', 'rows', $opts_hr->{'rows'}],
		) : (),
		['e', 'textarea'],
		['e', 'p'],
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

Tags::HTML::Commons::Vote::CompetitionForm - Tags helper for competition form.

=head1 SYNOPSIS

 use Tags::HTML::Commons::Vote::CompetitionForm;

 my $obj = Tags::HTML::Commons::Vote::CompetitionForm->new(%params);
 $obj->process($competition_hr);

=head1 METHODS

=head2 C<new>

 my $obj = Tags::HTML::Commons::Vote::CompetitionForm->new(%params);

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

 use Tags::HTML::Commons::Vote::CompetitionForm;
 use Tags::Output::Indent;

 # Object.
 my $tags = Tags::Output::Indent->new;
 my $obj = Tags::HTML::Commons::Vote::CompetitionForm->new(
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
