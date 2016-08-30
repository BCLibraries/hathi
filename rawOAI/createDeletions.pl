#!/usr/bin/perl -w
   
use strict;
use FileHandle;

main();

#-----------------------------------------------------------------------------
sub main {
    
    my ($file) = @ARGV;
	   
    my ($gcount,$count) = (0,0);
    my $fh = new FileHandle();
    $fh->open($file);
    
    my $govFH = new FileHandle();
    my $outFH = new FileHandle();
    
    $govFH->open("> govdeletions.xml") ;
    $outFH->open("> dels\pddeletions.xml") ;
    
    print $govFH "<identifiers>";
    print $outFH "<identifiers>";
    
    while( not($fh->eof()) )
    {
	my $line = $fh->getline();
	my ($volume, $access, $rights, $umich, $enumeration, $source, $sourceID, $oclc, $isbn, $issn, $lccn, $title, $imprint, $rightscode, $update, $govdoc, $pubdate, $pubplace, $lang, $bibformat) = split(/\t/, $line);

	if ($access eq "allow") {
	    

	    if ($govdoc) {
		$gcount++;
		if ($count % 5000 == 0) {
		    
		} else {
		    print $govFH "<identifier>oai:quod.lib.umich.edu:MIU01-$umich<\/identifier>\r\n";
		}
	    } else {
		$count++;
		print $outFH "<identifier>oai:quod.lib.umich.edu:MIU01-$umich<\/identifier>\r\n";
	    }
	}
    }
 
    print $govFH "<\/identifiers>";
    print $outFH "<\/identifiers>";
    
    $govFH->close();
    $outFH->close();
    
    exit 1;
}

#-----------------------------------------------------------------------------
