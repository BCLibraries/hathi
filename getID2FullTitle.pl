#!/usr/bin/perl -w
   
use strict;
use FileHandle;
use File::Copy;

my %processedIDs;

main();

#-----------------------------------------------------------------------------
sub main {
    
    my ($count, $govcount, $missing) = (0,0,0);
    my ($file) = @ARGV;
	   
    my $fh = new FileHandle();
    $fh->open($file);
    
    my $pdfh = new FileHandle();
    $pdfh->open("> HathiTitle20120801.xml");
    
    print $pdfh "\<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n";
    print $pdfh "\<DocLookUp>\n";
    
    while( not($fh->eof()) )
    {
	$count++;
	my $line = $fh->getline();
	my ($volume, $access, $rights, $umich, $enumeration, $source, $sourceID, $oclc, $isbn, $issn, $lccn, $title, $imprint, $rightscode, $update, $govdoc, $pubdate, $pubplace, $lang, $bibformat) = split(/\t/, $line);

	if (!exists($processedIDs{$umich})) {
		
	    $processedIDs{$umich}++;
	
	    if ($govdoc eq '1') {   
		$title =~ s/&/&amp;/gx;
		$title =~ s/"/&quot;/gx;
		$title =~ s/'/&apos;/gx;
		$title =~ s/\</&lt;/gx;
		$title =~ s/>/&gt;/gx;
		print  $pdfh "\<DocValue gov=\"TRUE\" code=\"MIU01-" . $umich . "\">" . $title . "\<\/DocValue>\n";
	    } else {
		$title =~ s/&/&amp;/gx;
		$title =~ s/"/&quot;/gx;
		$title =~ s/'/&apos;/gx;
		$title =~ s/\</&lt;/gx;
		$title =~ s/>/&gt;/gx;		
		print  $pdfh "\<DocValue gov=\"FALSE\" code=\"MIU01-" . $umich . "\">" . $title . "\<\/DocValue>\n";
	    }
	}
	if ($count % 15000 == 0) {
	    print "count = $count\n";
	}
    }
    print $pdfh "\</DocLookUp>\n";
    print "\nfinal count = $count\n";
    
    exit 1;
}

#-----------------------------------------------------------------------------
