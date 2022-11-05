package Tags::HTML::Commons::Vote::Vote;

use base qw(Tags::HTML);
use strict;
use warnings;

use Class::Utils qw(set_params split_params);
use Data::HTML::Form;
use Data::HTML::Form::Input;
use Error::Pure qw(err);
use Scalar::Util qw(blessed);
use Tags::HTML::Commons::Vote::Utils qw(text value);
use Tags::HTML::Form;
use Tags::HTML::Image;

our $VERSION = 0.01;

# Constructor.
sub new {
	my ($class, @params) = @_;

	# Create object.
	my ($object_params_ar, $other_params_ar) = split_params(
		['css_voting', 'form_link', 'form_method', 'img_src_cb',
		'img_width', 'lang', 'text', 'voting_text_cb'], @params);
	my $self = $class->SUPER::new(@{$other_params_ar});

	# CSS class.
	$self->{'css_voting'} = 'voting';

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

	$self->{'_data_form'} = Data::HTML::Form->new(
		'action' => $self->{'form_link'},
		'css_class' => $self->{'css_voting'}.'-form',
		'enctype' => 'application/x-www-form-urlencoded',
		'method' => $self->{'form_method'},
		'title' => text($self, 'title'),
	);

	$self->{'_tags_image'} = Tags::HTML::Image->new(
		'css' => $self->{'css'},
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

	delete $self->{'_fields'};
	delete $self->{'_ip_address'};
	delete $self->{'_vote'};

	return;
}

sub _init {
	my ($self, $vote, $ip_address, $next_image_id) = @_;

	if (exists $self->{'_fields'}) {
		return;
	}
	if (! defined $vote) {
		return;
	}

	if (! blessed($vote) || ! $vote->isa('Data::Commons::Vote::Vote')) {
		err "Vote must be a 'Data::Commons::Vote::Vote' vote object.";
	}

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
	my $submit = Data::HTML::Form::Input->new(
		$submit_disabled ? ('disabled' => 1) : (),
		'value' => $submit_value,
		'type' => 'submit',
	);

	$self->{'_tags_form'} = Tags::HTML::Form->new(
		'css' => $self->{'css'},
		'form' => $self->{'_data_form'},
		'submit' => $submit,
		'tags' => $self->{'tags'},
	);

	$self->{'_vote'} = $vote;
	$self->{'_fields'} = [
		Data::HTML::Form::Input->new(
			'id' => 'competition_voting_id',
			'required' => 1,
			'type' => 'hidden',
			value($self, $vote->competition_voting, 'id'),
		),
		Data::HTML::Form::Input->new(
			'id' => 'image_id',
			'required' => 1,
			'type' => 'hidden',
			value($self, $vote->image, 'id'),
		),
	];
	if (($voting_type eq 'jury_voting' || $voting_type eq 'login_voting')
		&& defined $vote->competition_voting->number_of_votes) {

		foreach my $number (0 .. $vote->competition_voting->number_of_votes) {
			push @{$self->{'_fields'}}, (
				Data::HTML::Form::Input->new(
					'id' => 'vote_value',
					'label' => $number,
					'type' => 'radio',
					'value' => $number,
					defined $vote_value && $vote_value == $number ? ('checked' => 1) : (),
				),
			);
		}
	} else {
		if ($voting_type eq 'anonymous_voting') {
			$vote_value = $ip_address;
			$self->{'_ip_address'} = $ip_address;
		} else {
			$vote_value = defined $vote_value ? '' : 1;
		}
		push @{$self->{'_fields'}}, (
			Data::HTML::Form::Input->new(
				'id' => 'vote_value',
				'type' => 'hidden',
				'value' => $vote_value,
			),
		);
	}
	if (defined $next_image_id) {
		push @{$self->{'_fields'}}, (
			Data::HTML::Form::Input->new(
				'id' => 'next_image_id',
				'type' => 'hidden',
				'value' => $next_image_id,
			),
			Data::HTML::Form::Input->new(
				'css_class' => 'next-button',
				'id' => 'next_image',
				'type' => 'submit',
				'value' => text($self, 'next_image'),
			),
		);
	}

	return;
}

# Process 'Tags'.
sub _process {
	my $self = shift;

	if (! exists $self->{'_fields'}) {
		$self->{'tags'}->put(
			['d', text($self, 'vote_not_exists')],
		);

		return;
	}

	$self->{'tags'}->put(
		['b', 'div'],
		['a', 'class', $self->{'css_voting'}],
	);

	my $voting_type = $self->{'_vote'}->competition_voting->voting_type->type;

	# Print IP address.
	my $ip_address;
	if ($voting_type eq 'anonymous_voting') {
		$ip_address = $self->{'_ip_address'};
	}

	# Information about voting.
	my $voting_text;
	if (defined $self->{'voting_text_cb'}) {
		$voting_text = $self->{'voting_text_cb'}->($self, $self->{'_vote'});
	} else {

		# Voting 0 .. X
		if (($voting_type eq 'jury_voting' || $voting_type eq 'login_voting')
			&& defined $self->{'_vote'}->competition_voting->number_of_votes) {

			if (defined $self->{'_vote'}->vote_value) {
				$voting_text = $self->{'_vote'}->vote_value;
			} else {
				$voting_text = text($self, 'voted_no');
			}

		# Voting yes/no.
		} else {
			if (defined $self->{'_vote'}->vote_value) {
				$voting_text = text($self, 'voted_yes');
			} else {
				$voting_text = text($self, 'voted_no');
			};
		}
	}
	my $voting_type_text;
	$self->{'tags'}->put(
		['b', 'div'],
		['a', 'class', $self->{'css_voting'}.'-info'],
		['b', 'span'],
		['a', 'style', 'color: black'],
		['d', text($self, 'voting_type_'.$voting_type)],
		['e', 'span'],
		['b', 'br'],
		['e', 'br'],
		defined $ip_address ? (
			['d', $ip_address],
			['b', 'br'],
			['e', 'br'],
		) : (),
		['d', $voting_text],
		['e', 'div'],
	);

	$self->{'_tags_image'}->process($self->{'_vote'}->image);

	$self->{'_tags_form'}->process(@{$self->{'_fields'}});

	$self->{'tags'}->put(
		['e', 'div'],
	);

	return;
}

sub _process_css {
	my $self = shift;

	if (! exists $self->{'_fields'}) {
		return;
	}

	$self->{'css'}->put(
		['s', '.'.$self->{'css_voting'}.'-info'],
		['d', 'text-align', 'center'],
		['d', 'color', 'green'],
		['d', 'font-size', '2em'],
		['d', 'margin', '1em'],
		['e'],

		['s', 'input[type=submit].next-button'],
		['d', 'background-color', '#888888'],
		['e'],

		['s', 'input[type=submit].next-button:hover'],
		['d', 'background-color', '#787878'],
		['e'],
	);

	$self->{'_tags_image'}->process_css;

	$self->{'_tags_form'}->process_css(@{$self->{'_fields'}});

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
L<Data::HTML::Form>,
L<Data::HTML::Form::Input>,
L<Error::Pure>,
L<Scalar::Util>,
L<Tags::HTML>,
L<Tags::HTML::Commons::Vote::Utils>,
L<Tags::HTML::Form>,
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
