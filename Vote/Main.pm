package Tags::HTML::Commons::Vote::Main;

use base qw(Tags::HTML);
use strict;
use warnings;

use Class::Utils qw(set_params split_params);
use DateTime::Format::Strptime;
use Error::Pure qw(err);
use Scalar::Util qw(blessed);
use Tags::HTML::Commons::Vote::Utils qw(d_format dt_format text);
use Tags::HTML::Commons::Vote::Utils::CSS qw(a_button button_list float_right);

our $VERSION = 0.01;

# Constructor.
sub new {
	my ($class, @params) = @_;

	# Create object.
	my ($object_params_ar, $other_params_ar) = split_params(
		['css_main', 'dt_formatter_d', 'dt_formatter_dt', 'lang',
		'text'], @params);
	my $self = $class->SUPER::new(@{$other_params_ar});

	$self->{'css_main'} = 'main';

	# Date format.
	$self->{'dt_formatter_d'} = DateTime::Format::Strptime->new(
		pattern => "%Y/%m/%d",
		time_zone => 'UTC',
	);

	# Datetime format.
	$self->{'dt_formatter_dt'} = DateTime::Format::Strptime->new(
		pattern => "%Y/%m/%d %H:%M",
		time_zone => 'UTC',
	);

	# Language.
	$self->{'lang'} = 'eng';

	# Language texts.
	$self->{'text'} = {
		'eng' => {
			'competitions_for_public_voting' => 'Competitions for public voting',
			'competitions_for_jury_voting' => 'Competitions for jury voting',
			'create_competition' => 'Create competition',
			'create_competition_from_wd' => 'Competition from WD',
			'my_competitions' => 'My competitions',
			'number_of_votes' => 'Number of votes',
			'text_competition_name' => 'Competition name',
			'text_date_from' => 'Date from',
			'text_date_to' => 'Date to',
			'text_loaded' => 'Images loaded at',
			'text_no_competitions' => 'There is no competitions.',
			'vote' => 'Vote',
			'vote_stats' => 'Vote statistics',
			'voting' => 'Link to voting',
			'voting_yes_no' => 'Voting yes/no',
		},
	};

	# Process params.
	set_params($self, @{$object_params_ar});

	# Object.
	return $self;
}

sub _check_competitions {
	my ($self, $competitions_ar) = @_;

	foreach my $competition (@{$competitions_ar}) {
		if (! blessed($competition)
			&& ! $competition->isa('Data::Commons::Vote::Competition')) {

			err 'Bad competition object.';
		}
	}

	return;
}

sub _check_competition_votings {
	my ($self, $competition_votings_ar) = @_;

	foreach my $competition_voting (@{$competition_votings_ar}) {
		if (! blessed($competition_voting)
			&& ! $competition_voting->isa('Data::Commons::Vote::CompetitionVoting')) {

			err 'Bad competition voting object.';
		}
	}

	return;
}

sub _jury_voting {
	my ($self, $jury_competition_votings_ar) = @_;

	$self->_check_competition_votings($jury_competition_votings_ar);

	$self->{'tags'}->put(
		['b', 'div'],
		['a', 'class', 'page-header'],

		['b', 'h1'],
		['d', text($self, 'competitions_for_jury_voting')],
		['e', 'h1'],

		['e', 'div'],

		['b', 'table'],

		['b', 'tr'],
		['b', 'th'],
		['d', text($self, 'text_competition_name')],
		['e', 'th'],
		['b', 'th'],
		['d', text($self, 'text_date_from')],
		['e', 'th'],
		['b', 'th'],
		['d', text($self, 'text_date_to')],
		['e', 'th'],
		['b', 'th'],
		['d', text($self, 'number_of_votes')],
		['e', 'th'],
		['b', 'th'],
		['d', text($self, 'voting')],
		['e', 'th'],
		['e', 'tr'],
	);
	if (! defined $jury_competition_votings_ar || ! @{$jury_competition_votings_ar}) {
		$self->{'tags'}->put(
			['b', 'tr'],
			['b', 'td'],
			['a', 'colspan', 5],
			['d', text($self, 'text_no_competitions')],
			['e', 'td'],
			['e', 'tr'],
		);
	} else {
		foreach my $cv (@{$jury_competition_votings_ar}) {
			my $competition_uri = '/competition/'.$cv->id;
			my $vote_uri = '/vote_images/'.$cv->id;
			my $text_number_of_votes;
			if (! defined $cv->number_of_votes) {
				$text_number_of_votes = text($self, 'voting_yes_no');
			} else {
				$text_number_of_votes = $cv->number_of_votes;
			}
			$self->{'tags'}->put(
				['b', 'tr'],
				['b', 'td'],
				['b', 'a'],
				['a', 'href', $competition_uri],
				['d', $cv->competition->name],
				['e', 'a'],
				['e', 'td'],
				['b', 'td'],
				['d', d_format($self, $cv->dt_from)],
				['e', 'td'],
				['b', 'td'],
				['d', d_format($self, $cv->dt_to)],
				['e', 'td'],
				['b', 'td'],
				['d', $text_number_of_votes],
				['e', 'td'],
				['b', 'td'],
				['b', 'a'],
				['a', 'href', $vote_uri],
				['d', text($self, 'vote')],
				['e', 'a'],
				['e', 'td'],
				['e', 'tr'],
			);
		}
	}
	$self->{'tags'}->put(
		['e', 'table'],
	);

	return;
}

