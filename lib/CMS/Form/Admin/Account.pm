package CMS::Form::Admin::Account;
use HTML::FormHandler::Moose;
use HTML::FormHandler::Types ( 'NoSpaces', 'WordChars' );
extends 'HTML::FormHandler::Model::DBIC';
use Data::Dumper;

with 'HTML::FormHandler::Render::Simple'; # if you want to render the form

has '+item_class' => ( default => 'User' );

has_field 'username'  => (
    type                => 'Text',
    label               => 'Username',
    required            => 1,
    required_message    => 'You must enter a username',
);
has_field 'type'      => (
    type                => 'Select',
    label               => 'Type',
    options             => [{ value => 'Tenant', label => 'Tenant'},
                            { value => 'Board', label => 'Board'}],
);
has_field 'password'  => (
    type                => 'Password',
    label               => 'Password',
    required            => 1,
    required_message    => 'You must enter a password',
    apply               => [ NoSpaces, WordChars ],
);
has_field 'password_conf'   => (
    type                => 'PasswordConf',
    label               => 'Confirm',
    password_field      => 'password',
);
has_field 'client_id'      => (
    type                => 'Hidden',
);


has_field 'submit' => ( type => 'Submit', value => 'Submit' );

no HTML::FormHandler::Moose;
1;

