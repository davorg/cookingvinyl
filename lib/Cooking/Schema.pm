use utf8;
package Cooking::Schema;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use Moose;
use namespace::autoclean;
extends 'DBIx::Class::Schema';

__PACKAGE__->load_namespaces;


# Created by DBIx::Class::Schema::Loader v0.07053 @ 2025-09-04 12:35:47
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:+nZ/kAlJlRAHkPMbSn0Izw


# You can replace this text with custom code or comments, and it will be preserved on regeneration

use FindBin '$Bin';

sub get_schema {
  return __PACKAGE__->connect("dbi:SQLite:$Bin/../dat/cook.db");
}

__PACKAGE__->meta->make_immutable(inline_constructor => 0);
1;
