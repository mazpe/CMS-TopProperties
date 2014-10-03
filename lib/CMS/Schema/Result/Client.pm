package CMS::Schema::Result::Client;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "TimeStamp", "EncodedColumn", "Core");
__PACKAGE__->table("client");
__PACKAGE__->add_columns(
  "id",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 11 },
  "name",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 128,
  },
  "contact",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 128,
  },
  "address_1",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 64,
  },
  "address_2",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 64,
  },
  "city",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 64,
  },
  "state",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 32,
  },
  "zip_code",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 10,
  },
  "telephone",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 16,
  },
  "fax",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 16,
  },
  "email",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 64,
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
__PACKAGE__->has_many(
  "board_members",
  "CMS::Schema::Result::BoardMember",
  { "foreign.client_id" => "self.id" },
);
__PACKAGE__->has_many(
  "complaints",
  "CMS::Schema::Result::Complaint",
  { "foreign.client_id" => "self.id" },
);
__PACKAGE__->has_many(
  "finances",
  "CMS::Schema::Result::Finance",
  { "foreign.client_id" => "self.id" },
);
__PACKAGE__->has_many(
  "finance_pnls",
  "CMS::Schema::Result::FinancePnl",
  { "foreign.client_id" => "self.id" },
);
__PACKAGE__->has_many(
  "forms",
  "CMS::Schema::Result::Form",
  { "foreign.client_id" => "self.id" },
);
__PACKAGE__->has_many(
  "users",
  "CMS::Schema::Result::User",
  { "foreign.client_id" => "self.id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2010-12-08 17:03:26
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:pEwQd+QUogo7thvcfEwvuw

#
# Enable automatic date handling
#
__PACKAGE__->add_columns(
    "created",
    { data_type => 'datetime', set_on_create => 1 },
    "updated",
    { data_type => 'datetime', set_on_create => 1, set_on_update => 1 },
);

# You can replace this text with custom content, and it will be preserved on regeneration
1;
