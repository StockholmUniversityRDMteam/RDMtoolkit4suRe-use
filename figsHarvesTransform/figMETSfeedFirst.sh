#!/bin/bash
# Script for retrieving pending feed with curl from figsFeedsURLnrList.txt
# Latest update: 2024-02-19  

NR=$(head -6 figsFeedsURLnrList.txt | tail -1 | cut -d '=' -f 1 | cut -d 'l' -f 2)

mkdir figsMETSfeed"$NR"pacs

URL=$(head -7 figsFeedsURLnrList.txt | tail -1 )

fromDate=$(echo ${URL:96} | cut -d '&' -f 1)

untilDate=$(echo ${URL:97} | cut -d '=' -f 2 | cut -d '"' -f 1)

fromPure=${fromDate//[-]/}

untilPure=${untilDate//[-]/}

echo $URL 

echo $fromPure

echo $untilPure

echo $NR

touch figsMETSfeed${NR}pacs/figsMETSfeed$NR-api${fromPure}until${untilPure}.xml

echo figsMETSfeed${NR}pacs
echo figsMETSfeed$NR-api${fromPure}until${untilPure}.xml

# Please NOTE: pending url in figsFeedsURLnrList.xsl must be WITHOUT " " to work with automated curl!

curl -G ${URL} >> figsMETSfeed${NR}pacs/*.xml
