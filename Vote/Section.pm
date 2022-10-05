package Tags::HTML::Commons::Vote::Section;

use base qw(Tags::HTML);
use strict;
use warnings;

use Class::Utils qw(set_params split_params);
use Commons::Link;
use Error::Pure qw(err);
use Readonly;
use Tags::HTML::Commons::Vote::Utils qw(text value);
use Tags::HTML::Commons::Vote::Utils::CSS qw(a_button float_right);
use Tags::HTML::Commons::Vote::Utils::Tags qw(tags_dl_item);
use Unicode::UTF8 qw(decode_utf8);

Readonly::Scalar our $PREVIEW_WIDTH => 250;

our $VERSION = 0.01;

# Constructor.
sub new {
	my ($class, @params) = @_;

	# Create object.
	my ($object_params_ar, $other_params_ar) = split_params(
		['css_section', 'lang', 'text'], @params);
	my $self = $class->SUPER::new(@{$other_params_ar});

	$self->{'css_section'} = 'section';

	# Language.
	$self->{'lang'} = 'eng';

	# Language texts.
	$self->{'text'} = {
		'eng' => {
			'categories' => 'Categories',
			'competition' => 'Competition',
			'edit_section' => 'Edit section',
			'number_of_votes' => 'Number of votes',
			'section_not_exists' => "Section doesn't exist.",
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
	my ($self, $section) = @_;

	if (! defined $section) {
		$self->{'tags'}->put(
			['d', text($self, 'section_not_exists')],
		);

		return;
	}

	my $section_logo_url;
	if ($section->logo) {
		$section_logo_url = $self->{'_commons_link'}->thumb_link($section->logo, $PREVIEW_WIDTH);
	}

	$self->{'tags'}->put(
		['b', 'div'],
		['a', 'class', $self->{'css_section'}],

		['b', 'a'],
		['a', 'class', 'button right'],
		['a', 'href', '/section_form/'.$section->id],
		['d', text($self, 'edit_section')],
		['e', 'a'],

		$section_logo_url ? (
			['b', 'img'],
			['a', 'class', 'logo'],
			['a', 'src', $section_logo_url],
			['e', 'img'],
		) : (),

		['b', 'h1'],
		['d', $section->name],
		['e', 'h1'],

		['b', 'dl'],

		['b', 'dt'],
		['d', text($self, 'competition')],
		['e', 'dt'],
		['b', 'dd'],
		['b', 'a'],
		['a', 'href', '/competition/'.$section->competition->id],
		['d', $section->competition->name],
		['e', 'a'],
		['e', 'dd'],
	);
	tags_dl_item($self, 'number_of_votes', $section->number_of_votes);
	$self->{'tags'}->put(
		['b', 'dt'],
		['d', text($self, 'categories')],
		['e', 'dt'],

		['b', 'dd'],
	);
	my $num = 0;
	foreach my $category (@{$section->categories}) {
		if (! $num) {
			$self->{'tags'}->put(
				['b', 'ul'],
			);
			$num = 1;
		}
		$self->{'tags'}->put(
			['b', 'li'],
			['b', 'a'],
			['a', 'href', 'https://commons.wikimedia.org/wiki/Category:'.$category->category],
			['d', $category->category],
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
		['e', 'dd'],

		['e', 'dl'],
		['e', 'div'],
	);

	return;
}

sub _process_css {
	my $self = shift;

	$self->{'css'}->put(
		['s', '.'.$self->{'css_section'}.' dt'],
		['d', 'font-weight', 'bold'],
		['e'],

		['s', '.logo'],
		['d', 'float', 'right'],
		['d', 'width', '20%'],
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

© 2021-2022 Michal Josef Špaček

BSD 2-Clause License

=head1 VERSION

0.01

=cut
