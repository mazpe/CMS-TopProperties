package CMS::Form::Admin::Client;
use HTML::FormHandler::Moose;
use HTML::FormHandler::Types ( 'NoSpaces', 'WordChars' );
extends 'HTML::FormHandler::Model::DBIC';
use Data::Dumper;

with 'HTML::FormHandler::Render::Simple'; # if you want to render the form

has '+item_class' => ( default => 'Client' );

has_field 'name'        => (
    type                => 'Text',
    label               => 'Name',
    required            => 1,
    required_message    => 'You must enter a client name',
);
has_field 'contact'        => (
    type                => 'Text',
    label               => 'Contact',
    required            => 1,
    required_message    => 'You must enter a contact name',
);
has_field 'address_1'        => (
    type                => 'Text',
    label               => 'Address 1',
    required            => 1,
    required_message    => 'You must enter an address',
);
has_field 'address_2'        => (
    type                => 'Text',
    label               => 'Address 2',
);
has_field 'city'        => (
    type                => 'Text',
    label               => 'City',
);
has_field 'state'        => (
    type                => 'Text',
    label               => 'State',
);
has_field 'zip_code'        => (
    type                => 'Text',
    label               => 'Zip Code',
);
has_field 'telephone'        => (
    type                => 'Text',
    label               => 'Telephone',
);
has_field 'fax'        => (
    type                => 'Text',
    label               => 'Fax',
);
has_field 'email'        => (
    type                => 'Text',
    label               => 'Email',
);





has_field 'submit' => ( type => 'Submit', value => 'Submit' );

no HTML::FormHandler::Moose;
1;

