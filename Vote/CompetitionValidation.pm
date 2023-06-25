package Tags::HTML::Commons::Vote::CompetitionValidation;

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
		['css_validation', 'lang', 'text'], @params);
	my $self = $class->SUPER::new(@{$other_params_ar});

	$self->{'css_validation'} = 'validation';

	# Language.
	$self->{'lang'} = 'eng';

	# Language texts.
	$self->{'text'} = {
		'eng' => {
			'competition' => 'Competition',
			'edit_validation' => 'Edit validation',
			'options' => 'List of options',
			'remove_validation' => 'Remove validation',
			'validation_not_exists' => "Validation doesn't exist.",
		},
	};

	# Process params.
	set_params($self, @{$object_params_ar});

	# Object.
	return $self;
}

# Process 'Tags'.
sub _process {
	my ($self, $validation) = @_;

	if (! defined $validation) {
		$self->{'tags'}->put(
			['d', text($self, 'validation_not_exists')],
		);

		return;
	}

	$self->{'tags'}->put(
		['b', 'div'],
		['a', 'class', $self->{'css_validation'}],

		['b', 'div'],
		['a', 'class', 'right button-list'],
#		['b', 'a'],
#		['a', 'class', 'button'],
#		['a', 'href', '/validation_form/'.$validation->id],
#		['d', text($self, 'edit_validation')],
#		['e', 'a'],

		['b', 'a'],
		['a', 'class', 'button'],
		['a', 'href', '/validation_remove/'.$validation->id],
		['d', text($self, 'remove_validation')],
		['e', 'a'],

		['e', 'div'],

		['b', 'h1'],
		['d', $validation->validation_type->description],
		['e', 'h1'],

		['b', 'dl'],

		['b', 'dt'],
		['d', text($self, 'competition')],
		['e', 'dt'],
		['b', 'dd'],
		['b', 'a'],
		['a', 'href', '/competition/'.$validation->competition->id],
		['d', $validation->competition->name],
		['e', 'a'],
		['e', 'dd'],
	);
	if (@{$validation->options}) {
		$self->{'tags'}->put(
			['b', 'dt'],
			['d', text($self, 'options')],
			['e', 'dt'],

			['b', 'dd'],
		);
		my $num = 0;
		foreach my $option (@{$validation->options}) {
			if (! $num) {
				$self->{'tags'}->put(
					['b', 'ul'],
				);
				$num = 1;
			}
			$self->{'tags'}->put(
				['b', 'li'],
				['d', $option->validation_option->description.': '.$option->value],
				['e', 'li'],
			);
		}
		if ($num) {
			$self->{'tags'}->put(
				['e', 'ul'],
			);
		}
		$self->{'tags'}->put(
			['e', 'dd'],
		);
	}
	$self->{'tags'}->put(
		['e', 'dl'],
		['e', 'div'],
	);

	return;
}

sub _process_css {
	my $self = shift;

	$self->{'css'}->put(
		['s', '.'.$self->{'css_validation'}.' dt'],
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

Tags::HTML::Commons::Vote::CompetitionValidation - Tags helper for competition validation.

=head1 SYNOPSIS

 use Tags::HTML::Commons::Vote::CompetitionValidation;

 my $obj = Tags::HTML::Commons::Vote::CompetitionValidation->new(%params);
 $obj->process($competition_hr);

=head1 METHODS

=head2 C<new>

 my $obj = Tags::HTML::Commons::Vote::CompetitionValidation->new(%params);

Constructor.

=over 8

=item * C<css_validation>

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

 use Tags::HTML::Commons::Vote::CompetitionValidation;
 use Tags::Output::Indent;

 # Object.
 my $tags = Tags::Output::Indent->new;
 my $obj = Tags::HTML::Commons::Vote::CompetitionValidation->new(
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

© 2021-2023 Michal Josef Špaček

BSD 2-Clause License

=head1 VERSION

0.01

=cut
