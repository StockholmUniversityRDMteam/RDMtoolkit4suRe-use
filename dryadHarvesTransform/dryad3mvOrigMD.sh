#!/bin/bash
# Latest update: 2024-09-05
# Provenance: Script for creating Zenodo itemFolders with bash 

MDlist=*MD.xml

###--- Pieces of development history; trial and error ---
##furlRaw=$(for f in MDlist; do grep -r versions/ $f | cut -d '>' -f 2 | cut -d '<' -f -1; done)
##//dryadHarvesTransform/dryadPages20220803json2xml/dryadSUaffiliatesPage17feed20220803pacs
##$ for f in $MDlist; do grep -r versions/ $f | cut -d '>' -f 2 | cut -d '<' -f 1; done
##/api/v2/versions/88094
##/api/v2/versions/147709

## $ for i in $furlRaw; do echo https://datadryad.org$i/files; done
## https://datadryad.org/api/v2/versions/88094/files
## https://datadryad.org/api/v2/versions/147709/files

## $ fURL=$(for i in $furlRaw; do echo https://datadryad.org$i/files; done)

## $ for f in $MDlist; do grep -r versions/ $f | cut -d '>' -f 2 | cut -d '<' -f 1 | cut -d '/' -f 5; done
## 88094
## 147709

## $ fName=$(for f in $MDlist; do grep -r versions/ $f | cut -d '>' -f 2 | cut -d '<' -f 1 | cut -d '/' -f 5; done)

## $ for i in $fName; do curl -G https://datadryad.org/api/v2/versions/${i}/files > $i'_fileMD.json'; done

## SUCCESS! Produces the two files 88094_fileMD.json 147709_fileMD.json in correct folder

## $ fileMDlist=*fileMD*
## After conversion:
## $ echo $fileMDlist
## 147709_fileMD.json 147709_fileMD.xml 88094_fileMD.json 88094_fileMD.xml

## $ for f in *fileMD.xml; do grep %2F $f | cut -d 'F' -f 2 | cut -d '<' -f 1 |uniq ; done
## dryad.jm63xsjc3
## dryad.gqnk98sjd

MDcut=$(for m in $MDlist; do echo $m | cut -d'_' -f 1; done)

echo $MDcut

dirList=$(for i in $MDcut; do echo $i | mkdir -p $i/data; done)


#-------------------------------------------------
# This part of the script is for moving $itemSplits created in the extract*FileInfo.xq to their new $itemFolds for further processing
  
for f in $MDcut; do mv ${f}*MD.xml ./${f}/; done

#To check that *OriginalMD.xml files have been properly moved to corresponding folder:

ls -R

#-------------------------------------------------------------------

##URL=https://datadryad.org/api/v2/datasets/doi%3A 


##url=$(for i in $MDlist; do grep -r /download $i | cut -d '>' -f 2 | cut -d '<' -f 1; done)

 
##//dryadHarvesTransform/dryadPages20220803json2xml/dryadSUaffiliatesPage17feed20220803pacs
##$ for u in $url; do echo "https://datadryad.org"$u; done
##https://datadryad.org/api/v2/datasets/doi%3A10.5061%2Fdryad.gqnk98sjd/download
##https://datadryad.org/api/v2/datasets/doi%3A10.5061%2Fdryad.jm63xsjc3/download
 
#>curl -G ${url} > dryadSUaffiliatesPage${p}-api${current}.json
      
#>done  
