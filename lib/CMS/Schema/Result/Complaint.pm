package CMS::Schema::Result::Complaint;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "TimeStamp", "EncodedColumn", "Core");
__PACKAGE__->table("complaint");
__PACKAGE__->add_columns(
  "id",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 11 },
  "client_id",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 11 },
  "tenant",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 128,
  },
  "subject",
  {
    data_type => "VARCHAR",
    default_value => undef,
    is_nullable => 0,
    size => 128,
  },
  "description",
  {
    data_type => "TEXT",
    default_value => undef,
    is_nullable => 0,
    size => 65535,
  },
  "status",
  {
    data_type => "VARCHAR",
    default_value => "Open",
    is_nullable => 1,
    size => 12,
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
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:hlUAnRVfza65TtNhKm4r2g

__PACKAGE__->add_columns(
    "created",
    { data_type => 'datetime', set_on_create => 1 },
    "updated",
    { data_type => 'datetime', set_on_create => 1, set_on_update => 1 },
);

# You can replace this text with custom content, and it will be preserved on regeneration
1;
