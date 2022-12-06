package Tags::HTML::Commons::Vote::Vote;

use base qw(Tags::HTML);
use strict;
use warnings;

use Class::Utils qw(set_params split_params);
use Error::Pure qw(err);
use Scalar::Util qw(blessed);
use Tags::HTML::Commons::Vote::Utils qw(text value);
use Tags::HTML::Image;

our $VERSION = 0.01;

# Constructor.
sub new {
	my ($class, @params) = @_;

	# Create object.
	my ($object_params_ar, $other_params_ar) = split_params(
		['css_comment_height', 'css_voting', 'fit_minus', 'form_link',
		'form_method', 'img_src_cb', 'img_width', 'lang', 'text', 'voting_text_cb'],
		@params);
	my $self = $class->SUPER::new(@{$other_params_ar});

	# CSS comment height.
	$self->{'css_comment_height'} = 50;

	# CSS class.
	$self->{'css_voting'} = 'voting';

	# Length to minus of image fit.
	$self->{'fit_minus'} = undef;

	# Form link.
	$self->{'form_link'} = undef;

	# Form method.
	$self->{'form_method'} = 'get';

	# Image src callback across data object.
	$self->{'img_src_cb'} = undef;

	# Image width in pixels.
	$self->{'img_width'} = undef;

	# Language.
	$self->{'lang'} = 'eng';

	# Language texts.
	$self->{'text'} = {
		'eng' => {
			'next_image' => 'Next image',
			'submit_vote' => 'Vote',
			'submit_unvote' => 'Unvote',
			'title' => 'Vote',
			'vote_not_exists' => 'Vote not exists.',
			'voted_no' => 'Not voted',
			'voted_yes' => 'Voted',
			'voting_type_anonymous_voting' => 'Anonymous voting',
			'voting_type_login_voting' => 'Voting after login',
			'voting_type_jury_voting' => 'Jury voting',
		},
	};

	# Voting text callback.
	$self->{'voting_text_cb'} = undef;

	# Process params.
	set_params($self, @{$object_params_ar});

	$self->{'_tags_image'} = Tags::HTML::Image->new(
		'css' => $self->{'css'},
		'css_comment_height' => $self->{'css_comment_height'},
		'fit_minus' => $self->{'fit_minus'},
		'img_comment_cb' => sub {
			my ($image_self, $image, $vote_self, @params) = @_;
			return $vote_self->_comment_cb($image, @params);
		},
		'img_src_cb' => $self->{'img_src_cb'},
		'img_width' => $self->{'img_width'},
		'tags' => $self->{'tags'},
	);

	# Check voting text callback.
	if (defined $self->{'voting_text_cb'} && ref $self->{'voting_text_cb'} ne 'CODE') {
		err "Parameter 'voting_text_cb' must be a callback.";
	}

	# Object.
	return $self;
}

sub _cleanup {
	my $self = shift;

	$self->{'_tags_image'}->cleanup;

	delete $self->{'_ip_address'};
	delete $self->{'_vote'};
	delete $self->{'_voting_text'};

	return;
}

