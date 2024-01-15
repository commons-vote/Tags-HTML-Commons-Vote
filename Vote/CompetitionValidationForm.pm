package Tags::HTML::Commons::Vote::CompetitionValidationForm;

use base qw(Tags::HTML);
use strict;
use warnings;

use Class::Utils qw(set_params split_params);
use Commons::Link;
use Data::HTML::Element::Form;
use Data::HTML::Element::Input;
use Data::HTML::Element::Option;
use Data::HTML::Element::Select;
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
		['css_competition_validation', 'form_link', 'form_method',
		'lang', 'text'], @params);
	my $self = $class->SUPER::new(@{$other_params_ar});

	$self->{'css_competition_validation'} = 'competition-validation';

	# Form link.
	$self->{'form_link'} = undef;

	# Form method.
	$self->{'form_method'} = 'get';

	# Language.
	$self->{'lang'} = 'eng';

	# Language texts.
	$self->{'text'} = {
		'eng' => {
			'competition' => 'Competition',
			'submit' => 'Save',
			'title' => 'Create competition validation',
			'validation_type' => 'Validation type',
		},
	};

	# Process params.
	set_params($self, @{$object_params_ar});

	$self->{'_commons_link'} = Commons::Link->new;

	my $form = Data::HTML::Element::Form->new(
		'action' => $self->{'form_link'},
		'css_class' => $self->{'css_competition_validation'},
		'enctype' => 'application/x-www-form-urlencoded',
		'method' => $self->{'form_method'},
		'label' => text($self, 'title'),
	);
	my $submit = Data::HTML::Element::Input->new(
		'value' => text($self, 'submit'),
		'type' => 'submit',
	);
	$self->{'_tags_form'} = Tags::HTML::Form->new(
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
	my ($self, $competition_validation, $competition, $validation_types_ar, $validation_type,
		$validation_type_options_ar) = @_;

	my ($competition_id, $competition_name);
	if (defined $competition) {
		$competition_id = $competition->id;
		$competition_name = $competition->name;
	} elsif (defined $competition_validation && defined $competition_validation->competition) {
		$competition_id = $competition_validation->competition->id;
		$competition_name = $competition_validation->competition->name;
	} else {
		err "Bad competition validation form.";
	}

	# Validation type options.
	my $selected_option_id;
	if (defined $validation_type) {
		$selected_option_id = $validation_type->id;
	} elsif (defined $competition_validation && defined $competition_validation->validation_type) {
		$selected_option_id = $competition_validation->validation_type->id;
	}
	my @options = (
		Data::HTML::Element::Option->new(
			'data' => '',
			'value' => '',
			! defined $selected_option_id ? ('selected' => 1) : (),
		),
	);
	foreach my $validation_type (@{$validation_types_ar}) {
		push @options, Data::HTML::Element::Option->new(
			'data' => $validation_type->description,
			'id' => $validation_type->id,
			'value' => $validation_type->id,
			defined $selected_option_id && $selected_option_id == $validation_type->id ? (
				'selected' => 1,
			) : ()
		);
	}

	my @specific_fields;
	foreach my $validation_type_option (@{$validation_type_options_ar}) {
		my $value;
		if (defined $competition_validation && defined $competition_validation->options) {
			foreach my $competition_validation_option (@{$competition_validation->options}) {
				if ($competition_validation_option->validation_option->option
					eq $validation_type_option->option) {

					$value = $competition_validation_option->value;
				}
			}
		}
		push @specific_fields, Data::HTML::Element::Input->new(
			'id' => $validation_type_option->option,
			'label' => $validation_type_option->description,
			'required' => 1,
			'type' => $validation_type_option->option_type,
			'value' => $value,
		);
	}

	$self->{'_fields'} = [
		Data::HTML::Element::Input->new(
			'id' => 'competition_validation_id',
			'type' => 'hidden',
			value($self, $competition_validation, 'id'),
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
		Data::HTML::Element::Select->new(
			'id' => 'validation_type_id',
			'label' => text($self, 'validation_type'),
			'options' => \@options,
			'required' => 1,
		),
		@specific_fields,
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

Tags::HTML::Commons::Vote::CompetitionValidationForm - Tags helper for section form.

=head1 SYNOPSIS

 use Tags::HTML::Commons::Vote::CompetitionValidationForm;

 my $obj = Tags::HTML::Commons::Vote::CompetitionValidationForm->new(%params);
 $obj->process($section, $competition);
 $obj->process_css;

=head1 METHODS

=head2 C<new>

 my $obj = Tags::HTML::Commons::Vote::CompetitionValidationForm->new(%params);

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

 use Tags::HTML::Commons::Vote::CompetitionValidationForm;
 use Tags::Output::Indent;

 # Object.
 my $tags = Tags::Output::Indent->new;
 my $obj = Tags::HTML::Commons::Vote::CompetitionValidationForm->new(
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
L<Data::HTML::Element::Option>,
L<Data::HTML::Element::Select>,
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
