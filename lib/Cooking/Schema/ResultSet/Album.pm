package Cooking::Schema::ResultSet::Album;
 
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
    my $l = uc substr($_->title, 0, 1);
    $letters{$l}++;
  }

  return [sort keys %letters];
}

sub decades {
  my $self = shift;

  my %decades;

  for ($self->all) {
    my $d = int($_->year / 10) . 'x';
    $decades{$d}++;
  }

  return [sort keys %decades];
}

sub years {
  my $self = shift;

  my %years;

  for ($self->all) {
    my $y = $_->year;
    next unless defined $y;
    $years{$y}++;
  }

  return [ sort keys %years ];
}

__PACKAGE__->meta->make_immutable;
 
1;
