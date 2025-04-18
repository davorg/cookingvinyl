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
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

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


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-01-14 10:51:27
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:SiM6rbSJk7Tu0GJwsGpvUw


# You can replace this text with custom code or comments, and it will be preserved on regeneration

sub page_title {
  my $self = shift;

  return $self->title;
}

sub type {
  return 'music.song';
}

sub description {
  my $self = shift;
  return 'Song: ' . $self->title;
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
