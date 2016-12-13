#!/usr/bin/sh

OAIFILES="../oai_harvester/harvested/*.xml"
OUTDIR="enhanced"
HATHIFILES="https://www.hathitrust.org/filebrowser/download/159922"

# Get HathiTrust Record Numbers from OAI files
echo "Extracting record numbers"
for f in $OAIFILES
do
  name=$(basename $f .xml)
  saxon -o $OUTDIR/ids/$name.txt $f extractIdentifiers.xsl 
done

# Concatenate all IDs to single file and sort them
echo "Sorting all OAI IDs"
rm -f $OUTDIR/all-OAI-ids.txt
cat $OUTDIR/ids/*.txt | sort > $OUTDIR/all-OAI-ids.txt

# Get the latest Hathifiles
echo "Fetching the latest Hathifiles"
curl $HATHIFILES -o $OUTDIR/hathi_full.txt.gz

echo "Uncompressing Hathifiles"
gunzip $OUTDIR/hathi_full.txt.gz

# Create lookup from sorted IDs
echo "Creating lookup from HathiFiles"
java -jar parseHathiFiles.jar $OUTDIR/hathi_full.txt $OUTDIR/IdToTitle $OUTDIR/all-OAI-ids.txt

# Sort the results
echo "Sorting lookup"
sort $OUTDIR/IdToTitle > $OUTDIR/IdToTitleSorted

# Create title lookup file
echo "Creating title lookup file"
perl createTitleLookup.pl $OUTDIR/IdToTitleSorted
mv titleMerge.xml $OUTDIR/

# Merge titles into harvested record
for f in $OAIFILES 
  do name=$(basename $f .xml)
  echo "Processing $name..."
  saxon -o $OUTDIR/xml/$name $f mergeHathiFiles.xsl
  echo "done."
  mv $f /apps/hathitrust/oai_harvester/harvested/processed/
done
