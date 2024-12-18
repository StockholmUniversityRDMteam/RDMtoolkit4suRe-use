#!/bin/bash
# Latest update: 2024-12-03 Script for getting md5.txt -> checkSums.xml, pulling in schemas and filext2mimetypeMapMAIN.xml document parameter in package, for use in next step xslt dryad7DataCite2FGS.xsl 
#Origin: //dryadHarvesTransform/dryadPages2023-10-20/outputNewBatchConv/dryadSUaffiliatesPage1/dryad.2bvq83bms 

#manual path to top folder:  
#cd /m/MADIDrop/dryadHarvesTransform/dryadHarvesTransform/dryadPages20240725json2XMLoutputUA/dryadSUaffiliatesPage0test

DL="*"

Y=$(echo $DL)
    
#Z=$(find -name "doi_10_5061*")
#echo $Z
#./doi_10_5061_dryad_hhmgqnkcj__v20200228.zip

#echo $Z | wc -m
#45
#DX=$(echo $Z | wc -m)
#if [ $DX -gt 10 ] ; then  echo $(echo $Z | cut -d'/' -f 2 | unzip); fi
#rm $(echo $Z | cut -d'/' -f 2)
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

#cd data
#find .. -type f ! -name "*.xml" -exec mv -f {} . \;
#ls

# 
filist="*.*"
for f in $filist ; do md5sum $f >> ../md5.txt; done

#for g in $filist ; do wc -c $g >> ../filesizes.txt; done

#Later extract md5 checksums for each file and append to file_info.xml
#Possibly by XQuery https://docs.basex.org/wiki/File_Module#file:read-text-lines and file:append 

cd .. 

#One level less for processing in MADIDrop:
cp -r ../../../schemas .
#cp -r ../../../../schemas .

#Add parameter doc filext2mimetypeMapMAIN.xml to current directory
#One level less for processing in MADIDrop:
cp -r ../../../filext2mimetypeMapMAIN.xml .
#cp -r ../../../../filext2mimetypeMapMAIN.xml .


#Trying to make xml of md5.txt file. First try failed:
#filenames=$(for m in md5.txt; do echo $m | cut -d'*' -f 2; done) ...

#2nd try worked:
sed 's/*/<\/checksum><path>/' md5.txt | sed 's/ */<file><checksum>/' | sed 'a\</path></file>' > checkSums.xml

echo \</files\> >> checkSums.xml

sed -i '1s;^;<files>\n;' checkSums.xml

cd ..

done
#---------------------------------------

