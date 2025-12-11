#!/bin/bash
# Script to be used after $itemSplit (in eFFI.xq) for creating itemFolders  with bash (instead of eFFI.xq)
# Prel: cd //figsHarvestTransform
#----------------------------------------

NR=$(head -6 0figsFeedsURLnrList.txt | tail -1 | cut -d '=' -f 1 | cut -d 'l' -f 2)

current=$(date +"%Y-%m-%d")

cd figs*"$NR"pacs  # = $fileParent in eFFI.xq

sed -i '1s;^;<file_infoFeed nr="'$NR'" prodate="'$current'">\n;' file_info.xml

echo "</file_infoFeed>" >> file_info.xml 
 
mv file_info.xml file_infoFeed"$NR"v0-9999prod"$current".xml

#----------------------------------------
# This part of the script is for moving $itemSplits created in the extract*FileInfo.xq to their new $itemFolds for further processing
 
cd figs*"$NR"pacs

MDlist=*MD.xml

MDcut=$(for m in $MDlist; do echo $m | cut -d'_' -f 1; done)

echo $MDcut

dirList=$(for i in $MDcut; do echo $i | mkdir $i; done)

for f in $MDcut; do mv ${f}*MD.xml ./${f}/; done

for j in $MDcut; do cp -r ../schemas ./${j}/ ; done

#Add parameter doc filext2mimetypeMapMAIN.xml to current directory
for m in $MDcut; do cp -r ../../filext2mimetypeMapMAIN.xml ./${m}/ ; done   

#To check that *OriginalMD.xml files have been properly moved to corresponding folder:

ls -R
