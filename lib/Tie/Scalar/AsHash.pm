#!perl
package Tie::Scalar::AsHash;
use strict;
use warnings;
use Scalar::Util qw(blessed);
use Carp;

=head1 NAME

Tie::Scalar::AsHash - base class of hashref-based tied scalars

=head1 VERSION

Version 0.01 released 05 Aug 07

=cut

our $VERSION = '0.01';

=head1 SYNOPSIS

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

    tie my $tot => 'Tie::Scalar::ThisOrThat', 'this', 'that';

=head1 MOTIVATION

This module exists because I wanted a hashref based tied scalar. There exists
the L<Tie::StdScalar> module which almost did what I wanted, except it only
provides scalar-reference based tied scalars -- only one slot for storage.

It also exists so I won't have to write any more L<TIESCALAR>s. I can just
write L<BUILD>s instead.

=cut

# you should not be overriding this!
sub TIESCALAR
{
    my $class = shift;

    my $self = bless {}, $class;
    $self->BUILD(@_);
    return $self;
}

=head1 MANDATORY METHODS

=head2 FETCH

This fetches a value for the scalar. There's no reasonable default here, so you
must override it.

=cut

sub FETCH { Carp::croak "FETCH not implemented in " . blessed(shift) }

=head2 STORE

This stores a value for the scalar. There's no reasonable default here, so you
must override it.

=cut

sub STORE { Carp::croak "STORE not implemented in " . blessed(shift) }

=head1 OTHER METHODS

=head2 BUILD

This is called to perform any initialization for your internal state. You're
passed an appropriate C<$self> which will be a hash reference. You'll also
receive any optional arguments given to C<tie>, such as C<qw(foo 1 baz 2)> in
the following:

    tie my $n, 'Tie::Scalar::Yours', foo => 1, baz => 2;

The return value is not checked, so you don't need to C<return $self>.

=cut

sub BUILD { }

=head2 UNTIE

This is called when a caller explicitly C<untie>s the scalar. By default it
does nothing. If the user explicitly C<untie>s the scalar, C<DESTROY> will be
called immediately after this (unless someone else is holding onto the
reference). This means you should put all of your cleanup code into C<DESTROY>.

=cut

sub UNTIE { }

=head2 DESTROY

This is called when your variable goes out of scope. By default it will
just destroy the hash.

=cut

sub DESTROY { my $self = shift; undef %$self }

=head1 SEE ALSO

L<Tie::Scalar::AsArray>, L<Tie::Scalar>, L<Tie::StdScalar>

=head1 AUTHOR

Shawn M Moore, C<< <sartak at gmail.com> >>

=head1 BUGS

No known bugs.

Please report any bugs through RT: email 
C<bug-tie-scalar-ashash at rt.cpan.org>, or browse to
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Tie-Scalar-AsHash>.

=head1 SUPPORT

You can find this documentation for this module with the perldoc command.

    perldoc Tie::Scalar::AsHash

You can also look for information at:

=over 4

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Tie-Scalar-AsHash>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Tie-Scalar-AsHash>

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Tie-Scalar-AsHash>

=item * Search CPAN

L<http://search.cpan.org/dist/Tie-Scalar-AsHash>

=back

=head1 COPYRIGHT & LICENSE

Copyright 2007 Shawn M Moore.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1;

