package CMS::Schema::Result::User;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "TimeStamp", "EncodedColumn", "Core");
__PACKAGE__->table("user");
__PACKAGE__->add_columns(
  "id",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 11 },
  "type",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 128,
  },
  "client_id",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 11 },
  "company",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 64,
  },
  "contact",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 64,
  },
  "username",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 128,
  },
  "password",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 128,
  },
  "created",
  {
    data_type => "DATETIME",
    default_value => undef,
    is_nullable => 0,
    size => 19,
  },
  "updated",
  {
    data_type => "DATETIME",
    default_value => undef,
    is_nullable => 0,
    size => 19,
  },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->belongs_to(
  "client_id",
  "CMS::Schema::Result::Client",
  { id => "client_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2010-12-08 17:03:26
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:0H3KJHK4YwUDisXgQvsLkw

# Have the 'password' column use a SHA-1 hash and 10-character salt
# with hex encoding; Generate the 'check_password" method
__PACKAGE__->add_columns(
    'password' => {
        data_type           => "TEXT",
        size                => undef,
        encode_column       => 1,
        encode_class        => 'Digest',
        encode_args         => {salt_length => 10},
        encode_check_method => 'check_password',
    },
);
__PACKAGE__->add_columns(
    "created",
    { data_type => 'datetime', set_on_create => 1 },
    "updated",
    { data_type => 'datetime', set_on_create => 1, set_on_update => 1 },
);
__PACKAGE__->many_to_many(roles => 'user_roles', 'role');

# You can replace this text with custom content, and it will be preserved on regeneration
1;
