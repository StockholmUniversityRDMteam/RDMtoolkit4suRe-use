#!/bin/bash
# Scriptest for Dataverse 2025-12-11
# Prel: cd //dataverseHarvesTransform
#----------------------------------------


#manual path to target folder e.g.:  
#cd /m/MADIDrop/dataverseHarvesTransform/dataDDIMDharvest20250820/

DL="??????"

Y=$(echo $DL)
    
for i in $Y ; do  echo $i 

cd $i/data

#Single example. Your own $API_TOKEN (uuid) when logged in Dataverse you will find at
#https://dataverse.harvard.edu/dataverseuser.xhtml?selectTab=apiTokenTab . Then do e.g.
#curl -L -O -J -H "X-Dataverse-key:$API_TOKEN" https://dataverse.harvard.edu/api/access/dataset/:persistentId/?persistentId=doi:10.7910/DVN/7RY1T9

curl -L -O -J -H "X-Dataverse-key:$API_TOKEN" https://dataverse.harvard.edu/api/access/dataset/:persistentId/?persistentId=doi:10.7910/DVN/$i

unzip dataverse_files.zip

rm dataverse_files.zip

cd ..

cd ..

done

#---
