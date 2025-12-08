#!/bin/bash
# Script for getting & creating head feed-directories for Dryad API pages
# and downloading JSON "feeds" by automated curl 
# Latest update: 2025-12-03 Previous: 2025-09-04 2024-07-25 | 20231018 | 2022-08-18 

#NR=$(for p in $pageNr; do if [ $p -lt 10 ]; then echo "0$p"; else echo "$p"; fi; done)  

#URL=https://datadryad.org/api/v2/search?affiliation=https%3A%2F%2Fror.org%2F05f0yaq80&per_page=100

#current=$(date -I)

##mkdir dryadPages"$current"jsonOriginals


##cd dryadPages"$current"jsonOriginals

##echo $URL 

##echo $NR

##touch dryadSUaffiliatesPage1-api${current}.json

##URL="https://datadryad.org/api/v2/search?affiliation=https%3A%2F%2Fror.org%2F05f0yaq80&per_page=100"


##curl -G ${URL} > dryadSUaffiliatesPage1-api${current}.json

#to get content for page1 moved from top def $pageNr here: 
##pageNr=$(seq 2 5)

##for p in $pageNr
#>do
##do
#>url=$"$URL"\&page=$p
##pURL=https://datadryad.org/api/v2/search?affiliation=https%3A%2F%2Fror.org%2F05f0yaq80
##purl=$"$pURL"\&page=$p\&per_page=100 

##echo $purl 

##curl -G ${purl} > dryadSUaffiliatesPage${p}-api${current}.json      

##done       
## Please NOTE: URLs must be WITHOUT " " to work in script with automated curl!
#curl -G ${URL} >> dryadPage${NR}pacs/*.json
#--------------New from 2025-12-03:-----------------
##cd ..

current=$(date +"%Y%m%d")

#URL=https://datadryad.org/api/v2/search?affiliation=https://ror.org/05f0yaq80&modifiedSince=2025-09-04T00:00:0Z
URL=$(head -7 0dryadUpdateList.txt | tail -1 )

echo $URL

mkdir dryadSUaffiliatesUpdate${current}json2xml

cd dryadSUaffiliatesUpdate${current}json2xml

touch dryadSUaffiliatesUpdate${current}.json

curl -G ${URL} >> dryadSUaffiliatesUpdate${current}.json
