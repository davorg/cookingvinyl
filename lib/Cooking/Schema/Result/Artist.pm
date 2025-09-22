use utf8;
package Cooking::Schema::Result::Artist;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Cooking::Schema::Result::Artist

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=item * L<DBIx::Class::TimeStamp>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime", "TimeStamp");

=head1 TABLE: C<artist>

=cut

__PACKAGE__->table("artist");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 name

  data_type: 'char'
  is_nullable: 1
  size: 200

=head2 mbid

  data_type: 'char'
  is_nullable: 1
  size: 36

=head2 discogs_id

  data_type: 'integer'
  is_nullable: 1

=head2 blurb

  data_type: 'varchar'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "name",
  { data_type => "char", is_nullable => 1, size => 200 },
  "mbid",
  { data_type => "char", is_nullable => 1, size => 36 },
  "discogs_id",
  { data_type => "integer", is_nullable => 1 },
  "blurb",
  { data_type => "varchar", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 tracks

Type: has_many

Related object: L<Cooking::Schema::Result::Track>

=cut

__PACKAGE__->has_many(
  "tracks",
  "Cooking::Schema::Result::Track",
  { "foreign.artist" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07053 @ 2025-09-10 11:24:15
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:w9XFA2o6BhCjv8OD3A7gmQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration

with 'MooX::Role::JSON_LD', 'MooX::Role::OpenGraph', 'Cooking::Role::Default';

sub json_ld_type { 'MusicGroup' }

sub json_ld_fields {
  [
    'name',
    { '@id' => sub { 'https://cookingvinyl.dave.org.uk/' . shift->url_path . '#artist' } },
    { url => sub { 'https://cookingvinyl.dave.org.uk/' . shift->url_path } },
    { mainEntityOfPage => sub { 'https://cookingvinyl.dave.org.uk/' . shift->url_path } },
  ],
}

sub breadcrumb_type { 'Artists' }
sub breadcrumb_path { '/artists/' }

sub og_title {
  my $self = shift;
  return sprintf '%s · Cooking Vinyl Compilation Appearances', $self->name;
}

sub og_type {
  return 'music.musician';
}

sub og_url {
  my $self = shift;
  return 'https://cookingvinyl.dave.org.uk/' . $self->url_path;
}

sub og_description {
  my $self = shift;
  return sprintf 'Compilation appearances by %s on Cooking Vinyl samplers and promos.',
    $self->name // 'Unknown Artist';
}

sub url_path {
  my $self = shift;
  my $fn = lc $self->name;
  $fn =~ s/\W+/_/g;
  return "artists/$fn/";
}

sub out_file {
  my $self = shift;

  return $self->url_path . 'index.html';
}

sub redirect_file {
  my $self = shift;

  return $self->url_path =~ s[/$][.html]r;
}

__PACKAGE__->meta->make_immutable;
1;
