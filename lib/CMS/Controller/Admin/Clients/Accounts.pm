package CMS::Controller::Admin::Clients::Accounts;
use Moose;
use namespace::autoclean;

use CMS::Form::Admin::Account;

BEGIN {extends 'Catalyst::Controller'; }

has 'account_form' => (
    isa => 'CMS::Form::Admin::Account',
    is => 'ro',
    lazy => 1,
    default => sub { CMS::Form::Admin::Account->new },
);

=head1 NAME

CMS::Controller::Admin::Clients::Accounts - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched CMS::Controller::Admin::Clients::Accounts in Admin::Clients::Accounts.');
}

sub accounts :Chained('/admin/clients/load') :PathPart('accounts') :Args(0) {
    my ( $self, $c ) = @_;
    my $client_id;
    my $accounts;

    $client_id = $c->stash->{client_id};

    $accounts = [$c->model('CMSDB::User')->search( {
        client_id   => $client_id,
    } )];

    $c->stash(
        template        => 'admin/clients/accounts.tt2',
        client          => $c->stash->{client},
        accounts   => $accounts,
    );

}

sub account_base :Chained('/admin/clients/load') :PathPart('accounts') :CaptureArgs(0) {
    my ( $self, $c ) = @_;

}

sub account_load :Chained('account_base') :PathPart('') :CaptureArgs(1) {
    my ( $self, $c, $id ) = @_;
    my $account;

    if($id) {

        $c->stash->{account_id} = $id;
        $account    = $c->model('CMSDB::User')->find($id);

    } else {

        $c->response->status(404);
        $c->detach;

    }

    if ($account) {

        $c->stash->{'account'} = $account;

    } else {

        $c->response->status(404);
        $c->detach;

    }

    return;
}

sub account_create :Chained('/admin/clients/load') :PathPart('account_create') :Args(0) {
    my ( $self, $c, $account_id ) = @_;
    my $row;
    my $form;
    my $client_id;

    $client_id = $c->stash->{client_id};

    # Set template and form
    $c->stash(
        template    => 'admin/clients/account.tt2',
        form        => $self->account_form,
    );

    $c->log->debug("stuff ". $c->stash->{client_id});

    $c->req->parameters->{client_id} = $c->stash->{client_id};

    return unless $self->account_form->process(
        item_id => $account_id,
        params      => $c->req->parameters,
        schema      => $c->model('CMSDB')->schema
    );

    $c->res->redirect( $c->uri_for($self->action_for('accounts'),
            [$client_id])
     );

}

sub account_delete :Chained('account_load') :PathPart('delete') :Args(0) {
    my ( $self, $c ) = @_;
    my $account;
    my $client_id;

    $account = $c->stash->{account};

    $client_id = $c->stash->{client_id};

    if ($account) {

        $account->delete;

        $c->res->redirect( $c->uri_for($self->action_for('accounts'),
            [$client_id])
        );


    } else {

        $c->response->status(404);
        $c->detach;

    }

    return;
}

sub account_edit :Chained('account_load') :PathPart('edit') :Args(0) {
    my ( $self, $c ) = @_;
    my $account_id;
    my $client_id;
    my $row;
    my $form;

    $client_id = $c->stash->{client_id};
    $account_id = $c->stash->{account_id};

    $row = $c->model('CMSDB::User')->find($account_id);

    $c->stash(
        template    => 'admin/clients/account.tt2',
        form        => $self->account_form,
    );

    # Process form
    $form = $self->account_form->process (
        item        => $row,
        params      => $c->req->params,
    );

    if ($form) {
        $c->res->redirect( $c->uri_for($self->action_for('accounts'),
            [$client_id])
        );
    }
}

=head1 AUTHOR

gbrnd

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
