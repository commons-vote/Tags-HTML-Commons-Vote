package Tags::HTML::Commons::Vote::Competitions;

use base qw(Tags::HTML);
use strict;
use warnings;

use Class::Utils qw(set_params split_params);
use Error::Pure qw(err);
use Scalar::Util qw(blessed);

our $VERSION = 0.01;

# Constructor.
sub new {
	my ($class, @params) = @_;

	# Create object.
	my ($object_params_ar, $other_params_ar) = split_params(
		['css_competitions', 'text_competitions',
		'text_competition_name', 'text_date_from', 'text_date_to',
		'text_no_competitions'], @params);
	my $self = $class->SUPER::new(@{$other_params_ar});

	$self->{'css_competitions'} = 'competitions';

	$self->{'text_competitions'} = 'Competitions';
	$self->{'text_competition_name'} = 'Competition name';
	$self->{'text_date_from'} = 'Date from';
	$self->{'text_date_to'} = 'Date to';
	$self->{'text_no_competitions'} = 'There is no competitions.';

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
		['a', 'class', $self->{'css_competitions'}],

		['b', 'h1'],
		['d', $self->{'text_competitions'}],
		['e', 'h1'],

		['b', 'table'],

		['b', 'tr'],
		['b', 'th'],
		['d', $self->{'text_competition_name'}],
		['e', 'th'],
		['b', 'th'],
		['d', $self->{'text_date_from'}],
		['e', 'th'],
		['b', 'th'],
		['d', $self->{'text_date_to'}],
		['e', 'th'],
		['e', 'tr'],
	);
	if (! @{$competitions_ar}) {
		$self->{'tags'}->put(
			['b', 'tr'],
			['b', 'td'],
			['a', 'colspan', 3],
			['d', $self->{'text_no_competitions'}],
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
				['d', $c->dt_from->stringify],
				['e', 'td'],
				['b', 'td'],
				['d', $c->dt_to->stringify],
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
		['s', '.'.$self->{'css_competitions'}.' table, tr, td, th'],
		['d', 'border', '1px solid black'],
		['d', 'border-collapse', 'collapse'],
		['e'],

		['s', '.'.$self->{'css_competitions'}.' td, th'],
		['d', 'padding', '0.5em'],
		['e'],
	);

	return;
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

Tags::HTML::Commons::Vote::Competitions - Tags helper for list of competitions.

=head1 SYNOPSIS

 use Tags::HTML::Commons::Vote::Competitions;

 my $obj = Tags::HTML::Commons::Vote::Competitions->new(%params);
 $obj->process($competitions_ar);

=head1 METHODS

=head2 C<new>

 my $obj = Tags::HTML::Commons::Vote::Competitions->new(%params);

Constructor.

=over 8

=item * C<css_competitions>

CSS class for root div element.

Default value is 'competitions'.

=item * C<TODO>

TODO

=item * C<tags>

'Tags::Output' object.

Default value is undef.

=back

=head2 C<process>

 $obj->process($competitions_ar);

Process Tags structure for output with list of competition structures.
Each competition structure consists from:
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

 use Tags::HTML::Commons::Vote::Competitions;
 use Tags::Output::Indent;

 # Object.
 my $tags = Tags::Output::Indent->new;
 my $obj = Tags::HTML::Commons::Vote::Competitions->new(
         'tags' => $tags,
 );

 # Process list of competitions.
 $obj->process([{
         'id' => 1,
         'name' => 'Czech Wiki Photo',
         'date_from' => '10.10.2021',
         'date_to' => '20.11.2021',
 }, {
         'id' => 2,
         'name' => 'Foo Bar',
         'date_from' => '30.10.2021',
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
