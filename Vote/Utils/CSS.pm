package Tags::HTML::Commons::Vote::Utils::CSS;

use base qw(Exporter);
use strict;
use warnings;

use Readonly;

Readonly::Array our @EXPORT_OK => qw(a_button float_right);

our $VERSION = 0.01;

sub a_button {
	my ($self, $selector) = @_;

	$self->{'css'}->put(
		['s', $selector],
		['d', 'display', 'inline-block'],
		['d', 'color', '#fff'],
		['d', 'background-color', '#337ab7'],
		['d', 'text-shadow', '0 -1px 0 rgb(0 0 0 / 20%)'],
		['d', 'box-shadow', 'inset 0 1px 0 rgb(255 255 255 / 15%), 0 1px 1px rgb(0 0 0 / 8%)'],
		['d', 'cursor', 'pointer'],
		['d', 'border', '1px solid transparent'],
		['d', 'border-radius', '4px'],
		['d', 'padding', '6px 12px'],
		['d', 'margin', '2px'],
		['d', 'font-size', '14px'],
		['d', 'font-weight', '400'],
		['d', 'text-align', 'center'],
		['d', 'white-space', 'nowrap'],
		['d', 'line-height', '1.42857143'],
		['d', 'text-decoration', 'none'],
		['e'],
	);

	return;
}

sub float_right {
	my ($self, $selector) = @_;

	$self->{'css'}->put(
		['s', $selector],
		['d', 'float', 'right'],
		['e'],
	);
}

1;

__END__
