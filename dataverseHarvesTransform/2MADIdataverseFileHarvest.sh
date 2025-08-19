#!/bin/bash
# Scriptest for Dataverse 2025-08-19
# Prel: cd //dataverseHarvesTransform
#----------------------------------------

##slugList=(07DCHE IITKTQ HPYDKW 0S2ITH MGZBAL VQW92D ILA0XI 7RY1T9 SI6TUS P7BPHE BAMCSI)
##current=$(date +"%Y-%m-%d")
##url=$(for u in $slugList; do echo
##"https://dataverse.harvard.edu/api/datasets/export?exporter=Datacite&persistentId=doi%3A10.7910/DVN/"$u
##curl -G $url > $u_originalMD.xml; done)
##Error result


#manual path to target folder e.g.:  
#cd /m/MADIDrop/dataverseHarvesTransform/dataDDIMDharvest20250820/

DL="??????"

Y=$(echo $DL)
    
for i in $Y ; do  echo $i 

cd $i/data

#Single example. Your own $API_TOKEN (uuid) when logged in Dataverse you will find at
#https://dataverse.harvard.edu/dataverseuser.xhtml?selectTab=apiTokenTab . Then do e.g.
#curl -L -O -J -H "$API_TOKEN" https://dataverse.harvard.edu/api/access/dataset/:persistentId/?persistentId=doi:10.7910/DVN/7RY1T9

curl -L -O -J -H "X-Dataverse-key:$API_TOKEN" https://dataverse.harvard.edu/api/access/dataset/:persistentId/?persistentId=doi:10.7910/DVN/$i

unzip dataverse_files.zip

rm dataverse_files.zip

cd ..

cd ..

done

#---
