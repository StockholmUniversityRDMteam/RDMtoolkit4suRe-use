(:This xq-file is for extracting Datadryad file metadata and datafiles.
The declared external variable $mdFilePath is your input file, the "dryad.*_originalMD"-item produced after splitting up of the Dryad-feed. It could be either downloaded and converted as an xml-file to a target directory (folder), which will then be your $fileParent, with the whole file path of its new location as $mdFilePath. Or it could be input directly as a URL(?). Here the input will be the file location of an individual record / item file.xml.

2025-12-03 *Current version 0.93: Further adjustments of $prefSUauthor and $prefSUauthORCiD, to make them unique, in case of multiple $prefSUauthor
2025-06-06 Version 0.92: Extensive changes in $prefSUauthor,$prefSUauthORCiD and $prefSUauthORCiDurl + dept-emails for $archivalInst to align with $prefSUauthor 
2025-05-27 Version 0.91: Changed first condition in $fetchFiles from  if ($y//total > 5 or $y//size > 1234567890) to: if ($y//total > 5 and $y//size < 823456790) after discovery that following else fallback works better for datasets with some large size files (while 1100MB appears to be some memory limit).
2025-02-27 Version 0.9:Introduced $resourceDOI and $relationType (in analogy with "2et4extractFigsFileInfo.xq") to allow for direct search of $prefSUauthorName/$archivalInst from file_info.xml
2025-01-09 Version 0.8: Introduced in $warning option to search for 	prefSUauthor and affiliation, when missing, in primary associated  journal article via $docMD//relatedWorks//identifier. 
2024-09-22 Version 0.7: Introduced $dataDir := for $f in file:		 		children($fileParent) return $f[file:is-dir($f)] to download datafiles directly to folder "data", avoiding moving large datafiles. ...
2024-07-16/19/22/31 Version 0.6: Extensive change in $z again and 		section 5. Fetch files to adapt to new structure in Dryad output and avoid download via html-source page. Also renamed former variable $path -> $parent to avoid confusion with inherent node $y//path. Further introduced alternative file download for items with more than 3 data files, to speed up processing and to be handled in next step (MADI)dryad6mv-dataCheXpand.sh in BASH script. Increased number of files described in file_info.xml to 100 by adding '/files?per_page=100' to $filesURL. Finally(2024-07-31) removed parenthesis in file-names with file:write-binary(concat($fileParent,replace(replace(replace(replace(replace(replace($f/path, ' ', '_'), 'å', 'a'), 'ä', 'a'), 'ö', 'o'),'\(',''),'\)','')).
Further, changed the archivalInst in $doc => file_info.xml to output only *one* instance of '468 Zoologiska institutionen' in case there are several authors with email @zoologi.su.se (as in dryad.5mkkwh72s).   
 
20240128 Version 0.5: Change in $z and section 5 Fetch files, since $y//path does not work when total number of files > 20 (?)   
20240118 Version 0.4: Change in $authors, $suAuthors, $prefSUauthorName, $pX etc. to get proper affiliation and ORCID; further added $archivalInst (using //email) for 'zoologi'. Limit to [1] of check string-length($prefSUauthORCiDurl[1]).   
20231023  Version 0.3: New *working* section 5: Fetch files
20220901 Version 0.2: substantial changes in $downloadFiles and $fetchFiles, added $filesURL,  amended $prefSUauthor et al. and adapted output $doc
20220719 Version 0.1 (based on extractZenFileInfo 0.5 with substantial changes...

In the present workflow, this xq-file has only  mode (ii), while for former mode (i), dryad3rdSplitFeeds.xq is used instead:

(i) First mode is only for splitting up a "feed" into separate item / record xml-files, corresponding to "$dataId_originalMD. ..

(ii) Second mode, then, creates the necessary file_info.xml supplementary metadata-file, to be used as a parameter in the subsequent zen2fgs.xsl transformation of each item ($dataId_originalMD) to a sip.xml compliant with FGS-CSPackage. As explained, this is also when the actual data files belonging to an item are fetched to the corresponding package subdirectory.:)

xquery version "3.0";
declare namespace xlink="http://www.w3.org/1999/xlink";
declare namespace datacite="http://datacite.org/schema/kernel-4";
declare namespace lazy="http://basex.org/modules/lazy";
declare namespace local="local";
declare namespace JSON="JSON";
(:declare namespace OAI-PMH="http://www.openarchives.org/OAI/2.0/";
declare namespace dc="http://purl.org/dc/elements/1.1/"; 

These namespace declarations might also be needed if xq is run outside BaseX: 
declare namespace file="http://expath.org/ns/file";
declare namespace fetch="http://basex.org/modules/fetch";
declare namespace html="http://www.w3.org/1999/xhtml";:)

declare variable $recursive := true(); 
declare variable $mdFilePath as xs:string? external := "file:/M:/MADIArkiv/dryadHarvesTransform/dryadSUaffiliatesUpdate20251203json2xml/dryad.s7h44j1mr/dryad.s7h44j1mr_originalMD.xml";
declare variable $parent as xs:string? external := "file:/M:/MADIArkiv/dryadHarvesTransform/dryadSUaffiliatesUpdate20251203json2xml";
let $fileParent := if (contains($mdFilePath,'file:/')) then file:parent($mdFilePath) else $parent
let $dataDir := for $f in file:children($fileParent) return $f[file:is-dir($f)]
(:let $dataDir := $fileParent/data :)
let $docMD := doc($mdFilePath)

(:--- 0. Splitting-up dryadFeeds: use dryad3rdSplitFeeds.xq --- :)

(:---------------------- 1. Preliminaries------------------:)

let $doi := for $x in $docMD/stash_X3a_datasets/identifier return substring-after($x,'doi:')
let $url := concat("https://datadryad.org/stash/dataset/doi:",$doi)
let $filesURL := for $f in $docMD//stash_X3a_version/href return concat("https://datadryad.org",$f,'/files?per_page=100')
let $filesURL2 := for $f in $docMD//stash_X3a_version/href return concat("https://datadryad.org",$f,'/files?page=2&amp;per_page=100')

let $jsonMD := html:parse(unparsed-text($filesURL))
(:let $jsonMD2 := if (doc($filesURL//total) > 100) then html:parse(unparsed-text(concat($filesURL,$filesURL2))) :)
let $json2xml :=  json:parse($jsonMD) 
for $y in ($json2xml)
let $downloadFiles := $y//stash_003afiles/_
let $jsonMD2 := if ($y//total > 100) then html:parse(unparsed-text($filesURL2)) else ()
let $json2xmlTwo := json:parse($jsonMD2)

(:Introduced 2025-02-27 in analogy with 2et4extractFigsFileInfo.xq:)
let $resourceDOI := for $i in $docMD//relatedWorks/array/identifierType  return if($i = 'DOI')  then $i/following-sibling::identifier else ()
let $relationType := for $i in $docMD//relatedWorks/array/relationship return if($i/following-sibling::identifier = $resourceDOI) then $i[$i/following-sibling::identifier = $resourceDOI] else () 

(:html:parse(unparsed-text($url))//ul[@class="c-file-group__list"]:)
let $z := distinct-values($y//path) (:$downloadFiles//@title:)

(:------- 2. Authors, suAuthorNames & identifiers------------ :)

let $authors := $docMD//authors
let $authorNames := for $a in $authors return concat($a//firstName,' ',$a//lastName)
let $authorCount := count($authorNames)
let $authORCiDs := for $i in $authors return $i//orcid 

let $suAuthors := for $u in $authors return if ($authors/child::array) then $u[//child::affiliation/text()='Stockholm University' or child::affiliationROR/text()='https://ror.org/05f0yaq80'] else $u[/child::affiliation/text()='Stockholm University' or child::affiliationROR/text()='https://ror.org/05f0yaq80']
(:NewTry:)let $prefSUauthor := for $p in $suAuthors return if ($p[child::orcid]) then $p[child::orcid][1] else ()(:if (not($p[child::orcid])) then $suAuthors[1]:) 
let $suAuthorNames := for $a in $suAuthors return concat($a//firstName,' ',$a//lastName)
(: -inlån från eZenFI deprecated:)

(:NewTry:) 
let $prefSUauthORCiD := for $p in $prefSUauthor[1] return if (exists($p[child::orcid])) then ($p/child::orcid)[1] else ()
let $prefSUauthORCiDurl := html:parse(unparsed-text(concat("https://pub.orcid.org/v2.1/search?q=%22", encode-for-uri(($suAuthorNames[1])),"%22")))//uri
 
let $prefSUauthorInvert := if (string-length($prefSUauthor[1]/lastName) > 2) then concat($prefSUauthor[1]/lastName,', ',$prefSUauthor[1]/firstName) else concat($suAuthors[1]/lastName,', ',$suAuthors[1]/firstName)  


let $pX := if ($prefSUauthORCiD) then $prefSUauthORCiD  else if (string-length($prefSUauthORCiD) < 1 and string-length($prefSUauthORCiDurl[1]) >1) then ($prefSUauthORCiDurl)  else 'None'
let $ORCount := count($pX) 

(:------ Files, folders and result doc: 'file_info.xml' ----------- :)

(:let $mimeTypes := for $t in $downloadURLs return fetch:content-type($t) :)
let $subFold := if (contains($mdFilePath,'https://')) then (file:create-dir(concat($parent,'subFold'))) else ()
let $manDLname := if (string-length($z[1]) = 0 )  then <manualFileName>Replace by manually downloaded filename!</manualFileName> else ()
let $manDLsize := if (string-length($z[1]) = 0 )  then  <manualFileSize>Replace by manually downloaded fileSize!</manualFileSize> else ()
let $manDLmd5 := if(string-length($z[1]) = 0 )  then <manualMD5>Replace by manually downloaded MD5!</manualMD5> else ()
let $warn := if  ($ORCount > 1) then ('ID-check!') else if (string-length($z[1]) = 0 ) then ('Manual file download!') else if ($y//count < $y//total) then ('Check files!') else if (string-length($prefSUauthorInvert) < 3) then concat('Check prefSUauthor and affiliation in: ',$docMD//relatedWorks//identifier) else ('None') 

let $doc := <file_info  DOI="{$doi}" pubDate="{$docMD//publicationDate}" created="{$docMD//publicationDate}" updated="{$docMD//lastModificationDate}"  fileInfo-harvestDate="{current-dateTime()}" SW-Agent_exDryadFIxq="{'v0.93'}" FILENAMECOUNT="{if(string-length($z[1]) = 0 )  then 0 else $y//total}" FILELIST="{if (string-length($z[1]) = 0 )  then 'external' else $z}"   prefSUauthorName="{$prefSUauthorInvert}" prefSUauthORCiD="{if ($pX = $prefSUauthORCiD) then concat('https://orcid.org/',$pX) else $pX}"  archivalInst="{if (exists($prefSUauthor/email [contains(.,'aces.su.se')])) then '485 Institutionen för miljövetenskap (ACES)' else if (exists($prefSUauthor/email [contains(.,'zoologi.su.se')])) then '468 Zoologiska institutionen' else if (exists($prefSUauthor/email [contains(.,'dbb.su.se')])) then '431 Institutionen för biokemi och biofysik (DBB)' else if (exists($prefSUauthor/email [contains(.,'natgeo.su.se')])) then '463 Institutionen för naturgeografi' else()}" ALERT="{$warn}" resourceDOI="{$resourceDOI}" relationType="{$relationType}">{$json2xml, $json2xmlTwo, $manDLname, $manDLsize, $manDLmd5 }</file_info>
 
(: archivalInst="{for $i in $docMD//email return if (substring-before(substring-after($i,'@'),'.su.se') = 'zoologi') then '468 Zoologiska institutionen' else ()}" :)

(:---- 3. Create item Folders: deprecated. 
Use Bash script:  "dryad4th-mvOrigMD.sh" --  :)

(:--- 4. Create file_info.xml - parameter file for xslt -- :)

let $result := file:append(if (contains($mdFilePath,'https:\/\/')) then ($subFold/file_info.xml) else (concat($fileParent,"/file_info.xml")), $doc)

(: ---- 5. Fetch data files of individual items ---- 

NB! Filename of zipfile must be without extension .zip, here below: 
'filesDownload':)
 

let $fetchFiles := if  ($y//total > 5 and $y//size < 823456790) 
then file:write-binary(concat($dataDir,'filesDownload'),fetch:binary(concat('https://datadryad.org',$docMD//stash_X3a_download/href)))

else for $f in $downloadFiles 
return  file:write-binary(concat($dataDir,replace(replace(replace(replace(replace(replace(replace(replace(replace($f/path,',',''),' ','_'),'å','a'),'ä','a'), 'ö', 'o'),'\(','_'),'\)',''),'&amp;',''),'__','_')), lazy:cache(fetch:binary(concat("https://datadryad.org",$f/path/preceding-sibling::__links/stash_003adownload/href))))

(: possible explanation for "405 Method Not Allowed": 
https://datadryad.org/api/v2/datasets/doi%3A10.5061%2Fdryad.xsj3tx9hx/download - browser response: "The dataset is too large for zip file generation. Please download each file individually." 
Then, go to concat('https://doi.org/',$doi) and download the whole package as doi_10_5061*.zip to the relevant data folder destination. :)
  
return $doc
