#!/bin/bash
# Script for getting & creating head feed-directory for figsMETSfeedNRpacs
# and downloading pending feed with curl automated
# Latest update: 2024-07-01  

NR=$(head -6 0figsFeedsURLnrList.txt | tail -1 | cut -d '=' -f 1 | cut -d 'l' -f 2)

mkdir figsMETSfeed"$NR"pacs

URL=$(head -7 0figsFeedsURLnrList.txt | tail -1 )

fromDate=$(echo ${URL:96} | cut -d '&' -f 1)

untilDate=$(echo ${URL:97} | cut -d '=' -f 2 | cut -d '"' -f 1)

fromPure=${fromDate//[-]/}

untilPure=${untilDate//[-]/}

echo $URL 

echo $fromPure

echo $untilPure

echo $NR

touch figsMETSfeed${NR}pacs/figsMETSfeed$NR-api${fromPure}until${untilPure}.xml

echo figsMETSfeed${NR}pacs  #Alternative added 2021-06-30 
echo figsMETSfeed$NR-api${fromPure}until${untilPure}.xml

# No longer need to curl manually as the following example:   
# curl -G "https://api.figshare.com/v2/oai?verb=ListRecords&metadataPrefix=mets&set=portal_18&from=2021-03-21&until=2021-03-31" >> ##Alternative: figsMETSfeed${NR}pacs/*.xml

## Please NOTE: pending url in figsFeedsURLnrList must be WITHOUT " " to work in amended script with automated curl!

curl -G ${URL} >> figsMETSfeed${NR}pacs/*.xml
#-------------------------------------------------
