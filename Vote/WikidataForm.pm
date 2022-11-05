package Tags::HTML::Commons::Vote::WikidataForm;

use base qw(Tags::HTML);
use strict;
use warnings;

use Class::Utils qw(set_params split_params);
use Data::HTML::Form;
use Data::HTML::Form::Input;
use Tags::HTML::Commons::Vote::Utils qw(text);
use Tags::HTML::Form;

our $VERSION = 0.01;

# Constructor.
sub new {
	my ($class, @params) = @_;

	# Create object.
	my ($object_params_ar, $other_params_ar) = split_params(
		['css_wikidata', 'form_link', 'form_method',
		'lang', 'text'], @params);
	my $self = $class->SUPER::new(@{$other_params_ar});

	$self->{'css_wikidata'} = 'wikidata';

	# Form link.
	$self->{'form_link'} = undef;

	# Form method.
	$self->{'form_method'} = 'get';

	# Language.
	$self->{'lang'} = 'eng';

	# Language texts.
	$self->{'text'} = {
		'eng' => {
			'competition_qid' => 'Competition QID on Wikidata',
			'submit' => 'Import competition',
			'title' => 'Import competition from Wikidata record',
		},
	};

	# Process params.
	set_params($self, @{$object_params_ar});

	my $form = Data::HTML::Form->new(
		'action' => $self->{'form_link'},
		'css_class' => $self->{'css_wikidata'},
		'enctype' => 'application/x-www-form-urlencoded',
		'method' => $self->{'form_method'},
		'label' => text($self, 'title'),
	);
	my $submit = Data::HTML::Form::Input->new(
		'value' => text($self, 'submit'),
		'type' => 'submit',
	);
	$self->{'_tags_form'} = Tags::HTML::Form->new(
		'css' => $self->{'css'},
		'form' => $form,
		'submit' => $submit,
		'tags' => $self->{'tags'},
	);

	# Object.
	return $self;
}

sub _cleanup {
	my $self = shift;

	delete $self->{'_fields'};

	return;
}

sub _init {
	my $self = shift;

	if (exists $self->{'_fields'}) {
		return;
	}

	$self->{'_fields'} = [
		Data::HTML::Form::Input->new(
			'autofocus' => 1,
			'id' => 'competition_qid',
			'label' => text($self, 'competition_qid'),
			'type' => 'text',
			'required' => 1,
		),
	];

	return;
}

# Process 'Tags'.
sub _process {
	my $self = shift;

	$self->{'_tags_form'}->process(@{$self->{'_fields'}});

	return;
}

sub _process_css {
	my $self = shift;

	$self->{'_tags_form'}->process_css(@{$self->{'_fields'}});

	return;
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

Tags::HTML::Commons::Vote::WikidataForm - Tags helper for theme form.

=head1 SYNOPSIS

 use Tags::HTML::Commons::Vote::WikidataForm;

 my $obj = Tags::HTML::Commons::Vote::WikidataForm->new(%params);
 $obj->process($competition_hr);

=head1 METHODS

=head2 C<new>

 my $obj = Tags::HTML::Commons::Vote::WikidataForm->new(%params);

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

=for comment filename=theme_form.pl

 use strict;
 use warnings;

 use CSS::Struct::Output::Indent;
 use Tags::HTML::Commons::Vote::WikidataForm;
 use Tags::Output::Indent;

 # Object.
 my $css = CSS::Struct::Output::Indent->new;
 my $tags = Tags::Output::Indent->new;
 my $obj = Tags::HTML::Commons::Vote::WikidataForm->new(
         'css' => $css,
         'tags' => $tags,
 );

 # Process theme.
 $obj->process($theme);
 $obj->process_css;

 # Print out.
 print "HTML:\n";
 print $tags->flush;
 print "\n\n";
 print "CSS:\n";
 print $css->flush;

 # Output:
 # TODO

=head1 DEPENDENCIES

L<Class::Utils>,
L<Data::HTML::Form>,
L<Data::HTML::Form::Input>,
L<Data::HTML::Textarea>,
L<Tags::HTML>,
L<Tags::HTML::Form>,
L<Tags::HTML::Commons::Vote::Utils>.

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