sub _comment_cb {
	my ($self, $image, $vote, $ip_address, $next_image_id) = @_;

	my $voting_type = $vote->competition_voting->voting_type->type;
	my $vote_value = $vote->vote_value;

	# Diables submit.
	my $submit_disabled;
	if ($voting_type eq 'anonymous_voting' && defined $vote->vote_value) {
		$submit_disabled = 1;
	}

	my $submit_value;
	if ($vote_value && ! defined $vote->competition_voting->number_of_votes
		&& ($voting_type eq 'jury_voting' || $voting_type eq 'login_voting')) {

		$submit_value = text($self, 'submit_unvote');
	} else {
		$submit_value = text($self, 'submit_vote')
	}

	my @tags = (
		['b', 'form'],
		defined $self->{'form_link'} ? (['a', 'action', $self->{'form_link'}]) : (),
		defined $self->{'form_method'} ? (['a', 'method', $self->{'form_method'}]) : (),

		['b', 'input'],
		['a', 'type', 'hidden'],
		['a', 'id', 'next_image_id'],
		['a', 'name', 'next_image_id'],
		defined $next_image_id ? (['a', 'value', $next_image_id]) : (),
		['e', 'input'],

		['b', 'input'],
		['a', 'type', 'hidden'],
		['a', 'id', 'competition_voting_id'],
		['a', 'name', 'competition_voting_id'],
		defined $vote->competition_voting->id ? (['a', 'value', $vote->competition_voting->id]) : (),
		['e', 'input'],

		['b', 'input'],
		['a', 'type', 'hidden'],
		['a', 'id', 'image_id'],
		['a', 'name', 'image_id'],
		defined $vote->image->id ? (['a', 'value', $vote->image->id]) : (),
		['e', 'input'],

		defined $next_image_id ? (
			['b', 'input'],
			['a', 'class', 'next-button'],
			['a', 'type', 'submit'],
			['a', 'id', 'next_image'],
			['a', 'name', 'next_image'],
			['a', 'value', text($self, 'next_image')],
			['e', 'input'],
		) : (),
	);
	if (($voting_type eq 'jury_voting' || $voting_type eq 'login_voting')
		&& defined $vote->competition_voting->number_of_votes) {

		foreach my $number (0 .. $vote->competition_voting->number_of_votes) {
			push @tags, (
				['b', 'input'],
				['a', 'type', 'radio'],
				['a', 'name', 'vote_value'],
				['a', 'id', $number],
				['a', 'value', $number],
				defined $vote_value && $vote_value == $number ? (['a', 'checked', 'checked']) : (),
				['e', 'input'],
				['b', 'label'],
				['a', 'for', $number],
				['d', $number],
				['e', 'label'],
			);
		}
	} else {
		if ($voting_type eq 'anonymous_voting') {
			$vote_value = $ip_address;
		} else {
			$vote_value = defined $vote_value ? '' : 1;
		}
		push @tags, (
			['b', 'input'],
			['a', 'type', 'hidden'],
			['a', 'id', 'vote_value'],
			['a', 'name', 'vote_value'],
			defined $vote_value ? (['a', 'value', $vote_value]) : (),
			['e', 'input'],
		);
	}
	push @tags, (
		['b', 'input'],
		['a', 'type', 'submit'],
		['a', 'name', 'vote'],
		['a', 'value', $submit_value],
		$submit_disabled ? (['a', 'disabled', 'disabled']) : (),
		['e', 'input'],
		['e', 'form'],
	);

	my @css = (
		['s', 'input[type=radio]'],
		['d', 'display', 'none'],
		['e'],

		['s', 'label'],
		['d', 'font-size', '20px'],
		['d', 'margin', '8px 0'],
		['d', 'padding', '14px 20px'],
		['d', 'user-select', 'none'],
		['e'],

		['s', 'input[type=radio]:checked + label'],
		['d', 'background-color', '#0000CD'],
		['d', 'border', 'none'],
		['d', 'border-radius', '4px'],
		['d', 'color', 'white'],
		['d', 'cursor', 'pointer'],
		['d', 'user-select', 'none'],
		['e'],

		['s', 'input[type=submit]'],
		['d', 'background-color', '#4CAF50'],
		['d', 'border', 'none'],
		['d', 'border-radius', '4px'],
		['d', 'color', 'white'],
		['d', 'cursor', 'pointer'],
		['d', 'font-size', '20px'],
		['d', 'margin', '8px 0'],
		['d', 'padding', '14px 20px'],
		['e'],

		['s', 'input[type=submit].next-button'],
		['d', 'background-color', '#888888'],
		['e'],

		['s', 'input[type=submit].next-button:hover'],
		['d', 'background-color', '#787878'],
		['e'],
	);

	return (
		\@tags,
		\@css,
	);
}

