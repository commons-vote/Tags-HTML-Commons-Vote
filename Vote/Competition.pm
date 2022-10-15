package Tags::HTML::Commons::Vote::Competition;

use base qw(Tags::HTML);
use strict;
use warnings;

use Class::Utils qw(set_params split_params);
use Commons::Link;
use DateTime::Format::Strptime;
use Error::Pure qw(err);
use Readonly;
use Scalar::Util qw(blessed);
use Tags::HTML::Commons::Vote::Utils qw(d_format dt_format text);
use Tags::HTML::Commons::Vote::Utils::CSS qw(a_button button_list float_right);
use Tags::HTML::Commons::Vote::Utils::Tags qw(tags_dl_item);
use Unicode::UTF8 qw(decode_utf8);

Readonly::Scalar our $PREVIEW_WIDTH => 250;

our $VERSION = 0.01;

# Constructor.
sub new {
	my ($class, @params) = @_;

	# Create object.
	my ($object_params_ar, $other_params_ar) = split_params(
		['css_competition', 'dt_formatter_d', 'dt_formatter_dt',
		'lang', 'logo_width', 'text'], @params);
	my $self = $class->SUPER::new(@{$other_params_ar});

	$self->{'css_competition'} = 'competition';

	# DateTime format.
	$self->{'dt_formatter_d'} = DateTime::Format::Strptime->new(
		pattern => "%Y/%m/%d",
		time_zone => 'UTC',
	);
	$self->{'dt_formatter_dt'} = DateTime::Format::Strptime->new(
		pattern => "%Y/%m/%d %H:%M",
		time_zone => 'UTC',
	);

	# Language.
	$self->{'lang'} = 'eng';

	# logo width.
	$self->{'logo_width'} = '130px',

	# Language texts.
	$self->{'text'} = {
		'eng' => {
			'add_section' => 'Add section',
			'competition_logo' => 'Logo',
			'date_from' => 'Date from',
			'date_image_loaded' => 'Date and time of situation when images were downloaded',
			'date_to' => 'Date to',
			'edit_competition' => 'Edit competition',
			'jury_voting' => 'Jury voting',
			'jury_voting_date_from' => 'Jury voting date from',
			'jury_voting_date_to' => 'Jury voting date to',
			'load_competition' => 'Load competition',
			'number_of_votes' => 'Number of votes',
			'organizer' => 'Organizer',
			'organizer_logo' => 'Organizer logo',
			'sections' => 'Sections',
			'competition_not_exists' => "Competition doesn't exist.",
			'public_voting' => 'Public voting',
			'public_voting_date_from' => 'Public voting date from',
			'public_voting_date_to' => 'Public voting date to',
			'view_competition_logs' => 'View logs',
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

	if (! defined $competition) {
		$self->{'tags'}->put(
			['d', text($self, 'competition_not_exists')],
		);

		return;
	}
	if (! blessed($competition)
		&& ! $competition->isa('Data::Commons::Vote::Competition')) {

		err 'Bad competition object.';
	}

	my $competition_logo_url;
	if ($competition->logo) {
		$competition_logo_url = $self->{'_commons_link'}->thumb_link($competition->logo, $PREVIEW_WIDTH);
	}
	my $organizer_logo_url;
	if ($competition->organizer_logo) {
		$organizer_logo_url = $self->{'_commons_link'}->thumb_link(
			$competition->organizer_logo, $PREVIEW_WIDTH);
	}

	$self->{'tags'}->put(
		['b', 'div'],
		['a', 'class', $self->{'css_competition'}],

		['b', 'div'],
		['a', 'class', 'right button-list'],
		['b', 'a'],
		['a', 'class', 'button'],
		['a', 'href', '/competition_form/'.$competition->id],
		['d', text($self, 'edit_competition')],
		['e', 'a'],

		['b', 'a'],
		['a', 'class', 'button'],
		['a', 'href', '/load/'.$competition->id],
		['d', text($self, 'load_competition')],
		['e', 'a'],

		['b', 'a'],
		['a', 'class', 'button'],
		['a', 'href', '/logs/'.$competition->id],
		['d', text($self, 'view_competition_logs')],
		['e', 'a'],
		['e', 'div'],

		$competition_logo_url ? (
			['b', 'figure'],
			['a', 'class', 'logo'],
			['b', 'img'],
			['a', 'src', $competition_logo_url],
			['e', 'img'],
			['b', 'figcaption'],
			['d', text($self, 'competition_logo')],
			['e', 'figcaption'],
			['e', 'figure'],
		) : (),

		$organizer_logo_url ? (
			['b', 'figure'],
			['a', 'class', 'logo'],
			['b', 'img'],
			['a', 'src', $organizer_logo_url],
			['e', 'img'],
			['b', 'figcaption'],
			['d', text($self, 'organizer_logo')],
			['e', 'figcaption'],
			['e', 'figure'],
		) : (),

		['b', 'h1'],
		['d', $competition->name],
		['e', 'h1'],

		['b', 'dl'],
	);
	tags_dl_item($self, 'date_from',
		d_format($self, $competition->dt_from));
	tags_dl_item($self, 'date_to',
		d_format($self, $competition->dt_to));
	tags_dl_item($self, 'organizer', $competition->organizer);
	tags_dl_item($self, 'number_of_votes', $competition->number_of_votes);
	tags_dl_item($self, 'date_image_loaded',
		dt_format($self, $competition->dt_images_loaded));
	tags_dl_item($self, 'jury_voting', $competition->jury_voting);
	tags_dl_item($self, 'jury_voting_date_from',
		d_format($self, $competition->dt_jury_voting_from));
	tags_dl_item($self, 'jury_voting_date_to',
		d_format($self, $competition->dt_jury_voting_to));
	tags_dl_item($self, 'public_voting', $competition->public_voting);
	tags_dl_item($self, 'public_voting_date_from',
		d_format($self, $competition->dt_public_voting_from));
	tags_dl_item($self, 'public_voting_date_to',
		d_format($self, $competition->dt_public_voting_to));
	$self->{'tags'}->put(
		['b', 'dt'],
		['d', text($self, 'sections')],
		['e', 'dt'],

		['b', 'dd'],
	);
	my $num = 0;
	foreach my $section (@{$competition->sections}) {
		if (! $num) {
			$self->{'tags'}->put(
				['b', 'ul'],
			);
			$num = 1;
		}
		$self->{'tags'}->put(
			['b', 'li'],
			['b', 'a'],
			['a', 'href', '/section/'.$section->id],
			['d', $section->name],
			['e', 'a'],
			['e', 'li'],
		);
	}
	if ($num) {
		$self->{'tags'}->put(
			['e', 'ul'],
		);
	}
	$self->{'tags'}->put(
		['b', 'a'],
		['a', 'class', 'button'],
		['a', 'href', '/section_form/?competition_id='.$competition->id],
		['d', text($self, 'add_section')],
		['e', 'a'],

		['e', 'dd'],

		['e', 'dl'],
		['e', 'div'],
	);

	return;
}

sub _process_css {
	my $self = shift;

	$self->{'css'}->put(
		['s', '.'.$self->{'css_competition'}.' dt'],
		['d', 'font-weight', 'bold'],
		['e'],

		['s', '.logo'],
		['s', '.logo img'],
		['d', 'padding', 0],
		['d', 'margin', 0],
		['d', 'float', 'right'],
		['d', 'width', $self->{'logo_width'}],
		['e'],

		['s', '.logo'],
		['d', 'margin', '0 1em 1em 1em'],
		['d', 'border', '1px solid black'],
		['e'],

		['s', '.logo figcaption'],
		['d', 'text-align', 'center'],
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

Tags::HTML::Commons::Vote::Competition - Tags helper for competition.

=head1 SYNOPSIS

 use Tags::HTML::Commons::Vote::Competition;

 my $obj = Tags::HTML::Commons::Vote::Competition->new(%params);
 $obj->process($competition_hr);

=head1 METHODS

=head2 C<new>

 my $obj = Tags::HTML::Commons::Vote::Competition->new(%params);

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

 use Data::Commons::Vote::Competition;
 use DateTime;
 use Tags::HTML::Commons::Vote::Competition;
 use Tags::Output::Indent;

 # Object.
 my $tags = Tags::Output::Indent->new;
 my $obj = Tags::HTML::Commons::Vote::Competition->new(
         'tags' => $tags,
 );

 # Process list of competitions.
 $obj->process(
         Data::Commons::Vote::Competition->new(
                 'id' => 1,
                 'name' => 'Czech Wiki Photo',
                 'dt_from' => DateTime->new(
                         'day' => 10,
                         'month' => 10,
                         'year' => 2021,
                 ),
                 'dt_to' => DateTime->new(
                         'day' => 20,
                         'month' => 11,
                         'year' => 2021,
                 ),
         ),
 );

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
