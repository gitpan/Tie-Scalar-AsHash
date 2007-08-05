#!perl -T
use strict;
use warnings;
use Test::More tests => 3;

eval { tie my $nobuild, 'Local::NoBuild' };
is($@, '', "lacking BUILD is OK");

tie my $nofetch, 'Local::NoFetch';
eval { my $x = $nofetch };
like($@, qr/FETCH not implemented in Local::NoFetch /, "no FETCH is an error");

tie my $nostore, 'Local::NoStore';
eval { $nostore = 3 };
like($@, qr/STORE not implemented in Local::NoStore /, "no STORE is an error");


package Local::NoFetch;
use parent 'Tie::Scalar::AsHash';
sub BUILD { my ($self, $value) = @_; $self->{value} = $value }
sub STORE { my ($self, $value) = @_; $self->{value} = $value }

package Local::NoStore;
use parent 'Tie::Scalar::AsHash';
sub BUILD { my ($self, $value) = @_; $self->{value} = $value }
sub FETCH { my ($self) = @_; $self->{value} }

package Local::NoBuild;
use parent 'Tie::Scalar::AsHash';
sub FETCH { my ($self) = @_; $self->{value} }
sub STORE { my ($self, $value) = @_; $self->{value} = $value }

