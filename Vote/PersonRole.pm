package Tags::HTML::Commons::Vote::PersonRole;

use base qw(Tags::HTML);
use strict;
use warnings;

use Class::Utils qw(set_params split_params);
use Error::Pure qw(err);
use Tags::HTML::Commons::Vote::Utils qw(text value);
use Tags::HTML::Commons::Vote::Utils::CSS qw(a_button button_list float_right);
use Tags::HTML::Commons::Vote::Utils::Tags qw(tags_dl_item);
use Unicode::UTF8 qw(decode_utf8);

our $VERSION = 0.01;

# Constructor.
sub new {
	my ($class, @params) = @_;

	# Create object.
	my ($object_params_ar, $other_params_ar) = split_params(
		['css_person_role', 'lang', 'text'], @params);
	my $self = $class->SUPER::new(@{$other_params_ar});

	$self->{'css_person_role'} = 'person_role';

	# Language.
	$self->{'lang'} = 'eng';

	# Language texts.
	$self->{'text'} = {
		'eng' => {
			'competition' => 'Competition',
			'edit_person_role' => 'Edit role',
			'person' => 'Person',
			'remove_person_role' => 'Remove role',
			'person_role_not_exists' => "Role doesn't exist.",
		},
	};

	# Process params.
	set_params($self, @{$object_params_ar});

	# Object.
	return $self;
}

# Process 'Tags'.
sub _process {
	my ($self, $person_role) = @_;

	if (! defined $person_role) {
		$self->{'tags'}->put(
			['d', text($self, 'person_role_not_exists')],
		);

		return;
	}

	$self->{'tags'}->put(
		['b', 'div'],
		['a', 'class', $self->{'css_person_role'}],

		['b', 'div'],
		['a', 'class', 'right button-list'],
#		['b', 'a'],
#		['a', 'class', 'button'],
#		['a', 'href', '/role_form/'.$person_role->id],
#		['d', text($self, 'edit_person_role')],
#		['e', 'a'],

		['b', 'a'],
		['a', 'class', 'button'],
		['a', 'href', '/role_remove/'.$person_role->id],
		['d', text($self, 'remove_person_role')],
		['e', 'a'],

		['e', 'div'],

		['b', 'h1'],
		['d', $person_role->role->description],
		['e', 'h1'],

		['b', 'dl'],

		['b', 'dt'],
		['d', text($self, 'competition')],
		['e', 'dt'],
		['b', 'dd'],
		['b', 'a'],
		['a', 'href', '/competition/'.$person_role->competition->id],
		['d', $person_role->competition->name],
		['e', 'a'],
		['e', 'dd'],

		['b', 'dt'],
		['d', text($self, 'person')],
		['e', 'dt'],
		['b', 'dd'],
		['d', $person_role->person->wm_username],
		['e', 'dd'],

		['e', 'dl'],
		['e', 'div'],
	);

	return;
}

sub _process_css {
	my $self = shift;

	$self->{'css'}->put(
		['s', '.'.$self->{'css_person_role'}.' dt'],
		['d', 'font-weight', 'bold'],
		['e'],
	);
	a_button($self, '.button');
	button_list($self, '.button-list');
	float_right($self, '.right');

	return;
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

Tags::HTML::Commons::Vote::PersonRole - Tags helper for competition validation.

=head1 SYNOPSIS

 use Tags::HTML::Commons::Vote::PersonRole;

 my $obj = Tags::HTML::Commons::Vote::PersonRole->new(%params);
 $obj->process($competition_hr);

=head1 METHODS

=head2 C<new>

 my $obj = Tags::HTML::Commons::Vote::PersonRole->new(%params);

Constructor.

=over 8

=item * C<css_person_role>

CSS class for root div element.

Default value is 'validation'.

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

 use Tags::HTML::Commons::Vote::PersonRole;
 use Tags::Output::Indent;

 # Object.
 my $tags = Tags::Output::Indent->new;
 my $obj = Tags::HTML::Commons::Vote::PersonRole->new(
         'tags' => $tags,
 );

 # Process list of competitions.
 $obj->process;

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

© 2021-2022 Michal Josef Špaček

BSD 2-Clause License

=head1 VERSION

0.01

=cut
