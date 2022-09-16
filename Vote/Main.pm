package Tags::HTML::Commons::Vote::Main;

use base qw(Tags::HTML);
use strict;
use warnings;

use Class::Utils qw(set_params split_params);
use DateTime::Format::Strptime;
use Error::Pure qw(err);
use Scalar::Util qw(blessed);
use Tags::HTML::Commons::Vote::Utils qw(d_format text);
use Tags::HTML::Commons::Vote::Utils::CSS qw(a_button float_right);

our $VERSION = 0.01;

# Constructor.
sub new {
	my ($class, @params) = @_;

	# Create object.
	my ($object_params_ar, $other_params_ar) = split_params(
		['css_main', 'dt_formatter_d', 'lang', 'text'], @params);
	my $self = $class->SUPER::new(@{$other_params_ar});

	$self->{'css_main'} = 'main';

	# DateTime format.
	$self->{'dt_formatter_d'} = DateTime::Format::Strptime->new(
		pattern => "%Y/%m/%d",
		time_zone => 'UTC',
	);

	# Language.
	$self->{'lang'} = 'eng';

	# Language texts.
	$self->{'text'} = {
		'eng' => {
			'create_competition' => 'Create competition',
			'my_competitions' => 'My competitions',
			'text_competition_name' => 'Competition name',
			'text_date_from' => 'Date from',
			'text_date_to' => 'Date to',
			'text_no_competitions' => 'There is no competitions.',
		},
	};

	# Process params.
	set_params($self, @{$object_params_ar});

	# Object.
	return $self;
}

# Process 'Tags'.
sub _process {
	my ($self, $competitions_ar) = @_;

	foreach my $competition (@{$competitions_ar}) {
		if (! blessed($competition)
			&& ! $competition->isa('Data::Commons::Vote::Competition')) {

			err 'Bad competition object.';
		}
	}

	$self->{'tags'}->put(
		['b', 'div'],
		['a', 'class', $self->{'css_main'}],

		['b', 'div'],
		['a', 'class', 'page-header'],

		['b', 'a'],
		['a', 'class', 'button right'],
		['a', 'href', '/competition_form'],
		['d', text($self, 'create_competition')],
		['e', 'a'],

		['b', 'h1'],
		['d', text($self, 'my_competitions')],
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
		['e', 'tr'],
	);
	if (! @{$competitions_ar}) {
		$self->{'tags'}->put(
			['b', 'tr'],
			['b', 'td'],
			['a', 'colspan', 3],
			['d', text($self, 'text_no_competitions')],
			['e', 'td'],
			['e', 'tr'],
		);
	} else {
		foreach my $c (@{$competitions_ar}) {
			my $uri = '/competition/'.$c->id;
			$self->{'tags'}->put(
				['b', 'tr'],
				['b', 'td'],
				['b', 'a'],
				['a', 'href', $uri],
				['d', $c->name],
				['e', 'a'],
				['e', 'td'],
				['b', 'td'],
				['d', d_format($self, $c->dt_from)],
				['e', 'td'],
				['b', 'td'],
				['d', d_format($self, $c->dt_to)],
				['e', 'td'],
				['e', 'tr'],
			);
		}
	}
	$self->{'tags'}->put(
		['e', 'table'],
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
 $obj->process($competition_hr);

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

© Michal Josef Špaček 2021-2022

BSD 2-Clause License

=head1 VERSION

0.01

=cut
