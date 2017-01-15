package Cooking::Schema::ResultSet::Track;
 
use strict;
use warnings;
 
use Moose;
use MooseX::NonMoose;
extends 'DBIx::Class::ResultSet';
 
sub BUILDARGS { $_[2] }

sub by_title {
  my $self = shift;

  return $self->search({}, {
    join     => 'song',
    order_by => 'song.title',
  });
}

__PACKAGE__->meta->make_immutable;
 
1;
