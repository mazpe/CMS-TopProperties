package CMS::Form::Admin::BoardMember;
use HTML::FormHandler::Moose;
use HTML::FormHandler::Types ( 'NoSpaces', 'WordChars' );
extends 'HTML::FormHandler::Model::DBIC';
use Data::Dumper;

with 'HTML::FormHandler::Render::Simple'; # if you want to render the form

has '+item_class' => ( default => 'BoardMember' );

has_field 'name'        => (
    type                => 'Text',
    label               => 'Name',
    required            => 1,
    required_message    => 'You must enter a client name',
);
has_field 'position'        => (
    type                => 'Text',
    label               => 'Position',
);
has_field 'telephone'        => (
    type                => 'Text',
    label               => 'Telephone',
);
has_field 'email'        => (
    type                => 'Text',
    label               => 'Email',
);
has_field 'client_id'      => (
    type                => 'Hidden',
);


has_field 'submit' => ( type => 'Submit', value => 'Submit' );

no HTML::FormHandler::Moose;
1;

