(:This is the public version xq-file  for extracting figshare filedata by means of the base API "https://api.figshare.com/v2/articles/" as a complement to the OAI-PMH-feeds in METS (base API - https://api.figshare.com/v2/oai?verb=ListRecords&metadataPrefix=mets), where these filedata are not as complete, lacking e.g. md5 CHECKSUMS and original filenames with extensions, from which MIMETYPE can be constructed in the transformation to FGS-CSPackage. [In an earlier version of this xq-file these filedata were instead extracted from the JSON-arrays inherent in the corresponding html-pages of the DOI:s found in the dc:identifier-elements of the OAI-PMH-feeds, but these were later also found to be incomplete, in particular for items with more than 10 associated datafiles.] 

The declared variable $mdFilePath is your input file, an individual item-file.xml 
(recommended) extracted from a Figshare OAI-PMH-feed, in METS format, or an entire feed of multiple items. It could be either downloaded as an xml-file, or input directly as a URL (edited for xml then, thus with '&amp;' replacing '&' etc.). 

The resulting "file_info" from running the xquery is not a wellformed xml-file yet; unless there is only one item in the input file $mdFilePath, a root-element must be added in a local xml-editor. But, since the subsequent transformation by means of the figMETS2fgs.xsl takes individual item-files as argument, it is recommended to split up the feeds into individual item xml-files, put them into individual folders/directories that will subsequently make up the SIP together with the (so far, manually) downloaded associated datafiles. These individual item metadata xml-files, if used one-by-one as $mdFilePath and with the end return argument $result as default here, will then through this xquery place the document file_info.xml in that same folder/directory, where it is used as parameter $file_info_data in the transformation of the original item metadata to FGS-CSPackage, the METS-based standard for Submission Information Packages (SIPs) of the Swedish National Archives.
If an external URL is used as argument for $mdFilePath, the end return argument should be $doc instead, and the result shown must be saved manually.     

Changes to the original version include:
20190319: Version 1.0 Public: Removed internal local user db SUKAT-URLs, while keeping variable names. Removed also creation of folders / directories for storage of files directly on local disc.

20190214: Version 0.9: - Added $itemFolds for creation of individual folders for each item in a feed, in which the split-up feed item's "file_info.xml" files should go. 
Added @ALERT $warn to notify about need for manual ID-check in 3 cases: 
i) when no sukatID is found (hence, affiliation of first author with Stockholm University is doubtful)
ii) multiple ORCiDs and/or iii) multiple sukatIDs for the first author were found.

20190115: Version 0.8: - Added $mimeTypes by means of fetch:content-type as an alternative replacing the construction of mimeTypes from file extensions in the figMETS2fgs.xsl transform file. Later tests proved these to be ambigous sometime, so will only be used as potential fallback in case of need. 

20190111 - Version 0.7: Refined firstAuthorNameInv to accomodate names with middle initial, thus having parts. Also introduced new variable $artId to adapt to API-input (instead of html-source), allowing for whole feeds with multiple items as $mdFilePath 

20180915 - Version 0.6: Added firstAuthorNameInv and $auth1id to output, removed $persID and dependent variable $jsonORCiD to be replaced by more stable $ORCiDuri in $auth1id, but also noted - later - some instances of double ORCiDs, either associated with the same individual, or from homonyms, different individuals with the same name. Also found better, more stable expresssion for $sukat_info and dependent $sukatInstitution. 

20180816 - Version 0.5: Replaced parsing-error problematic $sukatIdExt with $sukat_info temp. in output of $sukatID1. Also detected yet unexplained errors / missing values for $sukatInstititution.

20180720 - Version 0.4: Added $sukatID1 and $sukatInstitution in output. Made EMBARGODATE conditional to avoid empty values. 

20180718 - Version 0.3: Added @FILECOUNT and @EMBARGODATE in output. :)

xquery version "3.0";
declare namespace mets="http://www.loc.gov/METS/";
declare namespace xlink="http://www.w3.org/1999/xlink";
declare namespace dc="http://purl.org/dc/elements/1.1/";
declare namespace local="local";
declare variable $recursive := true(); 
declare variable $mdFilePath as xs:string? external := "file:/PLACEHOLDER_FOR_PATH_OF_LOCAL_FILE.xml";
(: Easy way of getting the value of $mdFilePath is to choose 'Copy Location' of the file to be used as argument from within an xml-editor such as Oxygen, and then paste it above, automatically properly formatted. :)
let $fileParent := if (contains($mdFilePath,'file:/')) then file:parent($mdFilePath) else ()
let $recordCount := count(doc($mdFilePath)//record)
let $artId := for $x in doc($mdFilePath)//dc:identifier return  substring-before(substring-after($x,'sthlmuni.'),'.')
for $u in $artId
let $url := concat("https://api.figshare.com/v2/articles/",$u)
let $jsonMD := html:parse(unparsed-text($url))
let $json2xml := json:parse($jsonMD)
for $y in ($json2xml)
let $z := $y//files//name
let $m := $y//files//download__url 
let $w :=  if ($y//embargo__date/@type='null') then 'None'  else $y//embargo__date
let $nameSplitCount := for $n in ($y//authors//full__name)[1] return count(tokenize($n,' '))
let $nameSplitF1 := tokenize(($y//authors//full__name)[1],' ')[1]
let $nameSplitL1 := if ($nameSplitCount = 2) then tokenize(($y//authors//full__name)[1],' ')[2] else if ($nameSplitCount = 3) then tokenize(($y//authors//full__name)[1],' ')[3] else ()
let $sukat_info := concat("localDB-URL",$nameSplitF1,$nameSplitL1)
let $sukatId := concat($sukat_info,"localDB-personID")
let $sukatIdExt := for $i in $sukatId return substring-after($i,$sukat_info)
let $sukatInstitution := "localDB-institution" 
let $instNrList := "localDB-institutionsnrURL"
let $instNr := for $i in $instNrList return (substring-before($i,$sukatInstitution)) 
let $ORCiDurl := html:parse(unparsed-text(concat("https://pub.orcid.org/v2.1/search?q=%22", encode-for-uri(($y//full__name)[1]),"%22")))//uri
let $ORCount := count($ORCiDurl)
let $suCount := count($sukatId) 
let $auth1id := if($ORCiDurl) then $ORCiDurl else if ($sukatIdExt) then $sukatIdExt else ''
let $mimeTypes := for $t in $m return fetch:content-type($t)
let $warn := if (not($sukatId) or ($ORCount > 1) or ($suCount > 1)) then ('ID-check!') else ('None') 
let $doc := <file_info cite="{$y//citation}" DOI="{$y//doi}" pubDate="{$y//published__date}" harvestDate="{current-dateTime()}" FILELIST="{$z}" FILENAMECOUNT="{count($z)}" EMBARGODATE="{$w}" firstAuthorNameInv="{$nameSplitL1}, {$nameSplitF1}" firstAuthORCiD="{$ORCiDurl}" sukatID="{$sukatIdExt}" sukatInst1="{$sukatInstitution}" sukatInst1nr="{$instNr}" ALERT="{$warn}">{$y//files, <mimeTypes>{$mimeTypes}</mimeTypes>}</file_info>

let $result := file:append((concat($fileParent,"/file_info.xml")), $doc)

return $result

