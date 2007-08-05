#!perl -T
use strict;
use warnings;
use Test::More tests => 7;

tie my $tot => 'Tie::Scalar::ThisOrThat', 'this', 'that';

my %seen;
for (1..100)
{
    $seen{$tot} = 1;
}
ok($seen{this}, "saw 'this'");
ok($seen{that}, "saw 'that'");
is(keys %seen, 2, "saw ONLY 'this' and 'that'");

$tot = 'the other';
for (1..100)
{
    $seen{$tot} = 1;
}
ok($seen{this}, "saw 'this'");
ok($seen{that}, "saw 'that'");
ok($seen{'the other'}, "saw 'the other'");
is(keys %seen, 3, "saw ONLY 'this', 'that', and 'the other'");

package Tie::Scalar::ThisOrThat;
use parent 'Tie::Scalar::AsHash';

sub BUILD {
    my $self = shift;
    $self->{this} = shift;
    $self->{that} = shift;
}
sub FETCH {
    my ($self) = @_;
    rand(2) < 1 ? $self->{this} : $self->{that}
}
sub STORE {
    my ($self, $value) = @_;
    (rand(2) < 1 ? $self->{this} : $self->{that}) = $value
}

