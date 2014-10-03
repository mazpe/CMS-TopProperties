package CMS::Controller::Admin::Clients::Finances;
use Moose;
use namespace::autoclean;
use CMS::Form::Admin::Finance;
use Text::CSV;
use Encode qw(encode decode);

BEGIN {extends 'Catalyst::Controller'; }

has 'form_finance' => (
    isa => 'CMS::Form::Admin::Finance',
    is => 'ro',
    lazy => 1,
    default => sub { CMS::Form::Admin::Finance->new },
);



=head1 NAME

CMS::Controller::Admin::Clients::Finances - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    $c->response->body('Matched CMS::Controller::Admin::Clients::Finances in Admin::Clients::Finances.');
}

sub finances :Chained('/admin/clients/load') :PathPart('finances') :Args(0) {
    my ( $self, $c ) = @_;
    my $client_id;
    my $report_pnl;

    $client_id = $c->stash->{client_id};

    $report_pnl = [$c->model('CMSDB::FinancePnl')->search( 
        { client_id   => $client_id },
        { group_by => [qw/month year  /] },

     )];

    $c->stash(
        template        => 'admin/clients/finances.tt2',
        client          => $c->stash->{client},
        report_pnl      => $report_pnl,
    );

}

sub base :Chained('/admin/clients/load') :PathPart('finances') :CaptureArgs(0) {
    my ( $self, $c ) = @_;

}

sub load :Chained('base') :PathPart('') :CaptureArgs(1) {
    my ( $self, $c, $id ) = @_;
    my $finance;

    if($id) {

        $c->stash->{finance_id} = $id;
        $finance    = $c->model('CMSDB::Finance')->find($id);

    } else {

        $c->response->status(404);
        $c->detach;

    }

    if ($finance) {

        $c->stash->{'finance'} = $finance;

    } else {

        $c->response->status(404);
        $c->detach;

    }

    return;
}

sub create :Chained('/admin/clients/load') :PathPart('finance_create') :Args(0) {
    my ( $self, $c, $finance_id ) = @_;
    my $row;
    my $finance;
    my $client_id;
    my $file;
    my $cmd;
    my $file_path;
    my $file_fullpath;
    my $csv;
    my $filename;

    $file_path
        = '/mnt/www/web92/CMS/root/finances';

    $client_id = $c->stash->{client_id};

    # Set template and finance
    $c->stash(
        template    => 'admin/clients/finance_create.tt2',
        form        => $self->form_finance,
    );
    
    if ($c->req->param('submit')) {

        $file = $c->req->upload('file');
        $c->req->parameters->{file} = $file; 

        if ($file) {
            $filename = $client_id.'-'.$file->basename;
            $file_fullpath = $file_path.'/'.$filename;
            $c->req->parameters->{filename} = $filename;
            $cmd = '/bin/mv '.$file->tempname.' '.$file_fullpath;
            system($cmd);
            $c->log->debug("cmd: ". $cmd);

            # LOAD CSV
            $csv = Text::CSV->new();

            open (CSV, "<:encoding(UTF-8)", $file_fullpath) or die $!;
            
            while (<CSV>) {
                if ($csv->parse($_)) {

                    my @columns = $csv->fields();
                    $columns[0] =~ s/\\xB7/./;
                    my @column0 = split(/\./, $columns[0]);
                    $c->log->debug($columns[0] - $column0[0]);
                    my $account = $column0[0]; 
                    $account =~ s/[^\d]+//g; 

                    my %fields;
                    %fields = ( 
                        account     => $account,
                        description => $columns[0],
                        amount      => $columns[1],
                        client_id   => $client_id,
                        month       => $c->req->params->{'month'},
                        year        => $c->req->params->{'year'},
                    );

                    #if ($account) {
                        my $row = $c->model('CMSDB::FinancePnl')->new(\%fields);
                        $row->insert; 

                   # }

                } else {

                    my $err = $csv->error_input;
                    print "Failed to parse line: $err";
    
                }
            }
            close CSV;
        }
    }

    $c->req->parameters->{client_id} = $c->stash->{client_id};

    return unless $self->form_finance->process(
        item_id => $finance_id,
        params      => $c->req->parameters,
        schema      => $c->model('CMSDB')->schema
    );

    $c->res->redirect( $c->uri_for($self->action_for('finances'),
            [$client_id])
     );

}

sub delete :Chained('load') :PathPart('finance_delete') :Args(0) {
    my ( $self, $c ) = @_;
    my $finance;
    my $client_id;
    my $file_fullpath;
    my $filename;
    my $cmd;

    $file_fullpath
        = '/mnt/www/web92/CMS/root/finances';

    $finance = $c->stash->{finance};

    $client_id = $c->stash->{client_id};

    if ($finance) {

        $filename = $finance->filename;

        $cmd = '/bin/rm -Rf '. $file_fullpath. '/'. $filename;        
        $c->log->debug("cmd: ". $cmd);

        system($cmd);

        $finance->delete;

        $c->res->redirect( $c->uri_for($self->action_for('finances'),
            [$client_id])
        );


    } else {

        $c->response->status(404);
        $c->detach;

    }

    return;
}


sub report_pnl :Chained('/admin/clients/load') :PathPart('report_pnl') :Args(0) {
    my ( $self, $c ) = @_;
    my $client_id;
    my $row;
    my $finance;

    $client_id = $c->stash->{client_id};

    $row = [$c->model('CMSDB::FinancePnl')->search( 
        { 
            client_id => $client_id,
            month       => $c->req->params->{'month'},
            year        => $c->req->params->{'year'},
         } 
    )];

    $c->stash(
        finances        => $row,
        template        => 'admin/clients/finance.tt2',
    );

}


sub report_pnl_delete :Chained('/admin/clients/load') :PathPart('report_pnl_delete') :Args(0) {
    my ( $self, $c ) = @_;
    my $client_id;
    my $row;
    my $finance;

    $client_id = $c->stash->{client_id};

    $row = $c->model('CMSDB::FinancePnl')->search(
        {
            client_id => $client_id,
            month       => $c->req->params->{'month'},
            year        => $c->req->params->{'year'},
         }
    )->delete;

    $c->res->redirect( $c->uri_for($self->action_for('finances'),
            [$client_id])
     );


}



=head1 AUTHOR

gbrnd

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
