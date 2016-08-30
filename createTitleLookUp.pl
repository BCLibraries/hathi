#!/usr/bin/perl -w
   
use strict;
use FileHandle;
use Switch;
use DB_File;

my %processedIDs;
my %IdToYear;
my $fh2008 = new FileHandle();
my $fh2009 = new FileHandle();
my $fh2010 = new FileHandle();
my $fh2011 = new FileHandle();
my $fh2012 = new FileHandle();

my (%id2008,%id2009,%id2010,%id2011,%id2012);

main();

#-----------------------------------------------------------------------------
sub main {
    
    my $count = 0;
    my ($file) = @ARGV;
	
    tie %IdToYear, "DB_File", "IdToYearLookup";	
    
    # Input of IDs for each year	
    processIDFiles();
    #exit 1;

    # XML Lookups for each year
    openLookUpFiles();       

    # Open HathiFiles
    my $fh = new FileHandle();
    $fh->open($file);  

    while( not($fh->eof()) ) {
	$count++;
	my $line = $fh->getline();
	my ($volume, $access, $rights, $umich, $enumeration, $source, $sourceID, $oclc, $isbn, $issn, $lccn, $title, $imprint, $rightscode, $update, $govdoc, $pubdate, $pubplace, $lang, $bibformat) = split(/\t/, $line);

	if (!exists($processedIDs{$umich})) {
		
	    $title =~ s/&/&amp;/gx;
	    $title =~ s/"/&quot;/gx;
	    $title =~ s/'/&apos;/gx;
	    $title =~ s/\</&lt;/gx;
	    $title =~ s/>/&gt;/gx;
	    
	    $processedIDs{$umich}++;
	
	    if (exists($IdToYear{$umich})) {
		
		my $year = $IdToYear{$umich};
		my $lookup;
	    
		if ($govdoc eq '1') {   
		    $lookup = "\<DocValue gov=\"TRUE\" code=\"MIU01-" . $umich . "\">" . $title . "\<\/DocValue>\n";
		} else {
		    $lookup = "\<DocValue gov=\"FALSE\" code=\"MIU01-" . $umich . "\">" . $title . "\<\/DocValue>\n";
		}
		switch($year) {
		    case "2008" {print $fh2008 $lookup;}
		    case "2009" {print $fh2009 $lookup;}
		    case "2010" {print $fh2010 $lookup;}
		    case "2011" {print $fh2011 $lookup;}
		    case "2012" {print $fh2012 $lookup;}		
		}
	    }
	}
	if ($count % 25000 == 0) {
	    print "count = $count\n";
	}
    }
    
    closeLookUpFiles();
    
    print "\nfinal count = $count\n";
    
    exit 1;
}

#-----------------------------------------------------------------------------
sub processIDFiles {
    
    my $year;
    
    for ($year=2008; $year <2013; $year++) {
	my $file = 'all' . $year . 'identifiers';
	
	print "Processing $file\n";
	my $fh = new FileHandle();
	$fh->open($file);
	
	while( not($fh->eof()) ) {
	    my $line = $fh->getline();
	    chomp $line;
	    $IdToYear{$line} = $year;
	}
    } 
}
#-----------------------------------------------------------------------------
sub openLookUpFiles {
   
    $fh2008->open("> HathiTitleLookUp2008.xml");
    $fh2009->open("> HathiTitleLookUp2009.xml");
    $fh2010->open("> HathiTitleLookUp2010.xml");
    $fh2011->open("> HathiTitleLookUp2011.xml");
    $fh2012->open("> HathiTitleLookUp2012.xml");
    
    print $fh2008 "\<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n";
    print $fh2008 "\<DocLookUp>\n";
    
    print $fh2009 "\<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n";
    print $fh2009 "\<DocLookUp>\n";
    
    print $fh2010 "\<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n";
    print $fh2010 "\<DocLookUp>\n";
    
    print $fh2011 "\<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n";
    print $fh2011 "\<DocLookUp>\n";
    
    print $fh2012 "\<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n";
    print $fh2012 "\<DocLookUp>\n";
}
#-----------------------------------------------------------------------------
sub closeLookUpFiles {
    print $fh2008 "\</DocLookUp>\n";
    print $fh2009 "\</DocLookUp>\n";
    print $fh2010 "\</DocLookUp>\n";
    print $fh2011 "\</DocLookUp>\n";
    print $fh2012 "\</DocLookUp>\n";    
}
#-----------------------------------------------------------------------------