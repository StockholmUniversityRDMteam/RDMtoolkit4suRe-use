#!/bin/bash
# Latest update: 2025-09-15
# Provenance: Script for creating Zenodo itemFolders with bash
# cd Nextcloud/Forskningsdatagruppen/01_Arbetsmaterial/01_Hantera-och-lagra-data/04_Skordetroskan/reposit2fgsCSP/dryadHarvesTransform/dryadSUaffiliatesUpdateYYYYMMDDjson2xml(senaste)
#bash ../dryad3mvOrigMD.sh

MDlist=*MD.xml


MDcut=$(for m in $MDlist; do echo $m | cut -d'_' -f 1; done)

echo $MDcut

dirList=$(for i in $MDcut; do echo $i | mkdir -p $i/data; done)


#-------------------------------------------------
# This part of the script is for moving $itemSplits created by the dryad2splitUpdateFile.xq  to their new $itemFolds for further processing
  
for f in $MDcut; do mv ${f}*MD.xml ./${f}/; done

#To check that *OriginalMD.xml files have been properly moved to corresponding folder:

ls -R

#----------------Edited selection from MADIArkDryad5DataCheXpand---------------------------------------------------
DL="dryad\.*"

Y=$(echo $DL)
    
for i in $Y ; do  echo $i; cd $i;

#Copy schemas to each package directory
#Location: Nextcloud//reposit2fgsCSP/dryadHarvesTransform/schemas/
#NO! Doing that now will create problem in dryad4extractFileInfo.xq, which requires /data/ to be the
#unique subfolder/directory in the main package folder. Getting the schemas folder should be done in
#MADIArkDryad5mv-dataCheXpand
  
#cp -r ../../schemas .

#Add parameter doc filext2mimetypeMapMAIN.xml to each package directory
#Location: Nextcloud//reposit2fgsCSP/filext2mimetypeMapMAIN.xml 
cp -r ../../../filext2mimetypeMapMAIN.xml .

cd ..

done
#-------------------------------------------------------------------
current=$(date +"%Y%m%d")

cd ..

cp -r dryadSUaffiliatesUpdate${current}json2xml /q/MADIArkiv/dryadHarvesTransform/

#cd /q/MADIArkiv/dryadHarvesTransform/  - does not work inside the script!?   

read -p "This should have copied the new dryadSUaffiliatesUpdateYYYYMMDDjson2xml
with its data subfolder to MADIArkiv/dataverseHarvesTransform. 
Leave BASH open as is now, but Go to Oxygen to confirm!"  
