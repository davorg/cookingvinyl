package Cooking::Role::Default;

use feature 'signatures';

use Moo::Role;

sub domain { 'https://cookingvinyl.dave.org.uk' }

sub og_type($self) {
  if ( $self->can('type') ) {
    return $self->type;
  }
  return 'website';
}

sub og_image($self) {
  if ( $self->can('image') ) {
    return $self->image;
  }
  return $self->domain . '/img/og-cooking-vinyl.png';
}

sub og_url($self) {
  if ( $self->can('url_path') ) {
    return $self->domain . '/' . $self->url_path;
  }
  return $self->domain . '/' . $self->url_path;
}

1;
