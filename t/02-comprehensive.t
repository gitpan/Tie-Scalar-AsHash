#!perl -T
use strict;
use warnings;
use Test::More tests => 45;

my ($built, $fetched, $stored, $untied, $destroyed);

{
    ($built, $fetched, $stored, $untied, $destroyed) = (0) x 5;
    tie my $tied => 'Local::Implements::All';
    is($built,     1, 'BUILD called on tie');
    is($fetched,   0, 'FETCH not called on tie');
    is($stored,    0, 'STORE not called on tie');
    is($untied,    0, 'UNTIE not called on tie');
    is($destroyed, 0, 'DESTROY not called on tie');

    ($built, $fetched, $stored, $untied, $destroyed) = (0) x 5;
    $tied = 5;
    is($built,     0, 'BUILD not called on $tied = 5');
    is($fetched,   0, 'FETCH not called on $tied = 5');
    is($stored,    1, 'STORE called on $tied = 5');
    is($untied,    0, 'UNTIE not called on $tied = 5');
    is($destroyed, 0, 'DESTROY not called on $tied = 5');

    ($built, $fetched, $stored, $untied, $destroyed) = (0) x 5;
    my $other = $tied;
    is($built,     0, 'BUILD not called on $other = $tied');
    is($fetched,   1, 'FETCH called on $other = $tied');
    is($stored,    0, 'STORE not called on $other = $tied');
    is($untied,    0, 'UNTIE not called on $other = $tied');
    is($destroyed, 0, 'DESTROY not called on $other = $tied');

    ($built, $fetched, $stored, $untied, $destroyed) = (0) x 5;
    untie $tied;
    is($built,     0, 'BUILD not called on untie');
    is($fetched,   0, 'FETCH not called on untie');
    is($stored,    0, 'STORE not called on untie');
    is($untied,    1, 'UNTIE called on untie');
    is($destroyed, 1, 'DESTROY called on untie');

    ($built, $fetched, $stored, $untied, $destroyed) = (0) x 5;
    $tied = 100;
    is($built,     0, 'BUILD not called on $tied = 100 after untie');
    is($fetched,   0, 'FETCH not called on $tied = 100 after untie');
    is($stored,    0, 'STORE not called on $tied = 100 after untie');
    is($untied,    0, 'UNTIE not called on $tied = 100 after untie');
    is($destroyed, 0, 'DESTROY not called on $tied = 100 after untie');

    ($built, $fetched, $stored, $untied, $destroyed) = (0) x 5;
    $other = $tied;
    is($built,     0, 'BUILD not called on $other = $tied after untie');
    is($fetched,   0, 'FETCH not called on $other = $tied after untie');
    is($stored,    0, 'STORE not called on $other = $tied after untie');
    is($untied,    0, 'UNTIE not called on $other = $tied after untie');
    is($destroyed, 0, 'DESTROY not called on $other = $tied after untie');

    ($built, $fetched, $stored, $untied, $destroyed) = (0) x 5;
}

is($built,     0, 'BUILD not called on scope exit after untie');
is($fetched,   0, 'FETCH not called on scope exit after untie');
is($stored,    0, 'STORE not called on scope exit after untie');
is($untied,    0, 'UNTIE not called on scope exit after untie');
is($destroyed, 0, 'DESTROY not called on scope exit after untie');

{
    ($built, $fetched, $stored, $untied, $destroyed) = (0) x 5;
    tie my $tied => 'Local::Implements::All';
    is($built,     1, 'BUILD called on second tie');
    is($fetched,   0, 'FETCH not called on second tie');
    is($stored,    0, 'STORE not called on second tie');
    is($untied,    0, 'UNTIE not called on second tie');
    is($destroyed, 0, 'DESTROY not called on second tie');
    ($built, $fetched, $stored, $untied, $destroyed) = (0) x 5;
}

is($built,     0, 'BUILD not called on scope exit while tied');
is($fetched,   0, 'FETCH not called on scope exit while tied');
is($stored,    0, 'STORE not called on scope exit while tied');
is($untied,    0, 'UNTIE not called on scope exit while tied');
is($destroyed, 1, 'DESTROY called on scope exit while tied');

package Local::Implements::All;
use parent 'Tie::Scalar::AsHash';

sub BUILD   { $built     = 1 }
sub FETCH   { $fetched   = 1 }
sub STORE   { $stored    = 1 }
sub UNTIE   { $untied    = 1 }
sub DESTROY { $destroyed = 1 }

