#!/bin/bash
# Latest update: 2025-09-15 Script for getting md5.txt -> checkSums.xml, pulling in schemas 
#deprecated, done in dryad3mvOrigMD.sh: "and filext2mimetypeMapMAIN.xml document parameter"] in package,
# + replacing whitespace and '&' with _ in filenames after unzip of 'doi_*.zip' or filesDownload. For use in next step xslt dryad7DataCite2FGS.xsl 
#Origin: //dryadHarvesTransform/dryadPages2023-10-20/outputNewBatchConv/dryadSUaffiliatesPage1/dryad.2bvq83bms 

#manual path to current top folder holding subfolders to be processed:  
#cd /m/MADIArkiv/dryadHarvesTransform/dryadSUaffiliatesUpdateYYYYMMDDjson2xml

#Then to run this script:
#bash ../MADIArkDryad5

DL="dryad\.*"

Y=$(echo $DL)
    
for i in $Y ; do  echo $i; cd $i/data;

 
Z=$(find -name "doi_10_5061*") 
dX=$(echo $Z | wc -m)
if [ $dX -gt 10 ]

then  

D="doi_*.zip"

unzip $D

rm $D 

fi

#F=$(sed -n 's/.*FILENAMECOUNT\=\"\(.*\)/\1/p' file_info.xml | cut -d'"' -f 1)

F=$(find -name "filesDownload"| wc -m)

if [ $F -gt 3 ]
then
unzip filesDownload

rm filesDownload  
 
fi

filist="*.*"

for f in $filist ; do md5sum $f >> ../md5.txt; done

#for g in $filist ; do wc -c $g >> ../filesizes.txt; done

cd .. 

#Two levels less for processing in MADIArkiv:
cp -r ../../schemas .
#cp -r ../../../../schemas .

#Add parameter doc filext2mimetypeMapMAIN.xml to current directory - done earlier with Nextcloud/Forskningsdatagruppen/01_Arbetsmaterial/01_Hantera-och-lagra-data/04_Skordetroskan/reposit2fgsCSP/dryadHarvesTransform/dryad3mvOrigMD.sh
#Two levels less for processing in MADIArkiv:
#cp -r ../../filext2mimetypeMapMAIN.xml .

#Trying to make xml of md5.txt file. First try failed:
#filenames=$(for m in md5.txt; do echo $m | cut -d'*' -f 2; done) ...

#2nd try worked:
sed 's/*/<\/checksum><path>/' md5.txt | sed 's/ */<file><checksum>/' | sed 'a\</path></file>' > checkSums.xml

echo \</files\> >> checkSums.xml

sed -i '1s;^;<files>\n;' checkSums.xml

cd ..

done
#---------------------------------------
#From earlier version, moving datafiles, to datafolder, except for metadata xml-files:
#cd data
#find .. -type f ! -name "*.xml" -exec mv -f {} . \;
#ls