sub _init {
	my ($self, $vote, $ip_address, $next_image_id) = @_;

	if (exists $self->{'_vote'}) {
		return;
	}
	if (! defined $vote) {
		return;
	}

	if (! blessed($vote) || ! $vote->isa('Data::Commons::Vote::Vote')) {
		err "Vote must be a 'Data::Commons::Vote::Vote' vote object.";
	}

	$self->{'_ip_address'} = $ip_address;
	$self->{'_vote'} = $vote;

	# Information about voting.
	my $voting_type = $self->{'_vote'}->competition_voting->voting_type->type;
	if (defined $self->{'voting_text_cb'}) {
		$self->{'_voting_text'} = $self->{'voting_text_cb'}->($self, $self->{'_vote'});
	} else {

		# Voting 0 .. X
		if (($voting_type eq 'jury_voting' || $voting_type eq 'login_voting')
			&& defined $self->{'_vote'}->competition_voting->number_of_votes) {

			if (defined $self->{'_vote'}->vote_value) {
				$self->{'_voting_text'} = $self->{'_vote'}->vote_value;
			} else {
				$self->{'_voting_text'} = text($self, 'voted_no');
			}

		# Voting yes/no.
		} else {
			if (defined $self->{'_vote'}->vote_value) {
				$self->{'_voting_text'} = text($self, 'voted_yes');
			} else {
				$self->{'_voting_text'} = text($self, 'voted_no');
			};
		}
	}

	$self->{'_tags_image'}->init(
		$self->{'_vote'}->image,
		$self,
		$vote,
		$ip_address,
		$next_image_id,
	);

	return;
}

# Process 'Tags'.
sub _process {
	my $self = shift;

	if (! exists $self->{'_vote'}) {
		$self->{'tags'}->put(
			['d', text($self, 'vote_not_exists')],
		);

		return;
	}

	$self->{'tags'}->put(
		['b', 'div'],
		['a', 'class', $self->{'css_voting'}],
	);

	$self->{'_tags_image'}->process;

	$self->{'tags'}->put(
		['e', 'div'],
	);

	return;
}

