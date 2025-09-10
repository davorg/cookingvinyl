#!/usr/bin/perl

use strict;
use warnings;
use utf8;
use 5.040;

use feature 'class';
no warnings 'experimental::class';

class Cooking::App;

use lib 'lib';
use Cooking::Schema;
use Template;
use Time::Piece;

field $uri = 'https://cookingvinyl.dave.org.uk';
field $sch = Cooking::Schema->get_schema;
field $tt = Template->new({
  ENCODING     => 'utf8',
  INCLUDE_PATH => [ qw(in tt_lib) ],
  OUTPUT_PATH  => 'docs',
  PRE_PROCESS  => [
    'breadcrumb_json_ld.tt',
    'monetisation.tt',
    'seo_header.tt',
  ],
  VARIABLES    => {
    uri => $uri,
  },
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
    description => 'Exploring the compilation albums released by Cooking Vinyl — browse by albums, artists, and songs.',
  },
  about => {
    out         => 'about/index.html',
    page_title  => 'About the site · Cooking Vinyl Compilations',
    url_path    => 'about/',
    description => 'A little about the Cooking Vinyl Compilations site, its purpose, and the data it contains.',
  },
  404 => {
    out         => '404.html',
    page_title  => '404 Not Found · Cooking Vinyl Compilations',
    url_path    => '',
    description => 'The requested page could not be found.',
    noindex     => 1,
  },
);

field @urls;

method run {
  warn "Generating site...\n";
  warn "\tPages\n";
  for (keys %page) {
    warn "\t\t$_\n";
    $tt->process("$_.tt", {
      page_type => 'page',
      page      => $page{$_},
      domain     => $uri,
    }, $page{$_}->{out}, { binmode => ':utf8' })
      or die $tt->error;

    push @urls, "$uri/$page{$_}->{url_path}" unless $page{$_}->{noindex};
  }

  warn "\tAlbums list\n"; 
  $tt->process('albums.tt', {
    page_type => 'list',
    albums    => $sch->resultset('Album'),
    domain    => $uri,
    page      => {
      page_title  => 'Albums · Cooking Vinyl Compilations',
      url_path    => 'albums/',
      description => 'Browse the compilation albums released by Cooking Vinyl records.',
      type        => 'website',
    },
  }, 'albums/index.html', { binmode => ':utf8' })
    or die $tt->error;

  push @urls, "$uri/albums/";

  warn "\tArtists list\n";
  $tt->process('artists.tt', {
    page_type => 'list',
    artists   => $sch->resultset('Artist')->search_rs(undef, {
      order_by => 'name',
    }),
    domain    => $uri,
    page      => {
      page_title  => 'Artists · Cooking Vinyl Compilation Appearances',
      url_path    => 'artists/',
      description => 'Browse the artists appearing on compilations released by Cooking Vinyl records.',
      type      => 'website',
    },
  }, 'artists/index.html', { binmode => ':utf8' })
    or die $tt->error;

  push @urls, "$uri/artists/";
 
  warn "\tSongs list\n";
  $tt->process('songs.tt', {
    page_type => 'list',
    songs     => \@songs,
    domain    => $uri,
    page      => {
      page_title  => 'Songs · Cooking Vinyl Compilation Tracks',
      url_path    => 'songs/',
      description => 'Browse the songs appearing on compilations released by Cooking Vinyl records.',
      type        => 'website',
    },
  }, 'songs/index.html', { binmode => ':utf8' })
    or die $tt->error;

  push @urls, "$uri/songs/";

  warn "\tAlbum detail pages\n";
  foreach (@albums) {
    next unless $_->title;
    $tt->process('album.tt', {
      page_type => 'detail',
      album     => $_,
      domain    => $uri,
      tracks    => [ $_->tracks->by_title ],
    }, $_->out_file, { binmode => ':utf8' })
      or die $tt->error;

    push @urls, "$uri/" . $_->url_path;

    $tt->process('redirect.tt', { target => '/' . $_->url_path }, $_->redirect_file);
  }

  warn "\tArtist detail pages\n";
  foreach (@artists) {
    $tt->process('artist.tt', {
      page_type => 'detail',
      artist    => $_,
      domain    => $uri,
      tracks    => [ $_->tracks->by_title ],
    }, $_->out_file, { binmode => ':utf8' })
      or die $tt->error;

    push @urls, "$uri/" . $_->url_path;

    $tt->process('redirect.tt', { target => '/' . $_->url_path }, $_->redirect_file);
  }

  warn "\tSong detail pages\n";
  foreach (@songs) {
    $tt->process('song.tt', {
      page_type => 'detail',
      song      => $_,
      domain    => $uri,
      tracks    => [ $_->tracks->by_title ],
    }, $_->out_file, { binmode => ':utf8' })
      or die $tt->error;

    push @urls, "$uri/" . $_->url_path;

    $tt->process('redirect.tt', { target => '/' . $_->url_path }, $_->redirect_file);
  }

  warn "\tSitemap\n";
  open my $sitemap, '>', 'docs/sitemap.xml'
    or die "Cannot open docs/sitemap.xml: $!\n";

  print $sitemap <<EOSITEMAP;
<?xml version='1.0' encoding='UTF-8'?>
<urlset xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://www.sitemaps.org/schemas/sitemap/0.9 http://www.sitemaps.org/schemas/sitemap/0.9/sitemap.xsd"
  xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
EOSITEMAP

  my $lastmod = localtime;
  $lastmod = $lastmod->strftime('%Y-%m-%dT%H:%M:%S+00:00');

  for (@urls) {
    print $sitemap <<EOSITEMAP;
  <url>
    <loc>$_</loc>
    <lastmod>$lastmod</lastmod>
  </url>
EOSITEMAP
  }

  print $sitemap "</urlset>\n";

  warn "Done\n";
}
