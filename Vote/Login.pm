package Tags::HTML::Commons::Vote::Login;

use base qw(Tags::HTML);
use strict;
use warnings;

use Class::Utils qw(set_params split_params);
use Commons::Link;
use Error::Pure qw(err);
use Scalar::Util qw(blessed);
use Tags::HTML::Commons::Vote::Utils qw(text);
use Unicode::UTF8 qw(decode_utf8);

our $VERSION = 0.01;

# Constructor.
sub new {
	my ($class, @params) = @_;

	# Create object.
	my ($object_params_ar, $other_params_ar) = split_params(
		['css_login', 'lang', 'text'], @params);
	my $self = $class->SUPER::new(@{$other_params_ar});

	$self->{'css_login'} = 'login';

	# Language.
	$self->{'lang'} = 'eng';

	# Login link.
	$self->{'login_link'} = 'login';

	# Language texts.
	$self->{'text'} = {
		'eng' => {
			'login_button_title' => 'Login with OAuth2',
			'welcome' => 'Welcome to Commons Vote',
		},
	};

	# Process params.
	set_params($self, @{$object_params_ar});

	if (! defined $self->{'login_link'}) {
		err "Parameter 'login_link' is required.";
	}

	$self->{'_commons_link'} = Commons::Link->new;

	# Object.
	return $self;
}

sub _license {
	my ($self, $image) = @_;

	if (defined $self->{'_image'}->license_obj) {
		if (defined $self->{'_image'}->license_obj->short_name) {
			return $self->{'_image'}->license_obj->short_name;
		} elsif (defined $self->{'_image'}->license_obj->name) {
			return $self->{'_image'}->license_obj->name;
		}
	} elsif (defined $self->{'_image'}->license) {
		return $self->{'_image'}->license
	}
}

# Process 'Tags'.
sub _process {
	my $self = shift;

	my @bottom_right_text;
	if (defined $self->{'_image'}) {
		my $commons_link = $self->{'_commons_link'}->mw_file_link(
			$self->{'_image'}->commons_name);
		push @bottom_right_text, (
			['b', 'a'],
			['a', 'href', $commons_link],
			['d', 'Image'],
			['e', 'a'],
		);
		if (defined $self->{'_image'}->author) {
			my $bottom_right_text;
			if (@bottom_right_text) {
				$bottom_right_text .= ' by';
			}
			$bottom_right_text .= decode_utf8('© ').
				$self->{'_image'}->author;
			push @bottom_right_text, ['d', $bottom_right_text];
		}
		my $license = $self->_license($self->{'_image'});
		if (defined $license) {
			my $bottom_right_text;
			if (@bottom_right_text) {
				$bottom_right_text .= ', ';
			}
			$bottom_right_text .= 'distributed under a ';
			$bottom_right_text .= $license;
			$bottom_right_text .= ' license';
			push @bottom_right_text, ['d', $bottom_right_text];
		}
	}

	$self->{'tags'}->put(
		['b', 'div'],
		['a', 'class', 'box'],

		['b', 'h1'],
		['d', text($self, 'welcome')],
		['e', 'h1'],

		['b', 'div'],
		['a', 'class', 'login'],

		['b', 'a'],
		['a', 'href', $self->{'login_link'}],
		['d', text($self, 'login_button_title')],
		['e', 'a'],

		['e', 'div'],

		['e', 'div'],

		@bottom_right_text ? (
			['b', 'div'],
			['a', 'class', 'bottom-right'],
			@bottom_right_text,
			['e', 'div'],
		) : (),
	);

	delete $self->{'_image'};

	return;
}

