#! /usr/bin/perl -w
# $Id: txt2h.pl 216 2006-07-09 17:32:37Z r3mi $
#
# Text to C Header converter.
# This file is part of djmount.
#
# (C) Copyright 2005-2006 R�mi Turboult <r3mi@users.sourceforge.net>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
#

use strict;

die "Usage : $0 text_files ...\n" unless @ARGV;

my $date = localtime;
my $header = <<EOD;
/*
 * This file is automatically generated, do not edit directly.
 * Generated $date by $0.
 */

EOD

while (@ARGV) {
  my $file = shift @ARGV;
  open (FILE, $file) or die "Can't open $file: $!\n";

  my $len = 0;
  my $macro = uc $file;
  $macro =~ s|^.*/||;
  $macro =~ s|\W|_|g;

  print <<EOD;
$header/* Generated from "$file" */
#define ${macro}_STRING  \\
EOD
  $header = '';

  while (<FILE>) {
    chomp;
    $len += 1 + length $_;
    s/(["\\])/\\$1/g;
    print "    \"$_\\n\"\\\n";
  }

  print <<EOD;

#define ${macro}_LENGTH  $len

EOD
}



