package Tags::HTML::Commons::Vote::TagsUtils;

use base qw(Exporter);
use strict;
use warnings;

use Error::Pure qw(err);
use Readonly;
use Tags::HTML::Commons::Vote::Utils qw(text);

Readonly::Array our @EXPORT_OK => qw(tags_textarea);

our $VERSION = 0.01;

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
		(exists $opts_hr->{'req'} && $opts_hr->{'req'}) ? (
			['a', 'class', 'req'],
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
