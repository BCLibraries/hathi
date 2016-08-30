#!/usr/bin/perl -w
   
use strict;
use FileHandle;
#use Switch;
use File::Copy;


main();

my (%pdv,%pdusv,%pdworldv);
my (%pdu,%pdusu,%pdworldu);
#-----------------------------------------------------------------------------
sub main {
    
    my ($count,$pd,$ic,$opb,$orph,$und,$umall,$world,$nobody,$pdus,$ccby,$ccbynd,$ccbyncnd,$ccbync,$ccbyncsa,$ccbysa) =
	(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
    my ($file) = @ARGV;
	   
    my $fh = new FileHandle();
    $fh->open($file);
    
    my $govfh = new FileHandle();
    $govfh->open("> AllGovDocIDs_2014");
    
    while( not($fh->eof()) )
    {
	$count++;
	my $line = $fh->getline();
	my ($volume, $access, $rights, $umich, $enumeration, $source, $sourceID, $oclc, $isbn, $issn, $lccn, $title, $imprint, $rightscode, $update, $govdoc, $pubdate, $pubplace, $lang, $bibformat) = split(/\t/, $line);

	$rights =~ s/\-//gx;
	$title =~ s/&/&amp;/gx;
        $title =~ s/"/&quot;/gx;
        $title =~ s/'/&apos;/gx;
        $title =~ s/\</&lt;/gx;
        $title =~ s/>/&gt;/gx;
	    
	if ( $govdoc) {
	    print $govfh "<DocValue code=\"MIU01-$umich\">$title</DocValue>\n";
	#switch($rights) {
	#    #case "pd" 		{ $pd++; print $pdfh $line; print $pdv "$volume\n"; print $pdu "$umich\n";}
	#    case "pd" 		{ $pd++; print $pdfh "$umich\n";}
	#    case "ic" 		{ $ic++ }
	#    case "opb" 		{ $opb++ }
	#    case "orph"		{ $orph++ }
	#    case "und" 		{ $und++ }
	#    case "umall" 	{ $umall++ }
	#    #case "world" 	{ $world++; print $pdworldfh $line; print $pdworldv "$volume\n"; print $pdworldu "$umich\n"; }
	#    case "world" 	{ $pd++; print $pdfh "$umich\n";}
	#    case "nobody" 	{ $nobody++ }
	#    #case "pdus" 	{ $pdus++; print $pdusfh $line; print $pdusv "$volume\n"; print $pdusu "$umich\n"; }
	#    case "pdus" 	{ $pd++; print $pdfh "$umich\n";}	    
	#    case "ccby" 	{ $ccby++ }
	#    case "ccbynd" 	{ $ccbynd++ }
	#    case "ccbyncnd" 	{ $ccbyncnd++ }
	#    case "ccbync" 	{ $ccbync++ }
	#    case "ccbyncsa"	{ $ccbyncsa++ }
	#    case "ccbysa" 	{ $ccbysa++ }
	}
	
	if ($count % 15000 == 0) {
	   print "count = $count\n"; #pd = $pd\nic = $ic\nopb = $opb\norph = $orph\nund = $und\numall = $umall\nworld = $world\nnobody = $nobody\npdus = $pdus\ncc-by = $ccby\ncc-by-nd = $ccbynd\ncc-by-nc-nd = $ccbyncnd\ncc-by-nc = $ccbync\ncc-by-nc-sa = $ccbyncsa\ncc-by-sa = $ccbysa\n\n\n";
	}
    }
    print "count = $count\n";#pd = $pd\nic = $ic\nopb = $opb\norph = $orph\nund = $und\numall = $umall\nworld = $world\nnobody = $nobody\npdus = $pdus\ncc-by = $ccby\ncc-by-nd = $ccbynd\ncc-by-nc-nd = $ccbyncnd\ncc-by-nc = $ccbync\ncc-by-nc-sa = $ccbyncsa\ncc-by-sa = $ccbysa\n\n\n";
    
    exit 1;
}

#-----------------------------------------------------------------------------
