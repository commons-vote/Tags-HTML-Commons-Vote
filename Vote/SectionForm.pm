package Tags::HTML::Commons::Vote::SectionForm;

use base qw(Tags::HTML);
use strict;
use warnings;

use Class::Utils qw(set_params split_params);
use Commons::Link;
use Error::Pure qw(err);
use Tags::HTML::Commons::Vote::TagsUtils qw(tags_input tags_textarea);
use Tags::HTML::Commons::Vote::Utils qw(text value);

our $VERSION = 0.01;

# Constructor.
sub new {
	my ($class, @params) = @_;

	# Create object.
	my ($object_params_ar, $other_params_ar) = split_params(
		['css_section', 'form_link', 'form_method',
		'lang', 'text'], @params);
	my $self = $class->SUPER::new(@{$other_params_ar});

	$self->{'css_section'} = 'section';

	# Form link.
	$self->{'form_link'} = undef;

	# Form method.
	$self->{'form_method'} = 'get';

	# Language.
	$self->{'lang'} = 'eng';

	# Language texts.
	$self->{'text'} = {
		'eng' => {
			'categories' => 'Wikimedia Commons categories',
			'competition' => 'Competition',
			'number_of_votes' => 'Number of votes',
			'logo' => 'Section logo from Wikimedia Commons',
			'section_name' => 'Section name',
			'submit' => 'Save',
			'title' => 'Create section',
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
	my ($self, $section) = @_;

	$self->{'tags'}->put(
		['b', 'div'],
		['a', 'class', $self->{'css_section'}],
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
		['d', text($self, 'title')],
		['e', 'legend'],

		['b', 'p'],
		['b', 'label'],
		['a', 'for', 'competition'],
		['d', text($self, 'competition')],
		['e', 'label'],
		['b', 'span'],
		['a', 'id', 'competition'],
		['a', 'class', 'value'],
		['d', value($self, $section, 'competition_id')."TODO"],
		['e', 'span'],
		['e', 'p'],
	);
	tags_input($self, 'section_name', 'text', {
		'class' => 'value req',
		value($self, $section, 'name'),
	});
	tags_input($self, 'logo', 'text', {
		'class' => 'value',
		value($self, $section, 'logo'),
	});
	tags_input($self, 'number_of_votes', 'text', {
		'class' => 'value',
		value($self, $section, 'number_of_votes'),
	});
	tags_textarea($self, 'categories', {
		'class' => 'value req',
		'rows' => 6,
	});
	$self->{'tags'}->put(
		['b', 'button'],
		['a', 'type', 'submit'],
		['d', text($self, 'submit')],
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
		['s', '.'.$self->{'css_section'}],
		['d', 'background-color', '#f2f2f2'],
		['e'],

		['s', '.'.$self->{'css_section'}.' label'],
		['d', 'width', '20%'],
		['e'],

		['s', '.'.$self->{'css_section'}.' .value'],
		['d', 'float', 'right'],
		['d', 'width', '75%'],
		['e'],

		['s', '.req'],
		['d', 'border', '1px solid red'],
		['e'],
	);

	return;
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
