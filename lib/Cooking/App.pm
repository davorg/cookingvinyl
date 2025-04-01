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

field %file = (
  index => {
    out       => 'index.html',
    title     => '',
    canonical => '',
    desc      => 'Information about the compilation albums released by Cooking Vinyl records.',
  },
  about => {
    out       => 'about/index.html',
    title     => 'About',
    canonical => 'about/',
    desc      => 'About the site and why I built it.'
  },
);

field @urls;

method run {
  for (keys %file) {
    my $file = $file{$_};
    my $vars = {
      canonical => "$uri/$file->{canonical}",
      title     => $file->{title},
      desc      => $file->{desc},
      type      => 'website',
    };

    $tt->process("$_.tt", $vars, $file->{out})
      or die $tt->error;

    push @urls, $vars->{canonical};
  }

  $tt->process('albums.tt', {
    albums    => \@albums,
    title     => 'List of Albums',
    canonical => "$uri/albums/",
    desc      => 'List of compilation albums released by Cooking Vinyl records.',
    type      => 'website',
  }, 'albums/index.html')
    or die $tt->error;

  push @urls, "$uri/albums/";

  $tt->process('artists.tt', {
    artists   => \@artists,
    title     => 'List of Artists',
    canonical => "$uri/artists/",
    desc      => 'List of artists appearing on compilations released by Cooking Vinyl records.',
    type      => 'website',
  }, 'artists/index.html')
    or die $tt->error;

  push @urls, "$uri/artists/";
 
  $tt->process('songs.tt', {
    songs     => \@songs,
    title     => 'List of Songs',
    canonical => "$uri/songs/",
    desc      => 'List of songs appearing on compilations released by Cooking Vinyl records.',
    type      => 'website',
  }, 'songs/index.html')
    or die $tt->error;

  push @urls, "$uri/songs/";

  foreach (@albums) {
    next unless $_->title;
    $tt->process('album.tt', {
      album     => $_,
      tracks    => [ $_->tracks->by_title ],
      title     => $_->page_title,
      canonical => "$uri/" . $_->url_path,
      desc      => 'Album: ' . $_->title,
      type      => 'music.album',
    }, $_->out_file)
      or die $tt->error;

    push @urls, "$uri/" . $_->url_path;

    $tt->process('redirect.tt', { target => '/' . $_->url_path }, $_->redirect_file);
  }

  foreach (@artists) {
    $tt->process('artist.tt', {
      artist    => $_,
      tracks    => [ $_->tracks->by_title ],
      title     => $_->page_title,
      canonical => "$uri/" . $_->url_path,
      desc      => 'Artist: ' . $_->name,
      type      => 'music.musician',
    }, $_->out_file)
      or die $tt->error;

    push @urls, "$uri/" . $_->url_path;

    $tt->process('redirect.tt', { target => '/' . $_->url_path }, $_->redirect_file);
  }

  foreach (@songs) {
    $tt->process('song.tt', {
      song      => $_,
      tracks    => [ $_->tracks->by_title ],
      title     => $_->page_title,
      canonical => "$uri/" . $_->url_path,
      desc      => 'Song: ' . $_->title,
      type      => 'music.song',
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
