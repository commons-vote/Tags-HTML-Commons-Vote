package Tags::HTML::Commons::Vote::CompetitionVoting;

use base qw(Tags::HTML);
use strict;
use warnings;

use Class::Utils qw(set_params split_params);
use DateTime::Format::Strptime;
use Error::Pure qw(err);
use Tags::HTML::Commons::Vote::Utils qw(d_format text value);
use Tags::HTML::Commons::Vote::Utils::CSS qw(a_button button_list float_right);
use Tags::HTML::Commons::Vote::Utils::Tags qw(tags_dl_item);
use Unicode::UTF8 qw(decode_utf8);

our $VERSION = 0.01;

# Constructor.
sub new {
	my ($class, @params) = @_;

	# Create object.
	my ($object_params_ar, $other_params_ar) = split_params(
		['css_voting', 'lang', 'text'], @params);
	my $self = $class->SUPER::new(@{$other_params_ar});

	$self->{'css_voting'} = 'voting';

	# Language.
	$self->{'lang'} = 'eng';

	# Language texts.
	$self->{'text'} = {
		'eng' => {
			'competition' => 'Competition',
			'date_from' => 'Date from',
			'date_to' => 'Date to',
			'edit_voting' => 'Edit voting',
			'max_number_for_jury_voting' => 'Max. number for jury voting',
			'number_of_votes' => 'Number of votes',
			'remove_voting' => 'Remove voting',
			'voting_not_exists' => "Competition voting doesn't exist.",
		},
	};

	# Process params.
	set_params($self, @{$object_params_ar});

	# DateTime format.
	$self->{'dt_formatter_d'} = DateTime::Format::Strptime->new(
		pattern => "%Y/%m/%d",
		time_zone => 'UTC',
	);

	# Object.
	return $self;
}

# Process 'Tags'.
sub _process {
	my ($self, $voting) = @_;

	if (! defined $voting) {
		$self->{'tags'}->put(
			['d', text($self, 'voting_not_exists')],
		);

		return;
	}

	$self->{'tags'}->put(
		['b', 'div'],
		['a', 'class', $self->{'css_voting'}],

		['b', 'div'],
		['a', 'class', 'right button-list'],
#		['b', 'a'],
#		['a', 'class', 'button'],
#		['a', 'href', '/voting_type_form/'.$voting->id],
#		['d', text($self, 'edit_validation')],
#		['e', 'a'],

		['b', 'a'],
		['a', 'class', 'button'],
		['a', 'href', '/voting_remove/'.$voting->id],
		['d', text($self, 'remove_voting')],
		['e', 'a'],

		['e', 'div'],

		['b', 'h1'],
		['d', $voting->voting_type->description],
		['e', 'h1'],

		['b', 'dl'],

		['b', 'dt'],
		['d', text($self, 'competition')],
		['e', 'dt'],
		['b', 'dd'],
		['b', 'a'],
		['a', 'href', '/competition/'.$voting->competition->id],
		['d', $voting->competition->name],
		['e', 'a'],
		['e', 'dd'],
		['e', 'dl'],
	);
	tags_dl_item($self, 'date_from',
		d_format($self, $voting->dt_from));
	tags_dl_item($self, 'date_to',
		d_format($self, $voting->dt_to));
	# TODO for jury is different text
	my $number_of_votes = defined $voting->number_of_votes
		? $voting->number_of_votes : '-';
	tags_dl_item($self, 'number_of_votes', $number_of_votes);
	$self->{'tags'}->put(
		['e', 'div'],
	);

	return;
}

sub _process_css {
	my $self = shift;

	$self->{'css'}->put(
		['s', '.'.$self->{'css_voting'}.' dt'],
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

Tags::HTML::Commons::Vote::CompetitionVoting - Tags helper for competition validation.

=head1 SYNOPSIS

 use Tags::HTML::Commons::Vote::CompetitionVoting;

 my $obj = Tags::HTML::Commons::Vote::CompetitionVoting->new(%params);
 $obj->process($competition_hr);

=head1 METHODS

=head2 C<new>

 my $obj = Tags::HTML::Commons::Vote::CompetitionVoting->new(%params);

Constructor.

=over 8

=item * C<css_voting>

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

 use Tags::HTML::Commons::Vote::CompetitionVoting;
 use Tags::Output::Indent;

 # Object.
 my $tags = Tags::Output::Indent->new;
 my $obj = Tags::HTML::Commons::Vote::CompetitionVoting->new(
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
