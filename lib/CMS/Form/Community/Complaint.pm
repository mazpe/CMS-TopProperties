package CMS::Form::Community::Complaint;
use HTML::FormHandler::Moose;
use HTML::FormHandler::Types ( 'NoSpaces', 'WordChars' );
extends 'HTML::FormHandler::Model::DBIC';
use Data::Dumper;

with 'HTML::FormHandler::Render::Simple'; # if you want to render the form

has '+item_class' => ( default => 'Complaint' );

has_field 'tenant'        => (
    type                => 'Text',
    label               => 'Tenant',
    required            => 1,
    required_message    => 'You must enter a tenant',
);
has_field 'subject'        => (
    type                => 'Text',
    label               => 'Subject',
    required            => 1,
    required_message    => 'You must enter a subject',
);
has_field 'description'  => (
    type                => 'TextArea',
    cols                => '25',
    rows                => '5',
    label               => 'Description',
    required            => 1,
    required_message    => 'You must enter a description',
);
has_field 'client_id'      => (
    type                => 'Hidden',
);


has_field 'submit' => ( type => 'Submit', value => 'Submit' );

no HTML::FormHandler::Moose;
1;

