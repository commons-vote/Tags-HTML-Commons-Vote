package Tags::HTML::Commons::Vote::Utils;

use base qw(Exporter);
use strict;
use warnings;

use Error::Pure qw(err);
use Readonly;

Readonly::Array our @EXPORT_OK => qw(dt_string text);

our $VERSION = 0.01;

sub dt_string {
	my $dt = shift;

	return $dt->year.'-'.$dt->month.'-'.$dt->day;
}

sub text {
	my ($self, $key) = @_;

	if (! exists $self->{'text'}->{$self->{'lang'}}->{$key}) {
		err "Text for lang '$self->{'lang'}' and key '$key' doesn't exist.";
	}

	return $self->{'text'}->{$self->{'lang'}}->{$key};
}

1;

__END__
