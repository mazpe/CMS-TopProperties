package CMS::Form::Admin::Form;
use HTML::FormHandler::Moose;
use HTML::FormHandler::Types ( 'NoSpaces', 'WordChars' );
extends 'HTML::FormHandler::Model::DBIC';
use Data::Dumper;

with 'HTML::FormHandler::Render::Simple'; # if you want to render the form

has '+item_class'   => ( default => 'Form' );
has '+enctype'      => ( default => 'multipart/form-data');

has_field 'name'        => (
    type                => 'Text',
    label               => 'Name',
    required            => 1,
    required_message    => 'You must enter a name',
);
has_field 'file'        => (
    type                => 'Upload',
    max_size            => '2000000',
    required            => 1,
    required_message    => 'You must enter a subject',
);
has_field 'client_id'      => (
    type                => 'Hidden',
);
has_field 'filename'      => (
    type                => 'Hidden',
);



has_field 'submit' => ( type => 'Submit', value => 'Submit' );

no HTML::FormHandler::Moose;
1;

