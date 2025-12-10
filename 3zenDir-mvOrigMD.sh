#!/bin/bash
# Script for creating itemFolders with bash (instead of eZFI.xq)
# Prel: first go to relevant feedNRpacs folder where NR=01-99, i.e.
# cd to $fileParent in eZFI.xq, where there should already be a file_info.xml
# file after the item split, first 
# fixing a well-formed file_info.xml > file_infoFeed${NR}.xml 

#NR=zenSUBfeed{NR}

#current=$(date +"%Y-%m-%d")

#sed -i '1s;^;<file_infoFeed nr="'$NR'" prodate="'$current'">\n;' file_info.xml

#echo "</file_infoFeed>" >> file_info.xml 
 
#mv file_info.xml > file_infoFeed"$NR"v0-995prod"$untilDate".xml





# NOTE! This script will not work properly if some filenames are just "subsets" or "substrings" 
#of others, as in Bolin DB e.g. "BURGOS-2020_originalMD.xml" and "BURGOS-2020-ESM_originalMD.xml".
#To make both directories and files unique, and have files moved to their 
#new unique folder, add e.g. "-0", to the shorter "substring" filename before 
#running the script, e.g. "BURGOS-2020_originalMD.xml" > "BURGOS-2020-0_originalMD.xml"  


MDlist=*MD.xml

MDcut=$(for m in $MDlist; do echo $m | cut -d'_' -f 1; done)

echo $MDcut

dirList=$(for i in $MDcut; do echo $i | mkdir $i; done)


#-------------------------------------------------
# This part of the script is for moving $itemSplits created in the extract*FileInfo.xq to their new $itemFolds for further processing
  
for f in $MDcut; do mv ${f}*MD.xml ./${f}/ ; done

for j in $MDcut; do cp -r ../schemas ./${j}/ ; done   

#To check that *OriginalMD.xml files have been properly moved to corresponding folder:

ls -R

#-------------------------------------------------------------------

