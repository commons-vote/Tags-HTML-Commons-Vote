package Tags::HTML::Commons::Vote::PersonRoleForm;

use base qw(Tags::HTML);
use strict;
use warnings;

use Class::Utils qw(set_params split_params);
use Data::HTML::Form;
use Data::HTML::Form::Input;
use Data::HTML::Form::Select;
use Data::HTML::Form::Select::Option;
use Error::Pure qw(err);
use Tags::HTML::Commons::Vote::Utils qw(text value);
use Tags::HTML::Form;

our $VERSION = 0.01;

# Constructor.
sub new {
	my ($class, @params) = @_;

	# Create object.
	my ($object_params_ar, $other_params_ar) = split_params(
		['css_competition_validation', 'form_link', 'form_method',
		'lang', 'text'], @params);
	my $self = $class->SUPER::new(@{$other_params_ar});

	$self->{'css_person_role'} = 'person-role';

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
			'title' => 'Create person role for competition',
			'wm_username' => 'Wikimedia username',
			'role' => 'Role',
		},
	};

	# Process params.
	set_params($self, @{$object_params_ar});

	my $form = Data::HTML::Form->new(
		'action' => $self->{'form_link'},
		'css_class' => $self->{'css_person_role'},
		'enctype' => 'application/x-www-form-urlencoded',
		'method' => $self->{'form_method'},
		'label' => text($self, 'title'),
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
	my ($self, $person_role, $roles_ar, $competition) = @_;

	my ($competition_id, $competition_name);
	if (defined $competition) {
		$competition_id = $competition->id;
		$competition_name = $competition->name;
	} elsif (defined $person_role && defined $person_role->competition) {
		$competition_id = $person_role->competition->id;
		$competition_name = $person_role->competition->name;
	} else {
		err "Bad person role form.";
	}

	# Roles.
	my $selected_role_id;
	if (defined $person_role && defined $person_role->role) {
		$selected_role_id = $person_role->role->id;
	}
	my @roles;
	if (@{$roles_ar} > 1) {
		push @roles, (
			Data::HTML::Form::Select::Option->new(
				'data' => '',
				'value' => '',
				! defined $selected_role_id ? ('selected' => 1) : (),
			),
		);
	}
	foreach my $role (@{$roles_ar}) {
		push @roles, Data::HTML::Form::Select::Option->new(
			'data' => $role->description,
			'id' => $role->id,
			'value' => $role->id,
			defined $selected_role_id && $selected_role_id == $role->id ? (
				'selected' => 1,
			) : ()
		);
	}

	$self->{'_fields'} = [
		Data::HTML::Form::Input->new(
			'id' => 'person_role_id',
			'type' => 'hidden',
			value($self, $person_role, 'id'),
		),
		Data::HTML::Form::Input->new(
			'label' => text($self, 'competition'),
			'disabled' => 1,
			'type' => 'text',
			'value' => $competition_name,
		),
		Data::HTML::Form::Input->new(
			'id' => 'competition_id',
			'type' => 'hidden',
			'value' => $competition_id,
		),
		Data::HTML::Form::Input->new(
			'id' => 'wm_username',
			'label' => text($self, 'wm_username'),
			'required' => 1,
			'type' => 'text',
		),
		Data::HTML::Form::Select->new(
			'id' => 'role_id',
			'label' => text($self, 'role'),
			'options' => \@roles,
			'required' => 1,
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

Tags::HTML::Commons::Vote::PersonRoleForm - Tags helper for section form.

=head1 SYNOPSIS

 use Tags::HTML::Commons::Vote::PersonRoleForm;

 my $obj = Tags::HTML::Commons::Vote::PersonRoleForm->new(%params);
 $obj->process($section, $competition);
 $obj->process_css;

=head1 METHODS

=head2 C<new>

 my $obj = Tags::HTML::Commons::Vote::PersonRoleForm->new(%params);

Constructor.

=over 8

=item * C<css_person_role>

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

 use Tags::HTML::Commons::Vote::PersonRoleForm;
 use Tags::Output::Indent;

 # Object.
 my $tags = Tags::Output::Indent->new;
 my $obj = Tags::HTML::Commons::Vote::PersonRoleForm->new(
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
L<Data::HTML::Form>,
L<Data::HTML::Form::Input>,
L<Data::HTML::Form::Select>,
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
