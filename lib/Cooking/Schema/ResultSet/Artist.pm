package Cooking::Schema::ResultSet::Artist;
 
use strict;
use warnings;
 
use Moose;
use MooseX::NonMoose;
extends 'DBIx::Class::ResultSet';
 
sub BUILDARGS { $_[2] }

sub letters {
  my $self = shift;

  my %letters;

  for ($self->all) {
    my $l = uc substr($_->name, 0, 1);
    $letters{$l}++;
  }

  return [sort keys %letters];
}

__PACKAGE__->meta->make_immutable;
 
1;
