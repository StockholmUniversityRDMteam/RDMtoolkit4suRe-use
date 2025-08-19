#!/bin/bash
# Script for Dataverse, latest update 2025-08-18
# Change to native API dataverse_json  > nativeMDfile_info.json, with better filemetadata 
#(incl. checksums md5 and sizes), handling of hierarchical, structured datadirectories 
# Prel: cd //dataverseHarvesTransform
#----------------------------------------

#To datestamp files or folders created, use as parameter in file- or foldername:
#current=$(date +"%Y-%m-%d")

##URL=https://dataverse.harvard.edu/api/datasets/export?exporter=Datacite&persistentId=doi:10.7910/DVN/

##example single file downloadURL  "https://dataverse.harvard.edu/file.xhtml?persistentId=doi:10.7910/DVN/BAMCSI/D91DBY"

## For better file metadata - use rather DDI as export format:
#"https://dataverse.harvard.edu/api/datasets/export?exporter=ddi&persistentId=doi:10.7910/DVN/MGZBAL"

#Nextcloud/Forskningsdatagruppen/01_Arbetsmaterial/01_Hantera-och-lagra-data/04_Skordetroskan/reposit2fgsCSP/dataverseHarvesTest
#GET metadata. This works:
#$ curl -G "https://dataverse.harvard.edu/api/datasets/export?exporter=ddi&persistentId=doi%3A10.7910/DVN/BAMCSI" > BAMCSI_originalMD.xml


#----------------------------------------
#cd Nextcloud/Forskningsdatagruppen/01_Arbetsmaterial/01_Hantera-och-lagra-data/04_Skordetroskan/reposit2fgsCSP/dataverseHarvesTransform

##1. steps:##
current=$(date +"%Y%m%d")

mkdir dataverseDDIharvest$current

cd dataverseDDIharvest$current

curl -G "https://dataverse.harvard.edu/api/dataverses/StockholmUniversityLibrary/contents" > SULcontents$current.json

read -p "Go to Oxygen and Format+Indent (Ctrl+Skift+P) the just created SULcontents.json file before
you press Enter to continue running this script. Also check whether there are any new items since
last harvesting date, e.g. with //publicationDate[contains(.,'2025-')] in the XPath of Oxygen. If no
new items - abort the operation in BASH without pressing Enter but Ctrl+C."

##PLEASE Note! Before next steps - Go to Oxygen and Format and Indent (Ctrl+Skift+P) the just created SULcontents.json file!
##Otherwise you will only get the first item, and not the following results!
#Nextcloud/Forskningsdatagruppen/01_Arbetsmaterial/01_Hantera-och-lagra-data/04_Skordetroskan/reposit2fgsCSP/dataverseHarvesTransform/
#$ grep identifier SULcontents.json
#            "identifier": "DVN/BAMCSI",
#           "identifier": "DVN/P7BPHE",
#            "identifier": "DVN/SI6TUS",
#            "identifier": "DVN/MGZBAL",
#           "identifier": "DVN/7RY1T9",
#           "identifier": "DVN/ILA0XI",
#            "identifier": "DVN/VQW92D",
#            "identifier": "DVN/0S2ITH",
#            "identifier": "DVN/HPYDKW",
#            "identifier": "DVN/IITKTQ",
#            "identifier": "DVN/07DCHE",

#Nextcloud/Forskningsdatagruppen/01_Arbetsmaterial/01_Hantera-och-lagra-data/04_Skordetroskan/reposit2fgsCSP/dataverseHarvesTransform/dvnDDImetadataHarvest20250520
##2. steps##
idList=$(grep identifier SULcontents$current.json | cut -d / -f 2 | cut -d \" -f 1)
 
echo $idList
#result: BAMCSI P7BPHE SI6TUS MGZBAL 7RY1T9 ILA0XI VQW92D 0S2ITH HPYDKW IITKTQ 07DCHE

#baseURL=https://dataverse.harvard.edu/api/datasets/export?exporter=ddi&persistentId=doi%3A10.7910/DVN/
#THIS finally WORKED:
for i in $idList ; do curl -G "https://dataverse.harvard.edu/api/datasets/export?exporter=ddi&persistentId=doi%3A10.7910/DVN/$i" > "$i"_originalMD.xml ; done
  
for i in $idList ; do curl -G "https://dataverse.harvard.edu/api/datasets/export?exporter=dataverse_json&persistentId=doi%3A10.7910/DVN/$i" > "$i"_nativeMD.json ; done  
#----------------------------------
# From 2dataverse-mvOrigMD.sh
#Still in: Nextcloud/Forskningsdatagruppen/01_Arbetsmaterial/01_Hantera-och-lagra-data/04_Skordetroskan/reposit2fgsCSP/dataverseHarvesTransform/dataverseDDIharvest2025-08-13/  

MDlist=*MD.*

MDcut=$(for m in $MDlist; do echo $m | cut -d'_' -f 1; done)

echo $MDcut

dirList=$(for i in $MDcut; do echo $i | mkdir -p $i/data; done)

# This part of the script is for moving _originalMD.xml files to their new $itemFolds for further processing
  
for f in $MDcut; do mv ${f}*MD.xml ./${f}/; done

for g in $MDcut; do mv ${g}*MD.json ./${g}/nativeMDfile_info.json; done

#To check that *OriginalMD.xml files have been properly moved to corresponding folder:

ls -R

#----------------------------------
#Shortscript from MADI3dataverseFileHarvest (only get schemas + filextMap into each package dir): 

#cd Nextcloud/Forskningsdatagruppen/01_Arbetsmaterial/01_Hantera-och-lagra-data/04_Skordetroskan/reposit2fgsCSP/dataverseHarvesTransform/dataverseDDIharvest20250818/
#To get only the list of directories, NOT the single file SULcontents.json, we define the
#DirectoryList as 
DL="??????"

Y=$(echo $DL)

for i in $Y ; do  echo $i

cd $i 

cp -r ../../schemas . 

cp -r ../../../filext2mimetypeMapMAIN.xml .

cd ..

done

cd ..

cp -r dataverseDDIharvest$current /m/MADIArkiv/dataverseHarvesTransform/

read -p "This should have copied the entire new dataverseDDIharvest$current with all its subfolder contents to
MADIArkiv/dataverseHarvesTransform. Go to Oxygen to confirm and then in BASH perform the next 
2MADIdataverseFileHarvest-script in order to fetch the actual datafiles."

