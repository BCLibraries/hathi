#!/usr/bin/perl -w
   
use strict;
use FileHandle;

main();

#-----------------------------------------------------------------------------
sub main {
    
    my $count = 0;
    my ($file, $output) = @ARGV;
	
    # Open HathiFiles
    my $fh = new FileHandle();
    $fh->open($file);
    $fh->binmode(':utf8');

    my $fhLookup = new FileHandle();
    $fhLookup->open("> $output");
    $fhLookup->binmode(':utf8');
    
    print $fhLookup "\<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n";
    print $fhLookup "\<DocLookUp>\n";

    while( not($fh->eof()) ) {
	$count++;
	my $line = $fh->getline();
	my ($umich, $title, $govdoc) = split(/\t/, $line);

	$title =~ s/&/&amp;/gx;
	$title =~ s/"/&quot;/gx;
	$title =~ s/'/&apos;/gx;
	$title =~ s/\</&lt;/gx;
	$title =~ s/>/&gt;/gx;
	    
	if ($govdoc eq '1') {   
	    print $fhLookup "\<DocValue gov=\"TRUE\" code=\"MIU01-" . $umich . "\">" . $title . "\<\/DocValue>\n";
	} else {
	    print $fhLookup "\<DocValue gov=\"FALSE\" code=\"MIU01-" . $umich . "\">" . $title . "\<\/DocValue>\n";
	}

	if ($count % 5000 == 0) {
	    print "count = $count\n";
	}
    }
    
    print $fhLookup "\</DocLookUp>\n";
    
    print "\nfinal count = $count\n";
    
    exit 1;
}
