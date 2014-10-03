package CMS::Schema::Result::FinancePnl;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "TimeStamp", "EncodedColumn", "Core");
__PACKAGE__->table("finance_pnl");
__PACKAGE__->add_columns(
  "id",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 11 },
  "client_id",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 11 },
  "account",
  { data_type => "INT", default_value => undef, is_nullable => 1, size => 11 },
  "description",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 1,
    size => 255,
  },
  "amount",
  {
    data_type => "DECIMAL",
    default_value => undef,
    is_nullable => 1,
    size => 12,
  },
  "month",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 11 },
  "year",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 11 },
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
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Y77hA4/m5RQUKN74tPfn8A


# You can replace this text with custom content, and it will be preserved on regeneration
1;
