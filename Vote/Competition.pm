package Tags::HTML::Commons::Vote::Competition;

use base qw(Tags::HTML);
use strict;
use warnings;

use Class::Utils qw(set_params split_params);
use Commons::Link;
use Error::Pure qw(err);
use Readonly;
use Unicode::UTF8 qw(decode_utf8);

our $VERSION = 0.01;

# Constructor.
sub new {
	my ($class, @params) = @_;

	# Create object.
	my ($object_params_ar, $other_params_ar) = split_params(
		['css_competition', 'text_date_from', 'text_date_to',
		'text_organizer'], @params);
	my $self = $class->SUPER::new(@{$other_params_ar});

	$self->{'css_competition'} = 'competition';

	$self->{'text_date_from'} = 'Date from';
	$self->{'text_date_to'} = 'Date to';
	$self->{'text_organizer'} = 'Organizer';

	# Process params.
	set_params($self, @{$object_params_ar});

	$self->{'_commons_link'} = Commons::Link->new;

	# Object.
	return $self;
}

# Process 'Tags'.
sub _process {
	my ($self, $competition) = @_;

	my $competition_logo_url;
	if (defined $competition->logo) {
		$competition_logo_url = $self->{'_commons_link'}->link($competition->logo);
	}
	my $organizer_logo_url;
	if (defined $competition->organizer_logo) {
		$organizer_logo_url = $self->{'_commons_link'}->link(
			$competition->organizer_logo);
	}

	$self->{'tags'}->put(
		['b', 'div'],
		['a', 'class', $self->{'css_competition'}],

		$competition_logo_url ? (
			['b', 'img'],
			['a', 'class', 'logo'],
			['a', 'src', $competition_logo_url],
			['e', 'img'],
		) : (),

		$organizer_logo_url ? (
			['b', 'img'],
			['a', 'class', 'logo'],
			['a', 'src', $organizer_logo_url],
			['e', 'img'],
		) : (),

		['b', 'h1'],
		['d', $competition->name],
		['e', 'h1'],

		['b', 'dl'],
	);
	$self->_dl_item('text_date_from', $competition->dt_from->stringify);
	$self->_dl_item('text_date_to', $competition->dt_to->stringify);
	$self->_dl_item('text_organizer', $competition->organizer);
	# TODO Sections
	$self->{'tags'}->put(
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
		['d', 'float', 'right'],
		['d', 'width', '20%'],
		['e'],
	);

	return;
}

sub _dl_item {
	my ($self, $text_key, $value) = @_;

	$self->{'tags'}->put(
		['b', 'dt'],
		['d', $self->{$text_key}],
		['e', 'dt'],

		['b', 'dd'],
		['d', $value],
		['e', 'dd'],
	);

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

 use Tags::HTML::Commons::Vote::Competition;
 use Tags::Output::Indent;

 # Object.
 my $tags = Tags::Output::Indent->new;
 my $obj = Tags::HTML::Commons::Vote::Competition->new(
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

© Michal Josef Špaček 2021

BSD 2-Clause License

=head1 VERSION

0.01

=cut
