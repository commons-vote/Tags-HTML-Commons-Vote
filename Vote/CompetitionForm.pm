package Tags::HTML::Commons::Vote::CompetitionForm;

use base qw(Tags::HTML);
use strict;
use warnings;

use Class::Utils qw(set_params split_params);
use Data::HTML::Form;
use Data::HTML::Form::Input;
use Tags::HTML::Commons::Vote::Utils qw(text value);
use Tags::HTML::Form;

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
			'logo' => 'Competition logo from Wikimedia Commons',
			'organizer' => 'Organizer',
			'organizer_logo' => 'Organizer logo from Wikimedia Commons',
			'submit' => 'Save',
			'title' => 'Create competition',
			'wd_qid' => 'Wikidata QID',
		},
	};

	# Process params.
	set_params($self, @{$object_params_ar});

	my $form = Data::HTML::Form->new(
		'action' => $self->{'form_link'},
		'css_class' => $self->{'css_competition'},
		'enctype' => 'application/x-www-form-urlencoded',
		'method' => $self->{'form_method'},
		'title' => text($self, 'title'),
	);
	my $submit = Data::HTML::Form::Input->new(
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
	my ($self, $competition) = @_;

	$self->{'_fields'} = [
		Data::HTML::Form::Input->new(
			'id' => 'competition_id',
			'type' => 'hidden',
			value($self, $competition, 'id'),
		),
		Data::HTML::Form::Input->new(
			'autofocus' => 1,
			'id' => 'competition_name',
			'label' => text($self, 'competition_name'),
			'required' => 1,
			'type' => 'text',
			value($self, $competition, 'name'),
		),
		Data::HTML::Form::Input->new(
			'id' => 'logo',
			'label' => text($self, 'logo'),
			'type' => 'text',
			value($self, $competition, 'logo'),
		),
		Data::HTML::Form::Input->new(
			'id' => 'organizer',
			'label' => text($self, 'organizer'),
			'type' => 'text',
			value($self, $competition, 'organizer'),
		),
		Data::HTML::Form::Input->new(
			'id' => 'organizer_logo',
			'label' => text($self, 'organizer_logo'),
			'type' => 'text',
			value($self, $competition, 'organizer_logo'),
		),
		Data::HTML::Form::Input->new(
			'id' => 'wd_qid',
			'label' => text($self, 'wd_qid'),
			'type' => 'text',
			value($self, $competition, 'wd_qid'),
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

© 2021-2023 Michal Josef Špaček

BSD 2-Clause License

=head1 VERSION

0.01

=cut
