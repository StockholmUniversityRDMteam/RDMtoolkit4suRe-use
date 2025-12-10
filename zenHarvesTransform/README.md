The **zenHarvesTransform** folder has 5 scripts (BASH .sh, XQuery .xq and XSLT .xsl) + one 0-list .txt, numbered in their order of appearance / use.
_0zenSUBfeedURLnrList.txt_ and _1zenSUBdataciteFeedFirst.sh_ work together by creating and downloading the latest package folder and xml metadata feed **zenSUBdataCiteFeed{NR}pacs/zenSUBdataCiteFeed{NR}-apiYYYYMMDDuntil{current}.xml**.
In **BaseX** _2zenMiniSplit_ paste the whole path (in Oxygen use: _Copy Location_) of **zenSUBdataCiteFeed{NR}-apiYYYYMMDDuntil{current}.xml** on line 42 as `$mdFilePath`  value, and the abridged path to the **zenSUBdataCiteFeed{NR}pacs** on line 43 as `$path` ... 



