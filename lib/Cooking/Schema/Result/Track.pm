use utf8;
package Cooking::Schema::Result::Track;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Cooking::Schema::Result::Track

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<track>

=cut

__PACKAGE__->table("track");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 number

  data_type: 'integer'
  is_nullable: 1

=head2 song

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 album

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 artist

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "number",
  { data_type => "integer", is_nullable => 1 },
  "song",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "album",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "artist",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 album

Type: belongs_to

Related object: L<Cooking::Schema::Result::Album>

=cut

__PACKAGE__->belongs_to(
  "album",
  "Cooking::Schema::Result::Album",
  { id => "album" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);

=head2 artist

Type: belongs_to

Related object: L<Cooking::Schema::Result::Artist>

=cut

__PACKAGE__->belongs_to(
  "artist",
  "Cooking::Schema::Result::Artist",
  { id => "artist" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);

=head2 song

Type: belongs_to

Related object: L<Cooking::Schema::Result::Song>

=cut

__PACKAGE__->belongs_to(
  "song",
  "Cooking::Schema::Result::Song",
  { id => "song" },
  {
    is_deferrable => 0,
    join_type     => "LEFT",
    on_delete     => "NO ACTION",
    on_update     => "NO ACTION",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-01-14 11:01:12
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:uya7K9N6vnXBApFObqBHXQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
