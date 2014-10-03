package CMS::Controller::Admin::Clients::BoardMembers;
use Moose;
use namespace::autoclean;
use CMS::Form::Admin::BoardMember;

BEGIN {extends 'Catalyst::Controller'; }

has 'boardmember_form' => (
    isa => 'CMS::Form::Admin::BoardMember',
    is => 'ro',
    lazy => 1,
    default => sub { CMS::Form::Admin::BoardMember->new },
);



=head1 NAME

CMS::Controller::Admin::Clients::BoardMembers - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched CMS::Controller::Admin::Clients::BoardMembers in Admin::Clients::BoardMembers.');
}

sub boardmembers :Chained('/admin/clients/load') :PathPart('boardmembers') :Args(0) {
    my ( $self, $c ) = @_;
    my $client_id;
    my $boardmembers;

    $client_id = $c->stash->{client_id};

    $boardmembers = [$c->model('CMSDB::BoardMember')->search( {
        client_id   => $client_id,
    } )];

    $c->stash(
        template        => 'admin/clients/boardmembers.tt2',
        client          => $c->stash->{client},
        boardmembers   => $boardmembers,
    );

}

sub boardmember_base :Chained('/admin/clients/load') :PathPart('boardmembers') :CaptureArgs(0) {
    my ( $self, $c ) = @_;

}

sub boardmember_load :Chained('boardmember_base') :PathPart('') :CaptureArgs(1) {
    my ( $self, $c, $id ) = @_;
    my $boardmember;

    if($id) {

        $c->stash->{boardmember_id} = $id;
        $boardmember    = $c->model('CMSDB::BoardMember')->find($id);

    } else {

        $c->response->status(404);
        $c->detach;

    }

    if ($boardmember) {

        $c->stash->{'boardmember'} = $boardmember;

    } else {

        $c->response->status(404);
        $c->detach;

    }

    return;
}

sub boardmember_create :Chained('/admin/clients/load') :PathPart('create') :Args(0) {
    my ( $self, $c, $boardmember_id ) = @_;
    my $row;
    my $form;
    my $client_id;

    $client_id = $c->stash->{client_id};

    # Set template and form
    $c->stash(
        template    => 'admin/clients/boardmember.tt2',
        form        => $self->boardmember_form,
    );

    $c->log->debug("stuff ". $c->stash->{client_id});

    $c->req->parameters->{client_id} = $c->stash->{client_id};

    return unless $self->boardmember_form->process(
        item_id => $boardmember_id,
        params      => $c->req->parameters,
        schema      => $c->model('CMSDB')->schema
    );

    $c->res->redirect( $c->uri_for($self->action_for('boardmembers'),
            [$client_id])
     );

}

sub boardmember_delete :Chained('boardmember_load') :PathPart('delete') :Args(0) {
    my ( $self, $c ) = @_;
    my $boardmember;
    my $client_id;

    $boardmember = $c->stash->{boardmember};

    $client_id = $c->stash->{client_id};

    if ($boardmember) {

        $boardmember->delete;

        $c->res->redirect( $c->uri_for($self->action_for('boardmembers'),
            [$client_id])
        );


    } else {

        $c->response->status(404);
        $c->detach;

    }

    return;
}


sub boardmember_edit :Chained('boardmember_load') :PathPart('edit') :Args(0) {
    my ( $self, $c ) = @_;
    my $boardmember_id;
    my $client_id;
    my $row;
    my $form;

    $client_id = $c->stash->{client_id};
    $boardmember_id = $c->stash->{boardmember_id};

    $row = $c->model('CMSDB::BoardMember')->find($boardmember_id);

    $c->stash(
        template    => 'admin/clients/boardmember.tt2',
        form        => $self->boardmember_form,
    );

    # Process form
    $form = $self->boardmember_form->process (
        item        => $row,
        params      => $c->req->params,
    );

    if ($form) {
        $c->res->redirect( $c->uri_for($self->action_for('boardmembers'),
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
