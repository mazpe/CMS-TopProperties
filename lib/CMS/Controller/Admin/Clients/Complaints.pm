package CMS::Controller::Admin::Clients::Complaints;
use Moose;
use namespace::autoclean;
use CMS::Form::Admin::Complaint;

BEGIN {extends 'Catalyst::Controller'; }

has 'complaint_form' => (
    isa => 'CMS::Form::Admin::Complaint',
    is => 'ro',
    lazy => 1,
    default => sub { CMS::Form::Admin::Complaint->new },
);



=head1 NAME

CMS::Controller::Admin::Clients::Complaints - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched CMS::Controller::Admin::Clients::Complaints in Admin::Clients::Complaints.');
}

sub complaints :Chained('/admin/clients/load') :PathPart('complaints') :Args(0) {
    my ( $self, $c ) = @_;
    my $client_id;
    my $complaints;

    $client_id = $c->stash->{client_id};

    $complaints = [$c->model('CMSDB::Complaint')->search( {
        client_id   => $client_id,
    } )];

    $c->stash(
        template        => 'admin/clients/complaints.tt2',
        client          => $c->stash->{client},
        complaints   => $complaints,
    );

}

sub complaint_base :Chained('/admin/clients/load') :PathPart('complaints') :CaptureArgs(0) {
    my ( $self, $c ) = @_;

}


sub complaint_load :Chained('complaint_base') :PathPart('') :CaptureArgs(1) {
    my ( $self, $c, $id ) = @_;
    my $complaint;

    if($id) {

        $c->stash->{complaint_id} = $id;
        $complaint    = $c->model('CMSDB::Complaint')->find($id);

    } else {

        $c->response->status(404);
        $c->detach;

    }

    if ($complaint) {

        $c->stash->{'complaint'} = $complaint;

    } else {

        $c->response->status(404);
        $c->detach;

    }

    return;
}

sub complaint_create :Chained('/admin/clients/load') :PathPart('complaint_create') :Args(0) {
    my ( $self, $c, $complaint_id ) = @_;
    my $row;
    my $form;
    my $client_id;

    $client_id = $c->stash->{client_id};

    # Set template and form
    $c->stash(
        template    => 'admin/clients/complaint.tt2',
        form        => $self->complaint_form,
    );

    $c->log->debug("stuff ". $c->stash->{client_id});

    $c->req->parameters->{client_id} = $c->stash->{client_id};

    return unless $self->complaint_form->process(
        item_id => $complaint_id,
        params      => $c->req->parameters,
        schema      => $c->model('CMSDB')->schema
    );

    $c->res->redirect( $c->uri_for($self->action_for('complaints'),
            [$client_id])
     );

}

sub complaint_delete :Chained('complaint_load') :PathPart('delete') :Args(0) {
    my ( $self, $c ) = @_;
    my $complaint;
    my $client_id;

    $complaint = $c->stash->{complaint};
    
    $client_id = $c->stash->{client_id};

    if ($complaint) {

        $complaint->delete;

        $c->res->redirect( $c->uri_for($self->action_for('complaints'),
            [$client_id])
        );


    } else {

        $c->response->status(404);
        $c->detach;

    }

    return;
}


sub complaint_edit :Chained('complaint_load') :PathPart('edit') :Args(0) {
    my ( $self, $c ) = @_;
    my $complaint_id;
    my $client_id;
    my $row;
    my $form;

    $client_id = $c->stash->{client_id};
    $complaint_id = $c->stash->{complaint_id};

    $row = $c->model('CMSDB::Complaint')->find($complaint_id);

    $c->stash(
        template    => 'admin/clients/complaint.tt2',
        form        => $self->complaint_form,
    );

    # Process form
    $form = $self->complaint_form->process (
        item        => $row,
        params      => $c->req->params,
    );

    if ($form) {
        $c->res->redirect( $c->uri_for($self->action_for('complaints'), 
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
