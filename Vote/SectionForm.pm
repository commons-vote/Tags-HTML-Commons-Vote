package Tags::HTML::Commons::Vote::SectionForm;

use base qw(Tags::HTML);
use strict;
use warnings;

use Class::Utils qw(set_params split_params);
use Commons::Link;
use Data::HTML::Element::Form;
use Data::HTML::Element::Input;
use Data::HTML::Element::Textarea;
use Error::Pure qw(err);
use Tags::HTML::Commons::Vote::Utils qw(text value);
use Tags::HTML::Commons::Vote::Utils::Tags qw(tags_input tags_textarea);
use Tags::HTML::Element::Form;

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
			'categories_placeholder' => 'List of Wikimedia Commons categories one per line',
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

	my $form = Data::HTML::Element::Form->new(
		'action' => $self->{'form_link'},
		'css_class' => $self->{'css_section'},
		'enctype' => 'application/x-www-form-urlencoded',
		'method' => $self->{'form_method'},
		'label' => text($self, 'title'),
	);
	my $submit = Data::HTML::Element::Input->new(
		'value' => text($self, 'submit'),
		'type' => 'submit',
	);
	$self->{'_tags_form'} = Tags::HTML::Element::Form->new(
		'css' => $self->{'css'},
		'form' => $form,
		'submit' => $submit,
		'tags' => $self->{'tags'},
	);

	# Object.
	return $self;
}

sub _cleanup {
	my $self = shift;

	delete $self->{'_fields'};

	return;
}

sub _init {
	my ($self, $section, $competition) = @_;

	if (exists $self->{'_fields'}) {
		return;
	}

	my ($competition_id, $competition_name);
	if (defined $competition) {
		$competition_id = $competition->id;
		$competition_name = $competition->name;
	} elsif (defined $section && defined $section->competition) {
		$competition_id = $section->competition->id;
		$competition_name = $section->competition->name;
	} else {
		err "Bad section form.";
	}
	$self->{'_fields'} = [
		Data::HTML::Element::Input->new(
			'id' => 'section_id',
			'type' => 'hidden',
			value($self, $section, 'id'),
		),
		# TODO Rewrite to printable form. Add link to competition page.
		Data::HTML::Element::Input->new(
			'label' => text($self, 'competition'),
			'disabled' => 1,
			'type' => 'text',
			'value' => $competition_name,
		),
		Data::HTML::Element::Input->new(
			'id' => 'competition_id',
			'type' => 'hidden',
			'value' => $competition_id,
		),
		Data::HTML::Element::Input->new(
			'id' => 'section_name',
			'label' => text($self, 'section_name'),
			'type' => 'text',
			'required' => 1,
			value($self, $section, 'name'),
		),
		Data::HTML::Element::Input->new(
			'id' => 'logo',
			'label' => text($self, 'logo'),
			'type' => 'text',
			value($self, $section, 'logo'),
		),
		Data::HTML::Element::Input->new(
			'id' => 'number_of_votes',
			'label' => text($self, 'number_of_votes'),
			'min' => 0,
			'type' => 'number',
			value($self, $section, 'number_of_votes'),
		),
		Data::HTML::Element::Textarea->new(
			'id' => 'categories',
			'label' => text($self, 'categories'),
			'placeholder' => text($self, 'categories_placeholder'),
			'requires' => 1,
			'rows' => 6,
			value($self, $section, 'categories', sub {
				my $categories_ar = shift;
				return join "\r\n", map { $_->category } @{$categories_ar};
			}),
		),
	];
	$self->{'_tags_form'}->init(@{$self->{'_fields'}});

	return;
}

# Process 'Tags'.
sub _process {
	my $self = shift;

	$self->{'_tags_form'}->process;

	return;
}

sub _process_css {
	my $self = shift;

	$self->{'_tags_form'}->process_css;

	return;
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

Tags::HTML::Commons::Vote::SectionForm - Tags helper for section form.

=head1 SYNOPSIS

 use Tags::HTML::Commons::Vote::SectionForm;

 my $obj = Tags::HTML::Commons::Vote::SectionForm->new(%params);
 $obj->process($section, $competition);
 $obj->process_css;

=head1 METHODS

=head2 C<new>

 my $obj = Tags::HTML::Commons::Vote::SectionForm->new(%params);

Constructor.

=over 8

=item * C<css_section>

CSS class for root div element.

Default value is 'section'.

=item * C<TODO>

TODO

=item * C<tags>

'Tags::Output' object.

Default value is undef.

=back

=head2 C<process>

 $obj->process($section, $competition);

Process Tags structure for HTML output with section and competition objects.
C<$section> is L<Data::Commons::Vote::Section> object. C<$competition> is
L<Data::Commons::Vote::Competition> object.

Returns undef.

=head2 C<process_css>

 $obj->process_css;

Process CSS::Struct for CSS output.

Returns undef.

=head1 ERRORS

 new():
         From Class::Utils::set_params():
                 Unknown parameter '%s'.

=head1 EXAMPLE1

 use strict;
 use warnings;

 use Tags::HTML::Commons::Vote::SectionForm;
 use Tags::Output::Indent;

 # Object.
 my $tags = Tags::Output::Indent->new;
 my $obj = Tags::HTML::Commons::Vote::SectionForm->new(
         'tags' => $tags,
 );

 # Process section.
 $obj->process($section);

 # Print out.
 print $tags->flush;

 # Output:
 # TODO

=head1 DEPENDENCIES

L<Class::Utils>,
L<Data::HTML::Element::Form>,
L<Data::HTML::Element::Input>,
L<Data::HTML::Element::Textarea>,
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

© 2021-2023 Michal Josef Špaček

BSD 2-Clause License

=head1 VERSION

0.01

=cut
