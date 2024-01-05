package Tags::HTML::Commons::Vote::CompetitionVotingForm;

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
use Tags::HTML::Commons::Vote::Utils qw(dt_string text value);
use Tags::HTML::Commons::Vote::Utils::Tags qw(tags_input tags_textarea);
use Tags::HTML::Element::Form;

our $VERSION = 0.01;

# Constructor.
sub new {
	my ($class, @params) = @_;

	# Create object.
	my ($object_params_ar, $other_params_ar) = split_params(
		['css_competition_voting', 'form_link', 'form_method',
		'lang', 'text'], @params);
	my $self = $class->SUPER::new(@{$other_params_ar});

	$self->{'css_competition_voting'} = 'competition-validation';

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
			'date_from' => 'Date from',
			'date_to' => 'Date to',
			'number_of_votes' => 'Number of votes (0-?)',
			'submit' => 'Save',
			'title' => 'Create competition voting',
			'voting_type' => 'Voting type',
		},
	};

	# Process params.
	set_params($self, @{$object_params_ar});

	$self->{'_commons_link'} = Commons::Link->new;

	my $form = Data::HTML::Element::Form->new(
		'action' => $self->{'form_link'},
		'css_class' => $self->{'css_competition_voting'},
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
	my ($self, $competition_voting, $voting_types_ar, $competition) = @_;

	my ($competition_id, $competition_name);
	if (defined $competition) {
		$competition_id = $competition->id;
		$competition_name = $competition->name;
	} elsif (defined $competition_voting && defined $competition_voting->competition) {
		$competition_id = $competition_voting->competition->id;
		$competition_name = $competition_voting->competition->name;
	} else {
		err "Bad competition voting form.";
	}

	# Voting type options.
	my $selected_option_id;
	if (defined $competition_voting && defined $competition_voting->voting_type) {
		$selected_option_id = $competition_voting->voting_type->id;
	}
	my @options = (
		Data::HTML::Element::Option->new(
			'data' => '',
			'value' => '',
			! defined $selected_option_id ? ('selected' => 1) : (),
		),
	);
	foreach my $voting_type (@{$voting_types_ar}) {
		push @options, Data::HTML::Element::Option->new(
			'data' => $voting_type->description,
			'id' => $voting_type->id,
			'value' => $voting_type->id,
			defined $selected_option_id && $selected_option_id == $voting_type->id ? (
				'selected' => 1,
			) : ()
		);
	}

	$self->{'_fields'} = [
		Data::HTML::Element::Input->new(
			'id' => 'competition_voting_id',
			'type' => 'hidden',
			value($self, $competition_voting, 'id'),
		),
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
			'id' => 'voting_type_id',
			'label' => text($self, 'voting_type'),
			'options' => \@options,
			'required' => 1,
		),
		Data::HTML::Element::Input->new(
			'id' => 'date_from',
			'label' => text($self, 'date_from'),
			'placeholder' => 'YYYY-MM-DD',
			'required' => 1,
			'type' => 'date',
			value($self, $competition_voting, 'dt_from', \&dt_string),
		),
		Data::HTML::Element::Input->new(
			'id' => 'date_to',
			'label' => text($self, 'date_to'),
			'placeholder' => 'YYYY-MM-DD',
			'required' => 1,
			'type' => 'date',
			value($self, $competition_voting, 'dt_to', \&dt_string),
		),
		Data::HTML::Element::Input->new(
			'id' => 'number_of_votes',
			'label' => text($self, 'number_of_votes'),
			'min' => 0,
			'type' => 'number',
			value($self, $competition_voting, 'number_of_votes'),
		),
	];

	return;
}

# Process 'Tags'.
sub _process {
	my $self = shift;

	$self->{'_tags_form'}->process(@{$self->{'_fields'}});

	return;
}

sub _process_css {
	my $self = shift;

	$self->{'_tags_form'}->process_css(@{$self->{'_fields'}});

	return;
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

Tags::HTML::Commons::Vote::CompetitionVotingForm - Tags helper for section form.

=head1 SYNOPSIS

 use Tags::HTML::Commons::Vote::CompetitionVotingForm;

 my $obj = Tags::HTML::Commons::Vote::CompetitionVotingForm->new(%params);
 $obj->process($section, $competition);
 $obj->process_css;

=head1 METHODS

=head2 C<new>

 my $obj = Tags::HTML::Commons::Vote::CompetitionVotingForm->new(%params);

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

 use Tags::HTML::Commons::Vote::CompetitionVotingForm;
 use Tags::Output::Indent;

 # Object.
 my $tags = Tags::Output::Indent->new;
 my $obj = Tags::HTML::Commons::Vote::CompetitionVotingForm->new(
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