sub _login_voting {
	my ($self, $competition_votings_login_ar) = @_;

	$self->_check_competition_votings($competition_votings_login_ar);

	$self->{'tags'}->put(
		['b', 'div'],
		['a', 'class', 'page-header'],

		['b', 'h1'],
		['d', text($self, 'competitions_for_public_voting')],
		['e', 'h1'],

		['e', 'div'],

		['b', 'table'],

		['b', 'tr'],
		['b', 'th'],
		['d', text($self, 'text_competition_name')],
		['e', 'th'],
		['b', 'th'],
		['d', text($self, 'text_date_from')],
		['e', 'th'],
		['b', 'th'],
		['d', text($self, 'text_date_to')],
		['e', 'th'],
		['b', 'th'],
		['d', text($self, 'number_of_votes')],
		['e', 'th'],
		['b', 'th'],
		['d', text($self, 'voting')],
		['e', 'th'],
		['e', 'tr'],
	);
	if (! defined $competition_votings_login_ar || ! @{$competition_votings_login_ar}) {
		$self->{'tags'}->put(
			['b', 'tr'],
			['b', 'td'],
			['a', 'colspan', 5],
			['d', text($self, 'text_no_competitions')],
			['e', 'td'],
			['e', 'tr'],
		);
	} else {
		foreach my $cv (@{$competition_votings_login_ar}) {
			my $competition_uri = '/competition/'.$cv->id;
			my $vote_uri = '/vote_images/'.$cv->id;
			my $text_number_of_votes;
			if (! defined $cv->number_of_votes) {
				$text_number_of_votes = text($self, 'voting_yes_no');
			} else {
				$text_number_of_votes = $cv->number_of_votes;
			}
			$self->{'tags'}->put(
				['b', 'tr'],
				['b', 'td'],
				['b', 'a'],
				['a', 'href', $competition_uri],
				['d', $cv->competition->name],
				['e', 'a'],
				['e', 'td'],
				['b', 'td'],
				['d', d_format($self, $cv->dt_from)],
				['e', 'td'],
				['b', 'td'],
				['d', d_format($self, $cv->dt_to)],
				['e', 'td'],
				['b', 'td'],
				['d', $text_number_of_votes],
				['e', 'td'],
				['b', 'td'],
				['b', 'a'],
				['a', 'href', $vote_uri],
				['d', text($self, 'vote')],
				['e', 'a'],
				['e', 'td'],
				['e', 'tr'],
			);
		}
	}
	$self->{'tags'}->put(
		['e', 'table'],
	);

	return;
}

