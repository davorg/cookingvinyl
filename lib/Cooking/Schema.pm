use utf8;
package Cooking::Schema;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use Moose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Schema';

__PACKAGE__->load_namespaces;


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-01-14 10:50:11
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:V1uzrrsFJonegBYLf32CfQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration

sub get_schema {
  return __PACKAGE__->connect('dbi:SQLite:./cook.db');
}

__PACKAGE__->meta->make_immutable(inline_constructor => 0);
1;
