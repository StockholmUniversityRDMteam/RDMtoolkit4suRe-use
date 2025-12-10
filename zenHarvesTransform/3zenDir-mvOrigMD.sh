#!/bin/bash
# Script for creating itemFolders with bash (instead of eZFI.xq)
#Latest update: 2025-12-10
 
#NR=zenSUBfeedURL{NR}

#current=$(date +"%Y-%m-%d")

#sed -i '1s;^;<file_infoFeed nr="'$NR'" prodate="'$current'">\n;' file_info.xml

#echo "</file_infoFeed>" >> file_info.xml 
 
#mv file_info.xml > file_infoFeed"$NR"v0-995prod"$untilDate".xml

#cd zenSUBdataCiteFeed{NR}pacs 

MDlist=*MD.xml

MDcut=$(for m in $MDlist; do echo $m | cut -d'_' -f 1; done)

echo $MDcut

#dirList=$(for i in $MDcut; do echo $i | mkdir $i; done) - replaced by (from dryad4th-mvOrigMD.sh):
dirList=$(for i in $MDcut; do echo $i | mkdir -p $i/data; done)

#-------------------------------------------------
# This part of the script is for moving $itemSplits created in the extract*FileInfo.xq to their new $itemFolds for further processing
  
for f in $MDcut; do mv ${f}*MD.xml ./${f}/ ; done

for j in $MDcut; do cp -r ../schemas ./${j}/ ; done

for k in $MDcut; do cp -r ../../filext2mimetypeMapMAIN.xml ./${k}/ ; done   

#To check that *OriginalMD.xml files have been properly moved to corresponding folder:

ls -R

#-------------------------------------------------------------------

