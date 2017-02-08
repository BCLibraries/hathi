### Get MARC Records From Hathi OAI

The first step is to get Hathi MARC records for volumes that are public domain or opened by a rights holder from the Hathi OAI feed.

- Use the [BCLibraries oai_harvester](https://github.com/BCLibraries/oai_harvester) scripts
- [OAI feed documentation](https://www.hathitrust.org/data)
- Use the from and until arguments to harvest only those records that were created, deleted, or modified within a specified date range. 
- If you are doing a complete reload, omit the from argument or use the [identify](http://quod.lib.umich.edu/cgi/o/oai/oai?verb=Identify) verb to find the date stamp of the earliest record.
- Example Record Set:  
http://quod.lib.umich.edu/cgi/o/oai/oai?verb=ListRecords&metadataPrefix=marc21&set=hathitrust&from=2016-08-01&until=2016-08-31

### Use HathiFiles to Enhance OAI MARC Records

OAI Marc Records don't include the MARC 245 subfield P or a govdocs indicator. Use the hathifiles metadata to add it (matching against hathitrust record number extracted in previous step).

#### Retrieve the [latest hathifile](https://www.hathitrust.org/hathifiles)

```sh
OUTDIR="output"
curl https://www.hathitrust.org/filebrowser/download/177119 -o $OUTDIR/hathi_full.txt.gz
gunzip $OUTDIR/hathi_full.txt.gz
```

#### Get HathiTrust Record Numbers from OAI harvest

```sh
OAIFILES="../oai_harvester/harvested/to-process/*.xml"
echo "Extracting record numbers..."
for f in $OAIFILES
do
  name=$(basename $f .xml)
  saxon -o $OUTDIR/ids/$name.txt $f extractIdentifiers.xsl
done
echo "Sorting..."
sort $OUTDIR/ids/*.txt  -o $OUTDIR/all-OAI-ids.txt
```
#### Use Hathitrust record IDs to create ID/title lookup from HathiFiles

- The result file includes 3 data elements, HT Record Number, HathiFiles Title, Gov Docs flag

```sh
java -jar parseHathiFiles.jar $OUTDIR/hathi_full.txt $OUTDIR/IdToTitle $OUTDIR/all-OAI-ids.txt
sort $OUTDIR/IdToTitle -o $OUTDIR/IdToTitleSorted
perl TitleLookup.pl $OUTDIR/IdToTitleSorted
```

### Merge titles in harvested records
```sh
for f in $OAIFILES
  do name=$(basename $f .xml)
  echo "Processing $name..."
  saxon -o $OUTDIR/xml/$name.xml $f mergeHathiFiles.xsl
  echo "done."
done
```

### Compress files and copy to bonnet for harvesting
```sh
tar -cvfz hathi_enhanced_2017-02-07.tar.gz $OUTDIR/xml/*.xml
scp hathi_enhanced_2017-02-07.tar.gz exlibris@bonnnet.bc.edu:primo/hathitrust/
```
