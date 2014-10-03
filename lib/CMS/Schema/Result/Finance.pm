package CMS::Schema::Result::Finance;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "TimeStamp", "EncodedColumn", "Core");
__PACKAGE__->table("finance");
__PACKAGE__->add_columns(
  "id",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 11 },
  "client_id",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 11 },
  "month",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 11 },
  "year",
  { data_type => "INT", default_value => undef, is_nullable => 0, size => 11 },
  "income",
  { data_type => "FLOAT", default_value => undef, is_nullable => 1, size => 32 },
  "expense",
  { data_type => "FLOAT", default_value => undef, is_nullable => 1, size => 32 },
  "units",
  { data_type => "INT", default_value => undef, is_nullable => 1, size => 11 },
  "late",
  { data_type => "INT", default_value => undef, is_nullable => 1, size => 11 },
  "collection",
  { data_type => "INT", default_value => undef, is_nullable => 1, size => 11 },
  "bank_foreclosure",
  { data_type => "INT", default_value => undef, is_nullable => 1, size => 11 },
  "payment_plan",
  { data_type => "INT", default_value => undef, is_nullable => 1, size => 11 },
  "uncollected_funds",
  { data_type => "FLOAT", default_value => undef, is_nullable => 1, size => 32 },
  "aging_summary",
  { data_type => "FLOAT", default_value => undef, is_nullable => 1, size => 32 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->belongs_to(
  "client_id",
  "CMS::Schema::Result::Client",
  { id => "client_id" },
);


# Created by DBIx::Class::Schema::Loader v0.04005 @ 2010-12-08 17:03:26
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:1RwwLluqEU8WNK9Cu03i4A


# You can replace this text with custom content, and it will be preserved on regeneration
1;
