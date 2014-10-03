package CMS::Model::CMSDB;

use strict;
use base 'Catalyst::Model::DBIC::Schema';

__PACKAGE__->config(
    schema_class => 'CMS::Schema',
    connect_info => [
        'dbi:mysql:database',
        'username',
        'password',
        { AutoCommit => 1 },
        
    ],
);

=head1 NAME

CMS::Model::CMSDB - Catalyst DBIC Schema Model
=head1 SYNOPSIS

See L<CMS>

=head1 DESCRIPTION

L<Catalyst::Model::DBIC::Schema> Model using schema L<CMS::Schema>

=head1 AUTHOR

gbrnd

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