# Process 'Tags'.
sub _process {
	my ($self, $competitions_ar, $competition_votings_stats_hr,
		$competition_votings_jury_ar, $competition_votings_login_ar) = @_;

	$self->_check_competitions($competitions_ar);

	$self->{'tags'}->put(
		['b', 'div'],
		['a', 'class', $self->{'css_main'}],

		['b', 'div'],
		['a', 'class', 'right button-list'],

		['b', 'a'],
		['a', 'class', 'button'],
		['a', 'href', '/competition_form'],
		['d', text($self, 'create_competition')],
		['e', 'a'],

		['b', 'a'],
		['a', 'class', 'button'],
		['a', 'href', '/wikidata_form'],
		['d', text($self, 'create_competition_from_wd')],
		['e', 'a'],

		['e', 'div'],

		['b', 'h1'],
		['d', text($self, 'my_competitions')],
		['e', 'h1'],

		['b', 'table'],

		['b', 'tr'],
		['b', 'th'],
		['d', text($self, 'text_competition_name')],
		['e', 'th'],
		['b', 'th'],
		['d', text($self, 'vote_stats')],
		['e', 'th'],
		['e', 'tr'],
	);
	if (! defined $competitions_ar || ! @{$competitions_ar}) {
		$self->{'tags'}->put(
			['b', 'tr'],
			['b', 'td'],
			['a', 'colspan', 4],
			['d', text($self, 'text_no_competitions')],
			['e', 'td'],
			['e', 'tr'],
		);
	} else {
		foreach my $c (@{$competitions_ar}) {
			my $competition_uri = '/competition/'.$c->id;
			my $competition_votings_ar = $competition_votings_stats_hr->{$c->id};
			$self->{'tags'}->put(
				['b', 'tr'],
				['b', 'td'],
				['b', 'a'],
				['a', 'href', $competition_uri],
				['d', $c->name],
				['e', 'a'],
				['e', 'td'],
				['b', 'td'],
			);
			my @tags_stats;
			foreach my $competition_voting (@{$competition_votings_ar}) {
				my $stats_uri = '/vote_stats/'.$competition_voting->id;
				if (@tags_stats) {
					push @tags_stats, (
						['b', 'br'],
						['e', 'br'],
					);
				}
				push @tags_stats, (
					['b', 'a'],
					['a', 'href', $stats_uri],
					['d', $competition_voting->voting_type->description],
					['e', 'a'],
				);
			}
			$self->{'tags'}->put(
				@tags_stats,

				['e', 'td'],
				['e', 'tr'],
			);
		}
	}
	$self->{'tags'}->put(
		['e', 'table'],
	);

	$self->_jury_voting($competition_votings_jury_ar);
	$self->_login_voting($competition_votings_login_ar);

	$self->{'tags'}->put(
		['e', 'div'],
	);

	return;
}

sub _process_css {
	my $self = shift;

	$self->{'css'}->put(
		['s', '.'.$self->{'css_main'}],
		['d', 'margin', '1em'],
		['e'],

		['s', '.page-header'],
		['d', 'border-bottom', '1px solid #eee'],
		['d', 'padding-bottom', '20px'],
		['d', 'margin', '40px 0 20px 0'],
		['e'],

		['s', '.'.$self->{'css_main'}.' table, tr, td, th'],
		['d', 'border', '1px solid black'],
		['d', 'border-collapse', 'collapse'],
		['e'],

		['s', '.'.$self->{'css_main'}.' td, th'],
		['d', 'padding', '0.5em'],
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

Tags::HTML::Commons::Vote::Main - Tags helper for main page.

=head1 SYNOPSIS

 use Tags::HTML::Commons::Vote::Main;

 my $obj = Tags::HTML::Commons::Vote::Main->new(%params);
 $obj->process($competitions_ar, $jury_competitions_ar, $public_competitions_ar);
 $obj->process_css;

=head1 METHODS

=head2 C<new>

 my $obj = Tags::HTML::Commons::Vote::Main->new(%params);

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

 $obj->process($competitions_ar, $jury_competitions_ar, $public_competitions_ar);

Process Tags structure for output with competition structure.
TODO
Structure consists from:
 {
         'id' => __COMPETITION_ID__ (required)
         'name' => __NAME__ (required)
         'date_from' => __DATE_FROM__ (required)
         'date_to' => __DATE_TO__ (required)
 }

Returns undef.

=head2 C<process_css>

 $obj->process_css;

TODO

=head1 ERRORS

 new():
         From Class::Utils::set_params():
                 Unknown parameter '%s'.

=head1 EXAMPLE1

 use strict;
 use warnings;

 use Tags::HTML::Commons::Vote::Main;
 use Tags::Output::Indent;

 # Object.
 my $tags = Tags::Output::Indent->new;
 my $obj = Tags::HTML::Commons::Vote::Main->new(
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

© 2021-2022 Michal Josef Špaček

BSD 2-Clause License

=head1 VERSION

0.01

=cut
