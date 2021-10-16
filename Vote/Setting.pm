package Tags::HTML::Commons::Vote::Setting;

use base qw(Tags::HTML);
use strict;
use warnings;

use Class::Utils qw(set_params split_params);
use Error::Pure qw(err);

our $VERSION = 0.01;

# Constructor.
sub new {
	my ($class, @params) = @_;

	my ($object_params_ar, $other_params_ar) = split_params(
		[], @params);
	my $self = $class->SUPER::new(@{$other_params_ar});

	# Process params.
	set_params($self, @{$object_params_ar});

	# Object.
	return $self;
}

# Process 'Tags'.
sub _process {
	my ($self, $images_ar) = @_;

	# Main stars.
	$self->{'tags'}->put(
		['b', 'div'],
		['a', 'class', $self->{'css_voting'}],
		['b', 'form'],
		['a', 'enctype', 'application/x-www-form-urlencoded'],
	);
	if (defined $self->{'form_link'}) {
		$self->{'tags'}->put(
			['a', 'action', $self->{'form_link'}],
		);
	}
	if (defined $self->{'form_method'}) {
		$self->{'tags'}->put(
			['a', 'method', $self->{'form_method'}],
		);
	}
	$self->{'tags'}->put(
		['b', 'fieldset'],
	);
	if (defined $self->{'title'}) {
		$self->{'tags'}->put(
			['b', 'legend'],
			['d', $self->{'title'}],
			['e', 'legend'],
		);
	}
	foreach my $image_hr (@{$images_ar}) {
		$self->{'tags'}->put(
			['b', 'div'],
			['a', 'class', 'voting-item'],
			['b', 'img'],
		);
		my $css_values_hr;
		if (exists $image_hr->{'width'}) {
			$css_values_hr->{'width'} = $image_hr->{'width'};
		}
		if (defined $self->{'image_height'}) {
			$css_values_hr->{'height'} = $self->{'image_height'};
		}
		if (exists $image_hr->{'height'}) {
			$css_values_hr->{'height'} = $image_hr->{'height'};
		}
		my $image_style = join ';', map { $_.': '.$css_values_hr->{$_} }
			keys %{$css_values_hr};
		$self->{'tags'}->put(
			['a', 'style', $image_style],
		);
		$self->{'tags'}->put(
			['a', 'src', $image_hr->{'url'}],
		);
		if (exists $image_hr->{'alt'}) {
			$self->{'tags'}->put(
				['a', 'alt', $image_hr->{'alt'}],
			);
		}
		$self->{'tags'}->put(
			['e', 'img'],

			['b', 'input'],
			['a', 'type', 'checkbox'],
			['a', 'id', $image_hr->{'id'}],
			['a', 'value', $image_hr->{'id'}],
			['e', 'input'],
		);
		if (exists $image_hr->{'author'}) {
			$self->{'tags'}->put(
				['b', 'div'],
				['a', 'class', $self->{'css_voting_author'}],
			);
			if ($image_hr->{'author_link'}) {
				$self->{'tags'}->put(
					['b', 'a'],
					['a', 'href', $image_hr->{'author_link'}],
				);
			}
			$self->{'tags'}->put(
				['d', $image_hr->{'author'}],
			);
			if ($image_hr->{'author_link'}) {
				$self->{'tags'}->put(
					['e', 'a'],
				);
			}
			$self->{'tags'}->put(
				['e', 'div'],
			);
		}
		$self->{'tags'}->put(
			['e', 'div'],
		);
	}
	$self->{'tags'}->put(
		['b', 'button'],
		['a', 'type', 'submit'],
		['d', $self->{'vote_button_text'}],
		['e', 'button'],

		['e', 'fieldset'],
		['e', 'form'],
		['e', 'div'],
	);

	return;
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

Tags::HTML::Setting::Commons::Setting - Tags helper for image voting.

=head1 SYNOPSIS

 use Tags::HTML::Commons::Vote::Setting;

 my $obj = Tags::HTML::Commons::Vote::Setting->new(%params);
 $obj->process(@images);

=head1 METHODS

=head2 C<new>

 my $obj = Tags::HTML::Commons::Vote::Setting->new(%params);

Constructor.

=over 8

=item * C<css_voting>

CSS class for root div element.

Default value is 'voting'.

=item * C<css_voting_author>

CSS class for author div element.

Default value is 'author'.

=item * C<public_image_dir>

Public image directory.

Default value is undef.

=item * C<tags>

'Tags::Output' object.

Default value is undef.

=back

=head2 C<process>

 $obj->process($images_ar);

Process Tags structure for output with list of image structures.
Each image structure consists from:
 {
         'alt' => __ALTERNATIVE_TEXT__ (optional)
         'author' => __AUTHOR_NAME__ (optional)
         'author_link' => __LINK_TO_AUTHOR_PAGE__ (optional)
         'id' => __VOTING_ID__ (required)
         'url' => __LINK_TO_IMAGE__ (required)
         'title' => __TITLE__ (optional)
         'width' => __IMAGE_WIDTH__ (optional)
 }

Returns undef.

=head1 ERRORS

 new():
         From Class::Utils::set_params():
                 Unknown parameter '%s'.

=head1 EXAMPLE1

 use strict;
 use warnings;

 use Tags::HTML::Commons::Vote::Setting;
 use Tags::Output::Indent;

 # Object.
 my $tags = Tags::Output::Indent->new;
 my $obj = Tags::HTML::Commons::Vote::Setting->new(
         'tags' => $tags,
 );

 # Process stars.
 $obj->process([{
         'author' => 'Zuzana Zónová',
         'url' => 'https://upload.wikimedia.org/wikipedia/commons/a/a4/Michal_from_Czechia.jpg',
 }, {
         'author' => 'Michal Josef Špaček',
         'url' => 'https://upload.wikimedia.org/wikipedia/commons/f/f4/Michal_Josef_%C5%A0pa%C4%8Dek_-_self_photo.jpg',
 }, {
         'url' => 'https://upload.wikimedia.org/wikipedia/commons/7/76/Michal_Josef_%C5%A0pa%C4%8Dek_-_self_photo_3.jpg',
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
