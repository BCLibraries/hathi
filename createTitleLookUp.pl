#!/usr/bin/perl -w

use strict;
use FileHandle;
use DB_File;
use HTML::Entities;

main();

#-----------------------------------------------------------------------------
sub main {

  my $count = 0;
  my ($file) = @ARGV;

  my $outFH = new FileHandle();
  $outFH->open("> titleMerge.xml");

  print $outFH "\<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n";
  print $outFH "\<DocLookUp>\n";

  # Open HathiFiles
  my $fh = new FileHandle();
  $fh->open($file);

  while( not($fh->eof()) ) {
    $count++;
    my $line = $fh->getline();
    my ($umich, $title, $govdoc) = split(/\t/, $line);
    my $lookup;
    my $encoded_title = encode_entities($title, '<>&');
    if ($govdoc == 1) {
      $lookup = "\<DocValue gov=\"TRUE\" code=\"MIU01-" . $umich . "\">" . $encoded_title . "\<\/DocValue>\n";
    } else {
      $lookup = "\<DocValue gov=\"FALSE\" code=\"MIU01-" . $umich . "\">" . $encoded_title . "\<\/DocValue>\n";
    }
    print $outFH $lookup;

    if ($count % 25000 == 0) {
      print "count = $count\n";
    }
  }

  print $outFH "\<\/DocLookUp>\n";
  print "\nfinal count = $count\n";

  exit 1;
}

#-----------------------------------------------------------------------------
