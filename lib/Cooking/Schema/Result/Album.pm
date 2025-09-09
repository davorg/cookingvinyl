use utf8;
package Cooking::Schema::Result::Album;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Cooking::Schema::Result::Album

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

=head1 TABLE: C<album>

=cut

__PACKAGE__->table("album");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 cat

  data_type: 'char'
  is_nullable: 1
  size: 20

=head2 year

  data_type: 'integer'
  is_nullable: 1

=head2 title

  data_type: 'char'
  is_nullable: 1
  size: 100

=head2 mb_rg_mbid

  data_type: 'char'
  is_nullable: 1
  size: 36

=head2 discogs_master_id

  data_type: 'integer'
  is_nullable: 1

=head2 total_tracks

  data_type: 'integer'
  is_nullable: 1

=head2 cover_url

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "cat",
  { data_type => "char", is_nullable => 1, size => 20 },
  "year",
  { data_type => "integer", is_nullable => 1 },
  "title",
  { data_type => "char", is_nullable => 1, size => 100 },
  "mb_rg_mbid",
  { data_type => "char", is_nullable => 1, size => 36 },
  "discogs_master_id",
  { data_type => "integer", is_nullable => 1 },
  "total_tracks",
  { data_type => "integer", is_nullable => 1 },
  "cover_url",
  { data_type => "text", is_nullable => 1 },
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
  { "foreign.album" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07053 @ 2025-09-04 12:36:29
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:IiCrZ/JwdjphMxX87idOzQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration

with 'MooX::Role::JSON_LD';

sub json_ld_type { 'MusicAlbum' }

sub json_ld_fields { [
  { name => 'title' },
  { '@id' => sub { 'https://cookingvinyl.dave.org.uk/' . shift->url_path . '#album' } },
  { url => sub { 'https://cookingvinyl.dave.org.uk/' . shift->url_path } },
  { datePublished => sub { shift->year . '' } },
  { identifier => 'cat' },
  { byArtist => sub { {
      '@type' => 'MusicGroup',
      'name' => 'Various Artists',
    } }
  },
  { publisher => sub { {
     '@type' => 'Organization',
     name    => 'Cooking Vinyl'
    } },
  },
  { numTracks => sub { shift->tracks->count } },
  { track => sub {
      [ map { $_->json_ld_data } shift->tracks->all ],
    }
  },
  { mainEntityOfPage => sub { 'https://cookingvinyl.dave.org.uk/' . shift->url_path } },
] }

sub json_ld_short_data {
  my $self = shift;

  return {
    '@type'  => $self->json_ld_type,
    name     => $self->title,
    byArtist => {
      '@type' => 'MusicGroup',
      name    => 'Various Artists',
      url     => 'https://cookingvinyl.dave.org.uk/' . $self->url_path,
    }
  }
}

sub breadcrumb_type { 'Albums' }
sub breadcrumb_path { '/albums/' }

sub page_title {
  my $self = shift;
  my $title = $self->cat;
  $title .= ': ' . $self->title if $self->title;

  return $title;
}

sub type {
  return 'music.album';
}

sub description {
  my $self = shift;
  return 'Album: ' . $self->title;
}

sub url_path {
  my $self = shift;
  my $fn = lc $self->cat;
  $fn =~ s/\s+//g;

  return "albums/$fn/";
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