sub _process_css {
	my $self = shift;

	if (! exists $self->{'_vote'}) {
		return;
	}

	$self->{'_tags_image'}->process_css;

	return;
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

Tags::HTML::Commons::Vote::Vote - Tags helper for image voting.

=head1 SYNOPSIS

 use Tags::HTML::Commons::Vote::Vote;

 my $obj = Tags::HTML::Commons::Vote::Vote->new(%params);
 $obj->process(@images);

=head1 METHODS

=head2 C<new>

 my $obj = Tags::HTML::Commons::Vote::Vote->new(%params);

Constructor.

Returns instance of object.

=over 8

=item * C<css>

'CSS::Struct::Output' object for process_css processing.

Default value is undef.

=item * C<css_voting>

CSS class for root div element.

Default value is 'voting'.

=item * C<form_link>

Form action link.

Default value is undef.

=item * C<form_method>

Form method.

Default value is 'get'.

=item * C<img_src_cb>

Image src callback across data object.

Default value is undef.

=item * C<img_width>

Image width in pixels.

Default value is undef, which mean 100% to page.

=item * C<lang>

Language for output texts.

Default value is 'eng'.

=item * C<tags>

'Tags::Output' object.

Default value is undef.

=item * C<text>

Data structure which has texts for module.
Keys are language keys.
Values are hash structures with texts.
Text keys are: submit, title, voted_no and voted_yes.

Default value is:

 {
         'eng' => {
                 'submit' => 'Vote',
                 'title' => 'Vote',
                 'voted_no' => 'Not voted',
                 'voted_yes' => 'Voted',
         },
 }

=item * C<voting_text_cb>

Voting text callback.
Arguments are: C<$self> and C<$vote> L<Data::Commons::Vote::Vote> object.
If is this callback undefined, it's used 'voted_no' and 'voted_yes' texts.

=back

=head2 C<process>

 $obj->process($vote);

Process Tags structure for C<$vote>, which is instance of
L<Data::Commons::Vote::Vote>.

Returns undef.

=head2 C<process_css>

 $obj->process_css();

Process CSS structure.

=head1 ERRORS

 new():
         From Class::Utils::set_params():
                 Unknown parameter '%s'.

=head1 EXAMPLE1

=for comment filename=create_and_print_vote.pl

 use strict;
 use warnings;

 use Commons::Link;
 use CSS::Struct::Output::Indent;
 use Data::Commons::Vote::Competition;
 use Data::Commons::Vote::Image;
 use Data::Commons::Vote::Person;
 use Data::Commons::Vote::Vote;
 use Data::Commons::Vote::VotingType;
 use DateTime;
 use Tags::HTML::Commons::Vote::Vote;
 use Tags::Output::Indent;

 # Object.
 my $css = CSS::Struct::Output::Indent->new;
 my $tags = Tags::Output::Indent->new;
 my $obj = Tags::HTML::Commons::Vote::Vote->new(
         'css' => $css,
         'tags' => $tags,
 );

 # Vote object.
 my $db_creator = Data::Commons::Vote::Person->new(
         'name' => 'Michal Josef Spacek',
 );
 my $uploader = Data::Commons::Vote::Person->new(
         'name' => 'Zuzana Zonova',
 );
 my $voter = Data::Commons::Vote::Person->new(
         'name' => 'Jan Novak',
 );
 my $competition = Data::Commons::Vote::Competition->new(
         'created_by' => $db_creator,
         'dt_from' => DateTime->new(
                  'day' => 14,
                  'month' => 7,
                  'year' => 2009,
         ),
         'dt_to' => DateTime->new(
                  'day' => 24,
                  'month' => 7,
                  'year' => 2009,
         ),
         'name' => 'Example competition',
 );
 my $image = Data::Commons::Vote::Image->new(
         'comment' => 'Michal from Czechia',
         'id' => 1,
         'image' => 'Michal from Czechia.jpg',
         'uploader' => $uploader,
 );
 my $voting_type = Data::Commons::Vote::VotingType->new(
         'created_by' => $db_creator,
         'type' => 'public_voting',
 );
 my $vote = Data::Commons::Vote::Vote->new(
         'competition' => $competition,
         'image' => $image,
         'person' => $voter,
         'voting_type' => $voting_type,
 );

 # Process vote.
 $obj->process_css;
 $obj->process($vote);

 # Print out.
 print "CSS\n";
 print $css->flush;
 print "\n\n";
 print "HTML\n";
 print $tags->flush;

 # Output:
 # CSS
 # .voting-info {
 #         text-align: center;
 #         color: green;
 #         font-size: 2em;
 #         margin: 1em;
 # }
 # .image img {
 #         width: 100%;
 # }
 # .voting-form {
 #         border-radius: 5px;
 #         background-color: #f2f2f2;
 #         padding: 20px;
 # }
 # .voting-form input[type=submit]:hover {
 #         background-color: #45a049;
 # }
 # .voting-form input[type=submit] {
 #         width: 100%;
 #         background-color: #4CAF50;
 #         color: white;
 #         padding: 14px 20px;
 #         margin: 8px 0;
 #         border: none;
 #         border-radius: 4px;
 #         cursor: pointer;
 # }
 # .voting-form input, select, textarea {
 #         width: 100%;
 #         padding: 12px 20px;
 #         margin: 8px 0;
 #         display: inline-block;
 #         border: 1px solid #ccc;
 #         border-radius: 4px;
 #         box-sizing: border-box;
 # }
 # .voting-form-required {
 #         color: red;
 # }
 # 
 # HTML
 # <div class="voting">
 #   <div class="voting-info">
 #     Not voted
 #   </div>
 #   <div class="image">
 #     <img src="Michal from Czechia.jpg">
 #     </img>
 #   </div>
 #   <form class="voting-form" method="get">
 #     <p>
 #       <input type="hidden" name="competition_id" id="competition_id">
 #       </input>
 #       <input type="hidden" name="image_id" id="image_id" value="1">
 #       </input>
 #       <input type="hidden" name="vote_type_id" id="vote_type_id">
 #       </input>
 #     </p>
 #     <p>
 #       <input type="submit" value="Vote">
 #       </input>
 #     </p>
 #   </form>
 # </div>

=head1 DEPENDENCIES

L<Class::Utils>,
L<Error::Pure>,
L<Scalar::Util>,
L<Tags::HTML>,
L<Tags::HTML::Commons::Vote::Utils>,
L<Tags::HTML::Image>.

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
