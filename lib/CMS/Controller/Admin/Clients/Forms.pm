package CMS::Controller::Admin::Clients::Forms;
use Moose;
use namespace::autoclean;
use CMS::Form::Admin::Form;

BEGIN {extends 'Catalyst::Controller'; }

has 'form_form' => (
    isa => 'CMS::Form::Admin::Form',
    is => 'ro',
    lazy => 1,
    default => sub { CMS::Form::Admin::Form->new },
);



=head1 NAME

CMS::Controller::Admin::Clients::Forms - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched CMS::Controller::Admin::Clients::Forms in Admin::Clients::Forms.');
}

sub forms :Chained('/admin/clients/load') :PathPart('forms') :Args(0) {
    my ( $self, $c ) = @_;
    my $client_id;
    my $forms;

    $client_id = $c->stash->{client_id};

    $forms = [$c->model('CMSDB::Form')->search( {
        client_id   => $client_id,
    } )];

    $c->stash(
        template        => 'admin/clients/forms.tt2',
        client          => $c->stash->{client},
        forms   => $forms,
    );

}

sub base :Chained('/admin/clients/load') :PathPart('forms') :CaptureArgs(0) {
    my ( $self, $c ) = @_;

}

sub load :Chained('base') :PathPart('') :CaptureArgs(1) {
    my ( $self, $c, $id ) = @_;
    my $form;

    if($id) {

        $c->stash->{form_id} = $id;
        $form    = $c->model('CMSDB::Form')->find($id);

    } else {

        $c->response->status(404);
        $c->detach;

    }

    if ($form) {

        $c->stash->{'form'} = $form;

    } else {

        $c->response->status(404);
        $c->detach;

    }

    return;
}

sub create :Chained('/admin/clients/load') :PathPart('form_create') :Args(0) {
    my ( $self, $c, $form_id ) = @_;
    my $row;
    my $form;
    my $client_id;
    my $file;
    my $cmd;
    my $file_fullpath;
    my $filename;

    $file_fullpath
        = '/mnt/www/web92/CMS/root/forms';

    $client_id = $c->stash->{client_id};

    # Set template and form
    $c->stash(
        template    => 'admin/clients/form.tt2',
        form        => $self->form_form,
    );
    
    if ($c->req->param('submit')) {

        $file = $c->req->upload('file');
        $c->req->parameters->{file} = $file; 

        if ($file) {
            $filename = $client_id.'-'.$file->basename;
            $c->req->parameters->{filename} = $filename;
            $cmd = '/bin/mv '.$file->tempname.' '.$file_fullpath. '/'.$filename;
            system($cmd);
            $c->log->debug("cmd: ". $cmd);
        }

    }

    $c->req->parameters->{client_id} = $c->stash->{client_id};

    return unless $self->form_form->process(
        item_id => $form_id,
        params      => $c->req->parameters,
        schema      => $c->model('CMSDB')->schema
    );

    $c->res->redirect( $c->uri_for($self->action_for('forms'),
            [$client_id])
     );

}

sub delete :Chained('load') :PathPart('form_delete') :Args(0) {
    my ( $self, $c ) = @_;
    my $form;
    my $client_id;
    my $file_fullpath;
    my $filename;
    my $cmd;

    $file_fullpath
        = '/mnt/www/web92/CMS/root/forms';

    $form = $c->stash->{form};

    $client_id = $c->stash->{client_id};

    if ($form) {

        $filename = $form->filename;

        $cmd = '/bin/rm -Rf '. $file_fullpath. '/'. $filename;        
        $c->log->debug("cmd: ". $cmd);

        system($cmd);

        $form->delete;

        $c->res->redirect( $c->uri_for($self->action_for('forms'),
            [$client_id])
        );


    } else {

        $c->response->status(404);
        $c->detach;

    }

    return;
}


sub view :Chained('load') :PathPart('form_view') :Args(0) {
    my ( $self, $c ) = @_;
    my $form_id;
    my $client_id;
    my $row;
    my $form;

    $client_id = $c->stash->{client_id};
    $form_id = $c->stash->{form_id};

    $row = $c->model('CMSDB::Form')->find($form_id);

    $c->stash(
        template    => 'admin/clients/form.tt2',
        form        => $self->form_form,
    );

    # Process form
    $form = $self->form_form->process (
        item        => $row,
        params      => $c->req->params,
    );

    if ($form) {
        $c->res->redirect( $c->uri_for($self->action_for('forms'),
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
