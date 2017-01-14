CREATE TABLE artist (id integer primary key autoincrement, name char(200));
CREATE TABLE album (id integer primary key autoincrement, cat char(20), year integer, title char(100));
CREATE TABLE song (id integer primary key autoincrement, title char(200));
CREATE TABLE track (id integer primary key autoincrement, number integer, song integer, album integer, artist integer, foreign key(song) references song(id), foreign key(album) references album(id), foreign key (artist) references artist(id));
