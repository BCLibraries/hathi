use FileHandle;

main();

#-----------------------------------------------------------------------------
sub main {
    
    my $count = 0;
    my ($file) = @ARGV;    

    my $fh = new FileHandle();
    $fh->open($file);  

    while( not($fh->eof()) ) {
	$count++;
	my $line = $fh->getline();
	my ($volume, $access, $rights, $umich, $enumeration, $source, $sourceID, $oclc, $isbn, $issn, $lccn, $title, $imprint, $rightscode, $update, $govdoc, $pubdate, $pubplace, $lang, $bibformat) = split(/\t/, $line);
	
	print "$umich\n";
	#if ($govdoc eq '1' ) {
	 #   print "$line\n";
	#}
    }
}

