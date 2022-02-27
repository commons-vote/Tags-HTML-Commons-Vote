package Tags::HTML::Commons::Vote::CheckAuthors;

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
		['css_check_authors', 'text_check_authors'], @params);
	my $self = $class->SUPER::new(@{$other_params_ar});

	# CSS class.
	$self->{'css_check_authors'} = 'check_authors';

	# Title.
	$self->{'text_check_authors'} = 'Authors and their images which are not valid';

	# Process params.
	set_params($self, @{$object_params_ar});

	$self->{'_commons_link'} = Commons::Link->new;

	# Object.
	return $self;
}

# Process 'Tags'.
sub _process {
	my ($self, $authors_ar) = @_;

	$self->{'tags'}->put(
		['b', 'div'],
		['a', 'class', $self->{'css_check_authors'}],

		['b', 'h1'],
		['d', $self->{'text_check_authors'}],
		['e', 'h1'],

		['b', 'ul'],
	);
	foreach my $newcomer (@{$authors_ar}) {
		my $uri = $self->{'_commons_link'}->mw_user_link($newcomer->wm_username);
		$self->{'tags'}->put(
			['b', 'li'],
			['b', 'a'],
			['a', 'href', $uri],
			['d', $newcomer->wm_username],
			['e', 'a'],
			['e', 'li'],
		);
	}
	$self->{'tags'}->put(
		['e', 'ul'],
		['e', 'div'],
	);

	return;
}

sub _process_css {
	my $self = shift;

	$self->{'css'}->put(
		['s', '.'.$self->{'css_check_authors'}.' dt'],
		['d', 'font-weight', 'bold'],
		['e'],
	);

	return;
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

Tags::HTML::Commons::Vote::CheckAuthors - Tags helper for newcomers list.

=head1 SYNOPSIS

 use Tags::HTML::Commons::Vote::CheckAuthors;

 my $obj = Tags::HTML::Commons::Vote::CheckAuthors->new(%params);
 $obj->process($authors_ar);

=head1 METHODS

=head2 C<new>

 my $obj = Tags::HTML::Commons::Vote::CheckAuthors->new(%params);

Constructor.

Returns instance of object.

=over 8

=item * C<css>

'CSS::Struct::Output' object for L<process_css> processing.

Default value is undef.

=item * C<css_check_authors>

CSS class for root div element.

Default value is 'check_authors'.

=item * C<no_css>

No CSS support flag.
If this flag is set to 1, L<process_css()> returns undef.

Default value is 0.

=item * C<text_check_authors>

Title for check authors.

Default value is 'Authors and their images which are not valid'.

=item * C<tags>

'Tags::Output' object.

Default value is undef.

=back

=head2 C<process>

 $obj->process($authors_ar);

TODO
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

 use Tags::HTML::Commons::Vote::CheckAuthors;
 use Tags::Output::Indent;

 # Object.
 my $tags = Tags::Output::Indent->new;
 my $obj = Tags::HTML::Commons::Vote::CheckAuthors->new(
         'tags' => $tags,
 );

 # Process list of competitions.
 $obj->process([
         {
                 'id' => 1,
                 'name' => 'Czech Wiki Photo',
                 'date_from' => '10.10.2021',
                 'date_to' => '20.11.2021',
         },
 ]);

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
