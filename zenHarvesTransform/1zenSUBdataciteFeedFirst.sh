#!/bin/bash
# Script for getting & creating head feed-directory for zenSUBdataciteFeeds
# and downloading pending feed with automated curl
# Latest update: 2025-11-20  

NR=$(head -6 0zenSUBfeedURLnrList.txt | tail -1 | cut -d '=' -f 1 | cut -d 'l' -f 2)

mkdir zenSUBdataCiteFeed"$NR"pacs

URL=$(head -7 0zenSUBfeedURLnrList.txt | tail -1 )

fromDate=$(echo ${URL:115})

untilDate=$(date +"%Y%m%d")
#untilDate=$(date -I)

fromPure=${fromDate//[-]/}

#untilPure=${untilDate//[-]/}

echo $URL 

echo $fromPure

echo $untilDate

echo $NR

touch zenSUBdataCiteFeed${NR}pacs/zenSUBfeed$NR-api${fromPure}until${untilDate}.xml

echo zenSUBdataCiteFeed${NR}pacs  #Alternative added 2021-06-30 
echo zenSUBdataCiteFeed$NR-api${fromPure}until${untilDate}.xml


## Please NOTE: pending url in 0zenSUBfeedURLnrList must be WITHOUT " " to work in amended script with automated curl!

curl -G ${URL} >> zenSUBdataCiteFeed${NR}pacs/*.xml
#-------------------------------------------------
