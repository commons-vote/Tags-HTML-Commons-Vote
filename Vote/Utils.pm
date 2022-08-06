package Tags::HTML::Commons::Vote::Utils;

use base qw(Exporter);
use strict;
use warnings;

use Error::Pure qw(err);
use Readonly;
use Scalar::Util qw(blessed);

Readonly::Array our @EXPORT_OK => qw(dt_string text value);

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

sub value {
	my ($self, $object, $method, $callback) = @_;

	if (! defined $object
		|| ! blessed($object)
		|| ! defined $object->$method) {

		return ();
	} else {
		if (defined $callback) {
			return ('value' => &$callback($object->$method));
		} else {
			return ('value' => $object->$method);
		}
	}
}

1;

__END__
