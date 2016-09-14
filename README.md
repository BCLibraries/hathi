# Requirements

- [Saxon](http://saxon.sourceforge.net/)

# Get MARC Records From Hathi OAI

The first step is to get Hathi MARC records for volumes that are public domain in the US (pdus) from the Hathi OAI feed.

- Use the [BCLibraries oai_harvester](https://github.com/BCLibraries/oai_harvester) scripts
- [OAI feed documentation](https://www.hathitrust.org/data)
- Use the from and until arguments to harvest only those records that were created, deleted, or modified within a specified date range. 
- If you are doing a complete reload, omit the from argument or use the [identify](http://quod.lib.umich.edu/cgi/o/oai/oai?verb=Identify) verb to find the date stamp of the earliest record.
- Example Record Set:  
http://quod.lib.umich.edu/cgi/o/oai/oai?verb=ListRecords&metadataPrefix=marc21&set=hathitrust&from=2016-08-01&until=2016-08-31

# Use HathiFiles to Enhance OAI MARC Records

- Edit enhance.sh to point to the latest verison of HATHIFILES
- Run enhance.sh

## Extra:  Brian's Steps for Huge Years

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

# Merge Title Look up file with OAI feed

- `java -jar C:\Users\mckelvee\Desktop\Migration\saxon\saxon9he.jar -o merged.xml OAI.xml mergeHathiFiles.xsl`
- Note: modify xslt so that doc lookup title has the same name as the lookup xml file you created)  

# Split Original OAI into Delete and Load Files

- extractDeletions.xsl
- extractIdentifiers.xsl


# post.jar?

Something to do with loading records to PRIMO?

