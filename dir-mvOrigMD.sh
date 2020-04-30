#!/bin/bash
# Script for creating itemFolders with bash (instead of eFFI.xq)
# Prel: first go to relevant figsMETSfeedNRpacs folder where NR=01-99 with:
# $ cd desktop/FeedsFile_info/figsMETSfeedNRpacs, that is to local  $fileParent in eFFI.xq


MDlist=*MD.xml

MDcut=$(for m in $MDlist; do echo $m | cut -d'_' -f 1; done)

echo $MDcut

dirList=$(for i in $MDcut; do echo $i | mkdir $i; done)


#-------------------------------------------------
# This part of the script is for moving $itemSplits created in the eFFI.xq to their new $itemFolds for further processing
# Prep: cd $fileParent after performing $itemSplit and $itemFolds in 

folders=./*/

echo $folders

foldCut=$(for f in $folders; do echo $f | cut -d'/' -f 2; done)

echo $foldCut

for f in $foldCut; do mv $f*MD.xml ./$f*/; done

#To check that *OriginalMD.xml files have been properly moved to corresponding folder:

ls -R