sub _process_css {
	my ($self, $theme) = @_;

	if (! blessed($theme) || ! $theme->isa('Data::Commons::Vote::Theme')) {
		err "Theme object must be a 'Data::Commons::Vote::Theme'.";
	}

	$self->{'_image'} = undef;
	my $number_of_images = scalar @{$theme->images};
	my $url;
	if ($number_of_images) {
		my $rand_index = int(rand($number_of_images));
		$self->{'_image'} = $theme->images->[$rand_index];
		if (defined $self->{'_image'}->url) {
			$url = $self->{'_image'}->url;
		} elsif (defined $self->{'_image'}->url_cb) {
			$url = $self->{'_image'}->url_cb->();
		} elsif (defined $self->{'_image'}->commons_name) {
			$url = $self->{'_commons_link'}->link($self->{'_image'}->commons_name);
		}
	}

	$self->{'css'}->put(
		defined $url ? (
			['s', 'body'],
			['d', 'background-image', 'url('.$url.')'],
			['d', 'background-size', 'cover'],
			['e'],
		) : (),

		['s', '.box'],
		['d', 'position', 'absolute'],
		['d', 'top', 'calc(50% - 30px)'],
		['d', 'left', '50%'],
		['d', 'transform', 'translate(-50%, -50%)'],
		['d', 'padding', '30px'],
		['d', 'background', 'hsla(0,0%,100%,.8)'],
		['e'],

		['s', '.box h1'],
		['d', 'font-family', 'sans-serif'],
		['d', 'display', 'block'],
		['d', 'margin', '0 0 10px 0'],
		['e'],

		['s', '.'.$self->{'css_login'}],
		['d', 'text-align', 'center'],
		['d', 'padding', '15px 40px'],
		['e'],

		['s', '.'.$self->{'css_login'}.' a'],
		['d', 'text-decoration', 'none'],
		['d', 'background-image', 'linear-gradient(to bottom,#fff 0,#e0e0e0 100%)'],
		['d', 'background-repeat', 'repeat-x'],
		['d', 'border', '1px solid #adadad'],
		['d', 'border-radius', '4px'],
		['d', 'color', 'black'],
		['d', 'font-family', 'sans-serif!important'],
		['d', 'padding', '15px 40px'],
		['e'],

		['s', '.'.$self->{'css_login'}.' a:hover'],
		['d', 'background-color', '#e0e0e0'],
		['d', 'background-image', 'none'],
		['e'],

		['s', '.bottom-right'],
		['d', 'position', 'absolute'],
		['d', 'bottom', '8px'],
		['d', 'right', '16px'],
		['d', 'color', 'white'],
		['d', 'font-family', 'sans-serif'],
		['e'],

		['s', '.bottom-right a'],
		['d', 'color', 'white'],
		['e'],
	);

	return;
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

Tags::HTML::Commons::Vote::Login - Tags helper for login page.

=head1 SYNOPSIS

 use Tags::HTML::Commons::Vote::Login;

 my $obj = Tags::HTML::Commons::Vote::Login->new(%params);
 $obj->process;
 $obj->process_css;

=head1 METHODS

=head2 C<new>

 my $obj = Tags::HTML::Commons::Vote::Login->new(%params);

Constructor.

=over 8

=item * C<css>

TODO

=item * C<css_login>

CSS class for root div element.

Default value is 'login'.

=item * C<lang>

TODO

=item * C<lang>

TODO

=item * C<login_link>

TODO

=item * C<text>

TODO

=item * C<tags>

'Tags::Output' object.

Default value is undef.

=back

=head2 C<process>

 $obj->process;

Process Tags structure for output of login page.

Returns undef.

=head1 ERRORS

 new():
         From Class::Utils::set_params():
                 Unknown parameter '%s'.

=head1 EXAMPLE1

=for comment filename=commons_vote_login.pl

 use strict;
 use warnings;

 use CSS::Struct::Output::Indent;
 use Tags::HTML::Commons::Vote::Login;
 use Tags::Output::Indent;

 # Object.
 my $css = CSS::Struct::Output::Indent->new;
 my $tags = Tags::Output::Indent->new;
 my $obj = Tags::HTML::Commons::Vote::Login->new(
         'css' => $css,
         'tags' => $tags,
 );

 # Process HTML and CSS..
 $obj->process;
 $obj->process_css;

 # Print out.
 print $tags->flush;
 print "\n\n";
 print $css->flush;

 # Output:
 # TODO

=head1 DEPENDENCIES

L<Class::Utils>,
L<Tags::HTML>,
L<Tags::HTML::Commons::Vote::Utils>,
L<Tags::HTML::Login::Button>.

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
