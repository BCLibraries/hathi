# Get MARC Records From Hathi OAI

The first step is to get Hathi MARC records for volumes that are public domain in the US (pdus) from the Hathi OAI feed.

- [OAI feed documentation](https://www.hathitrust.org/data)
- Use the from and until arguments to harvest only those records that were created, deleted, or modified within a specified date range. 
- If you are doing a complete reload, omit the from argument or use the [identify](http://quod.lib.umich.edu/cgi/o/oai/oai?verb=Identify) verb to find the date stamp of the earliest record.
- Example Record Set:  
http://quod.lib.umich.edu/cgi/o/oai/oai?verb=ListRecords&metadataPrefix=marc21&set=hathitrust&from=2016-08-01&until=2016-08-31

# Use HathiFiles to Enhance OAI MARC Records

- Replace OAI title with HathiFiles title
- Use Gov Docs flag in HathiFiles to add flag compatible with our local practice


# Get HathiTrust Record Numbers from OAI files

- Run extractIdentifiers.xsl on all oai xml files  
```
java -jar C:\Users\mckelvee\Desktop\Migration\saxon\saxon9he.jar -o OAI-ID.txt OAI.xml extractIdentifiers.xsl
```
- Sort and concatenate the results in a single file  
```
    cat *.txt | sort > all-OAI-Ids)
```

# Use Sorted IDs to Create Lookup from HathiFiles

Obtain the most recent full (cumulative) version of the HathiFiles  
```
C:\Users\mckelvee\Documents\Hathi_Primo\test_run>java -jar parseHathiFiles.jar hathi_full_20160901.txt IdToTitle all-OAI-Ids
```

    where
    raw hathifiles file -> hathi_full_20160901.txt
    lookup output file -> IdToTitle
    IDs to limit lookup to -> all-OAI-Ids
    (lookup will also ignore any ID that it doesn't find in hathifiles)
    (to do : remove  $h[microform] $h[electronic resource]) [This stuff in green is Brain’s note to self, but it is probably arleady taken care of)

- The result file includes 3 data elements, HT Record Number, HathiFiles Title, Gov Docs flag
- Sort the results  
```
sort IdToTitle > IdToTitleSorted
```

# Extra:  Brian's Steps for Huge Years

    java -jar c:\dev\saxon6-5-5\saxon.jar -o 2011_id/2011_a 2011/2011_a extractIdentifiers.xsl
    java -jar c:\dev\saxon6-5-5\saxon.jar -o 2011_id/2011_b 2011/2011_b extractIdentifiers.xsl
    java -jar c:\dev\saxon6-5-5\saxon.jar -o 2011_id/2011_c 2011/2011_c extractIdentifiers.xsl
    java -jar c:\dev\saxon6-5-5\saxon.jar -o 2011_id/2011_d 2011/2011_d extractIdentifiers.xsl
    cat/sort files
    
    java -jar parseHathiFiles.jar hathi_full_20130101.txt 2011_id\2011_a\2011_a_IdToTitle 2011_id\2011_a\all2011_a_Ids
    java -jar parseHathiFiles.jar hathi_full_20130101.txt 2011_id\2011_b\2011_b_IdToTitle 2011_id\2011_b\all2011_b_Ids
    java -jar parseHathiFiles.jar hathi_full_20130101.txt 2011_id\2011_c\2011_c_IdToTitle 2011_id\2011_c\all2011_c_Ids
    java -jar parseHathiFiles.jar hathi_full_20130101.txt 2011_id\2011_d\2011_d_IdToTitle 2011_id\2011_d\all2011_d_Ids

# Extra:  Rights Statistics

- parseHathiFiles.pl will generate counts of the access and rights elements values in a HathiFile (for curious minds)

# Create Title Lookup XML file

- Create title look up file:  
```
createTitleLookUp.pl  IdToTitleSorted (output will be titleMerge.xml)
```

# Merge Title Look up file with OAI feed

- `java -jar C:\Users\mckelvee\Desktop\Migration\saxon\saxon9he.jar -o merged.xml OAI.xml mergeHathiFiles.xsl`
- Note: modify xslt so that doc lookup title has the same name as the lookup xml file you created)  

# Split Original OAI into Delete and Load Files

- extractDeletions.xsl
- extractIdentifiers.xsl


# post.jar?

Something to do with loading records to PRIMO?

