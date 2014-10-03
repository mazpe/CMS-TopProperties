package CMS::Controller::Site;
use Moose;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

=head1 NAME

CMS::Controller::Site - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->stash(
        is_home     => 1,
        template    => 'site/home.tt2',
    )
}

sub about_us : Local {
    my ( $self, $c ) = @_;

    $c->stash(
        is_about_us     => 1,
        template    => 'site/about_us.tt2',
    )
}

sub services : Local {
    my ( $self, $c ) = @_;

    $c->stash(
        is_services     => 1,
        template    => 'site/services.tt2',
    )
}

sub contact_us : Local {
    my ( $self, $c ) = @_;

    $c->stash(
        is_contact_us     => 1,
        template    => 'site/contact_us.tt2',
    )
}



=head1 AUTHOR

gbrnd

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
