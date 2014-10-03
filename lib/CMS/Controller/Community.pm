package CMS::Controller::Community;
use Moose;
use namespace::autoclean;

use CMS::Form::Community::Complaint;

BEGIN {extends 'Catalyst::Controller'; }

has 'complaint_form' => (
    isa => 'CMS::Form::Community::Complaint',
    is => 'ro',
    lazy => 1,
    default => sub { CMS::Form::Community::Complaint->new },
);

=head1 NAME

CMS::Controller::Community - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched CMS::Controller::Community in Community.');
}

sub finances : Local {
    my ( $self, $c ) = @_;
    my $client_id;
    my $report_pnl;

    $client_id = $c->user->get('client_id')->id;

    $report_pnl = [$c->model('CMSDB::FinancePnl')->search(
        { client_id   => $client_id },
        { group_by => [qw/month year  /] },

     )];

    $c->stash(
        is_finances     => 1,
        template        => 'community/finances.tt2',
        client          => $c->stash->{client},
        report_pnl      => $report_pnl,
    );

}

sub report_pnl : Local {
    my ( $self, $c ) = @_;
    my $client_id;
    my $row;
    my $finance;

    $client_id = $c->user->get('client_id')->id;

    $row = [$c->model('CMSDB::FinancePnl')->search(
        {
            client_id => $client_id,
            month       => $c->req->params->{'month'},
            year        => $c->req->params->{'year'},
         }
    )];

    $c->stash(
        finances        => $row,
        template        => 'community/report_pnl.tt2',
    );


}

sub complaints : Local {
    my ( $self, $c ) = @_;
    my $client_id;
    my $tenant;
    my $complaint_id;

    $client_id = $c->user->get('client_id')->id;
    #$tenant = $c->user->get('contact');

    $c->stash(
        is_complaints     => 1,
        template        => 'community/complaints.tt2',
        form        => $self->complaint_form,
    );

    $c->req->parameters->{client_id} = $client_id;
    #$c->req->parameters->{tenant} = $tenant;

    return unless $self->complaint_form->process(
        item_id => $complaint_id,
        params      => $c->req->parameters,
        schema      => $c->model('CMSDB')->schema
    );

    $c->res->redirect( $c->uri_for($self->action_for('complaints_sucess')) );

}

sub complaints_sucess : Local {
    my ( $self, $c ) = @_;

    $c->stash( template => 'community/complaints_sucess.tt2' );

}

sub boardmembers : Local {
    my ( $self, $c ) = @_;
    my $boardmembers;

    $boardmembers = [$c->model('CMSDB::BoardMember')->search( {
        client_id   => $c->user->get('client_id')->id,
    } )];

    $c->stash(
        is_boardmembers     => 1,
        boardmembers        => $boardmembers,
        template        => 'community/boardmembers.tt2',
    )

}

sub forms : Local {
    my ( $self, $c ) = @_;
    my $forms;
    
    $forms = [$c->model('CMSDB::Form')->search( {
        client_id   => $c->user->get('client_id')->id,
    } )];


    $c->stash(
        is_forms     => 1,
        forms       => $forms,
        template        => 'community/forms.tt2',
    )

}


=head2 auto

Check if there is a user and, if not, forward to login page

=cut

# Note that 'auto' runs after 'begin' but before your actions and that
# 'auto's "chain" (all from application path to most specific class are run)
# See the 'Actions' section of 'Catalyst::Manual::Intro' for more info.
sub auto :Private {
    my ($self, $c) = @_;

    # Allow unauthenticated users to reach the login page.  This
    # allows unauthenticated users to reach any action in the Login
    # controller.  To lock it down to a single action, we could use:
    #   if ($c->action eq $c->controller('Login')->action_for('index'))
    # to only allow unauthenticated access to the 'index' action we
    # added above.
    if ($c->controller eq $c->controller('Login')) {
        return 1;
    }

    # If a user doesn't exist, force login
    if (!$c->user_exists) {
        # Dump a log message to the development server debug output
        $c->log->debug('***Root::auto User not found, forwarding to /login');
        # Redirect the user to the login page
        $c->response->redirect($c->uri_for('/login'));
        # Return 0 to cancel 'post-auto' processing and prevent use of application
        return 0;
    }

    # User found, so return 1 to continue with processing after this 'auto'
    return 1;
}

=head1 AUTHOR

gbrnd

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
