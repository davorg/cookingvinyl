package Cooking::Page;

use strict;
use warnings;

use feature 'signatures';

use Moo;

with 'MooX::Role::OpenGraph',
     'Cooking::Role::Default';

has title => ( is => 'ro', required => 1 );
has url_path => ( is => 'ro', required => 1 );
has description => ( is => 'ro', required => 1 );
has type => ( is => 'ro', default => sub { 'website' } );
has image => ( is => 'ro', default => sub {
  shift->domain . '/img/og-cooking-vinyl.png'
});
has out => ( is => 'ro' );
has noindex => ( is => 'ro', default => sub { 0 } );

sub og_title($self) {
  return $self->title;
}

sub og_description($self) {
  return $self->description;
}

sub og_type($self) {
  return $self->type;
}

sub og_image($self) {
  return $self->image;
}

sub og_url($self) {
  return $self->domain . '/' . $self->url_path;
}

__PACKAGE__->meta->make_immutable;
1;