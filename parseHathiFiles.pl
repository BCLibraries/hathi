#!/usr/bin/perl -w
   
use strict;
use FileHandle;
use Switch;
use File::Copy;


main();

my (%pdv,%pdusv,%pdworldv);
my (%pdu,%pdusu,%pdworldu);
#-----------------------------------------------------------------------------
sub main {
    
    my ($count, $allow, $deny,$pd,$ic,$op,$orph,$und,$umall,$icworld,$nobody,$pdus,$ccby30,$ccbynd30,$ccbyncnd30,$ccbync30,$ccbyncsa30,$ccbysa30,$orphcand,$cczero,$undworld,$icus,$ccby40,$ccbynd40,$ccbyncnd40,$ccbync40,$ccbyncsa40,$ccbysa40)
    = (0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
    my ($file) = @ARGV;
	   
    my $fh = new FileHandle();
    $fh->open($file);
    
    while( not($fh->eof()) )
    {
	$count++;
	my $line = $fh->getline();
	my ($volume, $access, $rights, $umich, $enumeration, $source, $sourceID, $oclc, $isbn, $issn, $lccn, $title, $imprint, $rightscode, $update, $govdoc, $pubdate, $pubplace, $lang, $bibformat) = split(/\t/, $line);

	$rights =~ s/\-//gx;
	$rights =~ s/\.//gx;

	switch($access) {
	    case "allow" {$allow++;}
	    case "deny" {$deny++;}
	}
	switch($rights) {
            case "pd" {$pd++;}
            case "ic" {$ic++;}
	    case "op" {$op++;}
	    case "orph" {$orph++;}
	    case "und" {$und++;}
	    case "umall" {$umall++;}
	    case "icworld" {$icworld++;}
	    case "nobody" {$nobody++;}
	    case "pdus" {$pdus++;}
	    case "ccby30" {$ccby30++;}
	    case "ccbynd30" {$ccbynd30++;}
	    case "ccbyncnd30" {$ccbyncnd30++;}
	    case "ccbync30" {$ccbync30++;}
	    case "ccbyncsa30" {$ccbyncsa30++;}
	    case "ccbysa30" {$ccbysa30++;}
	    case "orphcand" {$orphcand++;}
	    case "cczero" {$cczero++;}
	    case "undworld" {$undworld++;}
	    case "icus" {$icus++;}
	    case "ccby40" {$ccby40++;}
	    case "ccbynd40" {$ccbynd40++;}
	    case "ccbyncnd40" {$ccbyncnd40++;}
	    case "ccbync40" {$ccbync40++;}
	    case "ccbyncsa40" {$ccbyncsa40++;}
	    case "ccbysa40" {$ccbysa40++;}
	}
	
	if ($access eq 'deny' and $rights eq 'pd') {
	    print "$umich is in pd but listed as deny access\n";	    
	}
	if ($count % 100000 == 0) {
	   print "count = $count\n"; #pd = $pd\nic = $ic	\nop = $op\norph = $orph\nund = $und\numall = $umall\nicworld = $icworld\nnobody = $nobody\npdus = $pdus\nccby30 = $ccby30\nccbynd30 = $ccbynd30\nccbyncnd30 = $ccbyncnd30\nccbync30 = $ccbync30\nccbyncsa30 = $ccbyncsa30\nccbysa30 = $ccbysa30\norphcand = $orphcand\ncczero = $cczero\nundworld = $undworld\nicus = $icus\nccby40 = $ccby40\nccbynd40 = $ccbynd40\nccbyncnd40 = $ccbyncnd40\nccbync40 = $ccbync40\nccbyncsa40 = $ccbyncsa40\nccbysa40 = $ccbysa40\n\n\n";
   	}
    }
 
    print "count = $count\n";
    print "allow = $allow\n";
    print "deny =  $deny\n";
    print "pd = $pd\nic = $ic\nop = $op\norph = $orph\nund = $und\numall = $umall\nicworld = $icworld\nnobody = $nobody\npdus = $pdus\nccby30 = $ccby30\nccbynd30 = $ccbynd30\nccbyncnd30 = $ccbyncnd30\nccbync30 = $ccbync30\nccbyncsa30 = $ccbyncsa30\nccbysa30 = $ccbysa30\norphcand = $orphcand\ncczero = $cczero\nundworld = $undworld\nicus = $icus\nccby40 = $ccby40\nccbynd40 = $ccbynd40\nccbyncnd40 = $ccbyncnd40\nccbync40 = $ccbync40\nccbyncsa40 = $ccbyncsa40\nccbysa40 = $ccbysa40\n\n\n";
    
    exit 1;
}

#-----------------------------------------------------------------------------
