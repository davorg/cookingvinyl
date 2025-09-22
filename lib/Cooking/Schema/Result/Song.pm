use utf8;
package Cooking::Schema::Result::Song;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Cooking::Schema::Result::Song

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

=head1 TABLE: C<song>

=cut

__PACKAGE__->table("song");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 title

  data_type: 'char'
  is_nullable: 1
  size: 200

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "title",
  { data_type => "char", is_nullable => 1, size => 200 },
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
  { "foreign.song" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07053 @ 2025-09-04 12:36:29
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:BWGnoTrYdiTDRDYtzALx9Q


# You can replace this text with custom code or comments, and it will be preserved on regeneration

with 'MooX::Role::JSON_LD', 'MooX::Role::SEOTags', 'Cooking::Role::Default';

sub json_ld_type { 'MusicRecording' }

sub json_ld_fields { [
  { name => 'title' },
  { '@id' => sub { 'https://cookingvinyl.dave.org.uk/' . shift->url_path . '#song' } },
  { mainEntityOfPage => sub { 'https://cookingvinyl.dave.org.uk/' . shift->url_path } },
  { url => sub { 'https://cookingvinyl.dave.org.uk/' . shift->url_path } },
  { inAlbum => sub {
      [ map {
          $_->album->json_ld_short_data,
        } shift->tracks ]
    }
  },
] }

sub breadcrumb_type { 'Songs' }
sub breadcrumb_path { '/songs/' }

sub og_title {
  my $self = shift;

  return sprintf '%s · Cooking Vinyl Compilation Tracks', $self->title // 'Unknown Title';
}

sub og_type {
  return 'music.song';
}

sub og_url {
  my $self = shift;

  return 'https://cookingvinyl.dave.org.uk/' . $self->url_path;
}

sub og_description {
  my $self = shift;
  return sprintf '%s on Cooking Vinyl samplers/promos. See all album appearances.',
    $self->title // 'Unknown Title';
}

sub url_path {
  my $self = shift;
  my $fn = lc $self->title;
  $fn =~ s/\W+/_/g;

  return "songs/$fn/";
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
