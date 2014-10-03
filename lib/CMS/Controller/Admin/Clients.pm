package CMS::Controller::Admin::Clients;
use Moose;
use namespace::autoclean;
use CMS::Form::Admin::Client;

BEGIN {extends 'Catalyst::Controller'; }

has 'client_form' => (
    isa => 'CMS::Form::Admin::Client',
    is => 'ro',
    lazy => 1,
    default => sub { CMS::Form::Admin::Client->new },
);

=head1 NAME

CMS::Controller::Admin::Clients - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->stash(
        clients         => [$c->model('CMSDB::Client')->all],
        template        => 'admin/clients/list.tt2',
    );
    
}

sub base :Chained('/') :PathPart('admin/clients') :CaptureArgs(0) {
    my ( $self, $c ) = @_;

}

sub load :Chained('base') :PathPart('') :CaptureArgs(1) {
    my ( $self, $c, $id ) = @_;
    my $client;

    if($id) {

        $c->stash->{client_id} = $id;
        $client    = $c->model('CMSDB::Client')->find($id);

    } else {

        $c->response->status(404);
        $c->detach;

    }

    if ($client) {

        $c->stash->{'client'} = $client;

    } else {

        $c->response->status(404);
        $c->detach;

    }

    return;
}


sub list : Local {
    my ( $self, $c ) = @_;

    $c->stash(clients => [$c->model('CMSDB::Client')->all]);

    $c->stash(template => 'admin/clients/list.tt2');

}

sub create : Local {
    my ( $self, $c, $client_id ) = @_;
    my $row;
    my $form;

    # Set template and form
    $c->stash(
        template    => 'admin/clients/client.tt2',
        form        => $self->client_form,
    );

    return unless $self->client_form->process( 
        item_id => $client_id,
        params      => $c->req->parameters,
        schema      => $c->model('CMSDB')->schema
    );

    $c->res->redirect($c->uri_for('list'));

}

sub edit :Chained('load') :PathPart('edit') :Args(0) {
    my ( $self, $c ) = @_;
    my $client_id;
    my $row;
    my $form;

    $client_id = $c->stash->{client_id};

    $row = $c->model('CMSDB::Client')->find($client_id);

    $c->stash(
        is_edit     => 1,
        template    => 'admin/clients/client.tt2',
        form        => $self->client_form,
    );

    # Process form
    $form = $self->client_form->process (
        item        => $row,
        params      => $c->req->params,
    );

    if ($form) {
        $c->res->redirect( $c->uri_for($self->action_for('index')) );
    }
}

sub delete :Chained('load') :PathPart('delete') :Args(0) {
    #NOTE: fix to delete forms based on the database entries
    #and not just the filesystem

    my ( $self, $c ) = @_;
    my $full_path;
    my $cmd;
    my $client = $c->stash->{client};
    my $client_id = $c->stash->{client_id};

    $full_path = '/mnt/www/web92/CMS/root/forms';


    if ($client) {

        $client->delete;

        $cmd = '/bin/rm -Rf '. $full_path. '/'. $client_id .'*';
        system($cmd);


        $c->response->redirect(
            $c->uri_for( $self->action_for('index')) . '/' );

    } else {

        $c->response->status(404);
        $c->detach;

    }

    return;
}

sub auto :Private {
    my ($self, $c) = @_;

#    $c->stash( wrapper_admin => 1 );

}

=head1 AUTHOR

gbrnd

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
