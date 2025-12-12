The **zenHarvesTransform** folder has 5 scripts (BASH .sh, XQuery .xq and XSLT .xsl) + one 0-list .txt, numbered in their order of appearance / use.
- _0zenSUBfeedURLnrList.txt_ and _1zenSUBdataciteFeedFirst.sh_ work together by creating and downloading the latest package folder and xml metadata feed **zenSUBdataCiteFeed{NR}pacs/zenSUBdataCiteFeed{NR}-apiYYYYMMDDuntil{current}.xml**.
- In **BaseX** _2zenMiniSplit_ paste the whole path (in Oxygen use: _Copy Location_) of **zenSUBdataCiteFeed{NR}-apiYYYYMMDDuntil{current}.xml** on line 11 as `$mdFilePath`  value, and the abridged path to the **zenSUBdataCiteFeed{NR}pacs** on line 12 as `$path`. Run BaseX!
- Go back to GitBASH: `$ cd zenSUBdataCiteFeed{NR}pacs`  …  and run: `$ bash ../3zenDir-mvOrigMD.sh`!
- In **Oxygen** the folder _zenSUBdataCiteFeed{NR}pacs_ each package subfolder should now hold 2 subfolders: _data/_ (empty so far)  and _schemas/_ + 2 files: _filext2mimetypeMapMAIN.xml_ and *_originalMD.xml* ...
- In **Oxygen**, _Copy Location_ of the first package folder *_originalMD.xml* ; paste in **BaseX**  _4extractZenFileInfo.xq_, on line 42 as $mdFilePath (between the ” ”), and - only for first package - the shortened path to zenSUBdataCiteFeed{NR}pacs/ in $path  (line 43). Run BaseX (Ctrl+Enter).
- Check in **Oxygen**; in the same package folder there should now be a _file_info.xml_ and, in the subfolder _data/_, one or more datafile(s) of various file formats (e.g. .pdf, .csv, .zip etc). 
- Check in  _file_info.xml_ in particular file names, ORCID and ALERT=”None”. Save (Ctrl+S) and Close (Ctrl+W).
Transform the corresponding  *_originalMD.xml*, with _5zeno2fgs.xsl_, which should result in a valid **METS.xml**
Use XPath //file to check file names in OWNERID, MIMETYPE etc.





