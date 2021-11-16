package Tags::HTML::Commons::Vote::TagsUtils;

use base qw(Exporter);
use strict;
use warnings;

use Error::Pure qw(err);
use Readonly;
use Tags::HTML::Commons::Vote::Utils qw(text);

Readonly::Array our @EXPORT_OK => qw(tags_dl_item tags_input tags_textarea);

our $VERSION = 0.01;

sub tags_dl_item {
	my ($self, $text_key, $value) = @_;

	if (! $value) {
		return;
	}

	$self->{'tags'}->put(
		['b', 'dt'],
		['d', text($self, $text_key)],
		['e', 'dt'],

		['b', 'dd'],
		['d', $value],
		['e', 'dd'],
	);

	return;
}

sub tags_input {
	my ($self, $key, $input_type, $opts_hr) = @_;

	$input_type ||= 'text';

	$self->{'tags'}->put(
		['b', 'p'],

		['b', 'label'],
		['a', 'for', $key],
		['d', text($self, $key)],
		['e', 'label'],

		['b', 'input'],
		['a', 'type', $input_type],
		['a', 'id', $key],
		['a', 'name', $key],
		(exists $opts_hr->{'class'}) ? (
			['a', 'class', $opts_hr->{'class'}],
		) : (),
		exists $opts_hr->{'size'} ? (
			['a', 'size', $opts_hr->{'size'}],
		) : (),
		(exists $opts_hr->{'value'} && defined $opts_hr->{'value'}) ? (
			['a', 'value', $opts_hr->{'value'}],
		) : (),
		['e', 'input'],

		['e', 'p'],
	);

	return;
}

sub tags_textarea {
	my ($self, $key, $opts_hr) = @_;

	$self->{'tags'}->put(
		['b', 'p'],

		['b', 'label'],
		['a', 'for', $key],
		['d', text($self, $key)],
		['e', 'label'],

		['b', 'textarea'],
		['a', 'id', $key],
		['a', 'name', $key],
		(exists $opts_hr->{'class'}) ? (
			['a', 'class', $opts_hr->{'class'}],
		) : (),
		exists $opts_hr->{'cols'} ? (
			['a', 'cols', $opts_hr->{'cols'}],
		) : (),
		exists $opts_hr->{'rows'} ? (
			['a', 'rows', $opts_hr->{'rows'}],
		) : (),
		# TODO Value
		['e', 'textarea'],
		['e', 'p'],
	);

	return;
}

1;

__END__
