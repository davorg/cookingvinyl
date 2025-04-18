#!/usr/bin/perl

use strict;
use warnings;
use 5.040;

use feature 'class';
no warnings 'experimental::class';

class Cooking::App;

use lib 'lib';
use Cooking::Schema;
use Template;

field $uri = 'https://cookingvinyl.dave.org.uk';
field $sch = Cooking::Schema->get_schema;
field $tt = Template->new({
  INCLUDE_PATH => [ qw(in tt_lib) ],
  OUTPUT_PATH  => 'docs',
});

field @albums  = $sch->resultset('Album')->all;
field @artists = $sch->resultset('Artist')->search(undef, {
  order_by => 'name',
})->all;
field @songs   = $sch->resultset('Song')->search(undef, {
  order_by => 'title',
})->all;

field %page = (
  index => {
    out         => 'index.html',
    page_title  => '',
    url_path    => '',
    description => 'Information about the compilation albums released by Cooking Vinyl records.',
    type        => 'website',
  },
  about => {
    out         => 'about/index.html',
    page_title  => 'About',
    url_path    => 'about/',
    description => 'About the site and why I built it.',
    type        => 'website',
  },
);

field @urls;

method run {
  for (keys %page) {
    $tt->process("$_.tt", {
      page => $page{$_},
      domain => $uri,
    }, $page{$_}->{out})
      or die $tt->error;

    push @urls, "$uri/$page{$_}->{url_path}";
  }

  $tt->process('albums.tt', {
    albums    => \@albums,
    domain    => $uri,
    page      => {
      page_title  => 'List of Albums',
      url_path    => 'albums/',
      description => 'List of compilation albums released by Cooking Vinyl records.',
      type        => 'website',
    },
  }, 'albums/index.html')
    or die $tt->error;

  push @urls, "$uri/albums/";

  $tt->process('artists.tt', {
    artists   => \@artists,
    domain    => $uri,
    page      => {
      page_title  => 'List of Artists',
      url_path    => 'artists/',
      description => 'List of artists appearing on compilations released by Cooking Vinyl records.',
      type      => 'website',
    },
  }, 'artists/index.html')
    or die $tt->error;

  push @urls, "$uri/artists/";
 
  $tt->process('songs.tt', {
    songs     => \@songs,
    domain    => $uri,
    page      => {
      page_title  => 'List of Songs',
      url_path    => 'songs/',
      description => 'List of songs appearing on compilations released by Cooking Vinyl records.',
      type        => 'website',
    },
  }, 'songs/index.html')
    or die $tt->error;

  push @urls, "$uri/songs/";

  foreach (@albums) {
    next unless $_->title;
    $tt->process('album.tt', {
      album     => $_,
      domain    => $uri,
      tracks    => [ $_->tracks->by_title ],
    }, $_->out_file)
      or die $tt->error;

    push @urls, "$uri/" . $_->url_path;

    $tt->process('redirect.tt', { target => '/' . $_->url_path }, $_->redirect_file);
  }

  foreach (@artists) {
    $tt->process('artist.tt', {
      artist    => $_,
      domain    => $uri,
      tracks    => [ $_->tracks->by_title ],
    }, $_->out_file)
      or die $tt->error;

    push @urls, "$uri/" . $_->url_path;

    $tt->process('redirect.tt', { target => '/' . $_->url_path }, $_->redirect_file);
  }

  foreach (@songs) {
    $tt->process('song.tt', {
      song      => $_,
      domain    => $uri,
      tracks    => [ $_->tracks->by_title ],
    }, $_->out_file)
      or die $tt->error;

    push @urls, "$uri/" . $_->url_path;

    $tt->process('redirect.tt', { target => '/' . $_->url_path }, $_->redirect_file);
  }

  open my $sitemap, '>', 'docs/sitemap.xml'
    or die "Cannot open docs/sitemap.xml: $!\n";

  print $sitemap <<EOSITEMAP;
<?xml version='1.0' encoding='UTF-8'?>
<urlset xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://www.sitemaps.org/schemas/sitemap/0.9 http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd"
  xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
EOSITEMAP

  for (@urls) {
    print $sitemap <<EOSITEMAP;
  <url>
    <loc>$_</loc>
  </url>
EOSITEMAP
  }

  print $sitemap "</urlset>\n";
}
