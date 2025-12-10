(:This xq-file is for extracting Zenodo file metadata and datafiles, by means of the base API "https://zenodo.org/api/records/" or  alternatively https://zenodo.org/record/[record_number]/export/json as a complement to the OAI-PMH-feeds , where filedata are  lacking.
The declared external variable $mdFilePath is your input file, the "_originalMD"-item produced after splitting up of the OAI-PMH-feed in DataCite format e.g.  by "https://zenodo.org/oai2d?verb=ListRecords&metadataPrefix=datacite&set=user-stockholmuniversitylibrary". It could be either downloaded as an xml-file to a target directory (folder), which will then be your $fileParent, with the whole file path of its new location as $mdFilePath, e.g. "file:/C:/Users/dummy/Desktop/Zenodo/ZenHarvesTransform/zenFeedFirst20200610oai2d_verb=ListRecords%26metadataPrefix=datacite%26set=user-stockholmuniversitylibrary.xml". Or it could be input directly as a URL  (but then xml-encoded for the ampersands). 
In the second (or third) phase (following the bash-script) the input will be the file location of an individual record / item file.xml.

20231213  *Present version 0.7: Added SU ROR-id '05f0yaq80' as alternative for affiliation in suAuthors
20231102  version 0.6: substantial changes in $downloadURL and $fetchFiles in section 5; also change in $manDLname, $manDLsize and $manDLmd5 - no string-check of files. Further changed, simplified inverted author names, as now given directly from creatorName
20220412 version 0.5: with further substantial changes in selection of prefSUAuthor and ORCiD
20201222  version 0.4: substantial change and removal of variables due to replacement of former SUKAT with  Personalsok, preventing access to SU-affiliation, institution / department at SU - now handled by manual lookup, and sukatID as backup option for missing ORCiD. 
2020-07-09/15  version 0.3: Fixed replacement of forbidden characters in filenames at download (Sec 5. Fetch data files, with composite expression derived from former varaibles $fileCoda and $slug to cope with items (e.g. from GitHub) that have an extra '/' in their file path.
Also changed again Sec. 0 on split up of input OAI-PMH feeds to accomodate also (non-valid) items with datacite:identifier[@identifierType="URL"].
2020-07-03 *Present version 0.2: Changed $authORCiDs, $suAuthorNames and $suAuth1ORCiD & $suAuth2ORCiD as workaround problems with v0.1. 
2020-07-03  v0.1 essentially built on a modified version of extractFigsFileInfo.xq v0.9993, but causing problems for input files with inverted creatorName, separated by comma when searching SUKAT 

In the present workflow, this xq-file the has only  mode (ii), while for former mode (i), miniSplit.xq is used instead:

(i) First mode is only for splitting up an OAI-PMH feed into separate item / record xml-files, corresponding to "$artId_originalMD. (Differing from the extractFigsFileInfo.xq, no complete "file_infoFeed" can be produced here,as part of a potential ToC. Here the original metadata zenSUBdataciteFeed.xml, that is in this phase the $mdFilePath, will alone serve as ToC in the final zenSUBdataciteFeedpacs directory.) For this, now use: miniSplit.xq

It is possible that the steps in this first mode in the future workflow will also be part of the bash script (dir-mvOrigMD.sh) that now is run after this, presently only creating package subdirectories and moving the individual items resulting from the feed split-up ($artId_originalMD) into these subdirectories, to which the actual data files belonging with each item are then fetched in the following second mode of this xq-file.

(ii) Second mode, then, creates the necessary file_info.xml supplementary metadata-file, to be used as a parameter in the subsequent zen2fgs.xsl transformation of each item ($artId_originalMD) to a sip.xml compliant with FGS-CSPackage. As explained, this is also when the actual data files belonging to an item are fetched to the corresponding package subdirectory.
In this mode, then, section 5 (fetching the data files) is turned ON, while it is important that section 0, for splitting up feeds, is turned  *off* (with "out-commenting parentheses and colons), otherwise the "$artId_originalMD" files will suffer inherent duplication, producing non well-formed xml, and making them unfit for use in the next step, the actual figMETS2fgs.xsl transformation. 
:)
xquery version "3.0";
declare namespace mets="http://www.loc.gov/METS/";
declare namespace xlink="http://www.w3.org/1999/xlink";
declare namespace datacite="http://datacite.org/schema/kernel-4";
(:declare namespace dc="http://purl.org/dc/elements/1.1/"; :)
declare namespace lazy="http://basex.org/modules/lazy";
declare namespace local="local";
declare namespace OAI-PMH="http://www.openarchives.org/OAI/2.0/";

(: 
These namespace declarations might also be needed if xq is run outside BaseX: 

declare namespace file="http://expath.org/ns/file";
declare namespace fetch="http://basex.org/modules/fetch";
declare namespace html="http://www.w3.org/1999/xhtml";
declare namespace json="json";
:)

declare variable $recursive := true(); 
declare variable $mdFilePath as xs:string? external := "file:/M:/MADIArkiv/Zenodo/zenSUBdataCiteFeed07pacs/17366744/17366744_originalMD.xml";
declare variable $path as xs:string? external := "file:/M:/MADIArkiv/Zenodo/zenSUBdataCiteFeed07pacs";
let $fileParent := if (contains($mdFilePath,'file:/')) then file:parent($mdFilePath) else $path
(:let $pathChildren := file:children($path)- not used, instead use $dataDir (from 2et4extractFigsFileInfo.xq) :)
let $dataDir := for $f in file:children($fileParent) return  $f[file:is-dir($f) and file:name($f) = 'data']
let $docMD := doc($mdFilePath)

(:-------  0. Splitting-up  zenFeeds:  use miniSplit.xq
                 'turn-off' for use on individual items "_originalMD --> 

let $itemSplit := for $i in $docMD//OAI-PMH:record  return $docMD//$i
let $origID :=   for $j in $itemSplit//datacite:identifier return if ($j[@identifierType="URL"]) then concat(substring-after($j,'record/'),'_originalMD') else concat(substring-after($j,'zenodo.'),'_originalMD')
let $originalMD := for $j in $origID,$i in $itemSplit 
return file:append(concat($fileParent,$j,".xml"),$i[contains(./OAI-PMH:header/OAI-PMH:identifier,substring-before($j,'_originalMD'))]) 

<--   :)

(:---------------------- 1. Preliminaries------------------:)

let $artId := for $x in $docMD//OAI-PMH:header/OAI-PMH:identifier return substring-after($x,'org:')
for $u in $artId
let $url := concat("https://zenodo.org/api/records/",$u)
let $jsonMD := unparsed-text($url)
let $json2xml := json:parse($jsonMD) 
for $y in ($json2xml)
let $z := $y//files//key
let $downloadURL := $y//files//links[@type='object']/self
let $downloadURLclean := for $c in $downloadURL return (replace(replace($c,'\(','_'),'\)','_')) 
(:
let $downloadURL := for $i in $fileUUID return concat(replace($i,substring-after($i,'org/'),'/record/'),$u,'/files/',substring-after(substring-after($i,'files/'),'/'),'?download=1')
let $w :=  if ($y//embargo__date/@type='null') then 'None'  else $y//embargo__date
let $fileUUID := $y//files//self
:)
(:------- 2. Authors, suAuthorNames & identifiers------------ :)

let $authors := $docMD//datacite:creatorName

let $suAuthor1 := ($authors[following-sibling::datacite:affiliation[contains(.,'Stockholm University')or contains(.,'05f0yaq80')]])[1]
let $suAuthor2 := ($authors[following-sibling::datacite:affiliation[contains(.,'Stockholm University')or contains(.,'05f0yaq80')]])[2]

let $suAuth1ORCiD := for $a in $suAuthor1 return if ($a/following-sibling::datacite:nameIdentifier[@nameIdentifierScheme="ORCID"])  then $a/following-sibling::datacite:nameIdentifier else () 
let $suAuth2ORCiD := for $a in $suAuthor2 return if ($a/following-sibling::datacite:nameIdentifier[@nameIdentifierScheme="ORCID"])  then $a/following-sibling::datacite:nameIdentifier else () 
let $prefSUauthORCiD := if (string-length($suAuth1ORCiD) < 1 and string-length($suAuth2ORCiD) > 1) then $suAuth2ORCiD else $suAuth1ORCiD

let $suAuth1ORCiDurl := for $i in $suAuthor1 return (html:parse(unparsed-text(concat("https://pub.orcid.org/v2.1/search?q=%22", encode-for-uri(($i)),"%22")))//uri)
let $suAuth2ORCiDurl := for $i in $suAuthor2 return (html:parse(unparsed-text(concat("https://pub.orcid.org/v2.1/search?q=%22", encode-for-uri(($i)),"%22")))//uri)
let $prefSUauthORCiDurl := if (count($suAuth1ORCiDurl) != 1  and count($suAuth2ORCiDurl) = 1) then $suAuth2ORCiDurl else $suAuth1ORCiDurl

(:
let $suAuthor1invertName := concat($suAuthorInvert1[1],', ',$suAuthorInvert1[2]) 
let $suAuthor2invertName := concat($suAuthorInvert2[1],', ',$suAuthorInvert2[2]) 
:)
 
let $prefSUauthorInvert := 
if 
(($prefSUauthORCiD = $suAuth1ORCiD) or ($prefSUauthORCiDurl = $suAuth1ORCiDurl)) 
then $suAuthor1 
else if 
(($prefSUauthORCiD = $suAuth2ORCiD) or ($prefSUauthORCiDurl = $suAuth2ORCiDurl)) 
then $suAuthor2 else 
$suAuthor1

let $pX := for $p in $prefSUauthORCiD return if (string-length($p) > 1) then $prefSUauthORCiD  else if (string-length($p) <1 and string-length($prefSUauthORCiDurl) >1) then ($prefSUauthORCiDurl)  else 'None'

let $ORCount := count($pX) 

(:-- Departments/Institutions and Inst.numbers for METS:AGENT @ROLE="ARCHIVIST" --:)

let $suAuthor1Inst := for $a in $suAuthor1 return if (not($a/following-sibling::datacite:affiliation[contains(.,'Stockholm University') or contains(.,'05f0yaq80')])) then 'Select $suAuth2Inst' else 'Manual'
let $suAuthor2Inst := for $a in $authors[2] return if (not($a/following-sibling::datacite:affiliation[contains(.,'Stockholm University') or contains(.,'05f0yaq80')])) then 'Select $suAuth3Inst' else 'Manual'

let $stepA := if ((count($suAuth1ORCiD) > 1) and (string-length($authors[2]) > 1)) then $suAuthor2Inst else $suAuthor1Inst 
let $step1 := tokenize(substring-after($stepA,'%3D'),'%2Co')
let $step2 := for $i in ($step1) return if (contains($i,'nstitut')) then $i[contains($i,'nstitut')] else if (contains($i,'bibliotek')) then $i[contains($i,'bibliotek')] else (if (contains($i,'Centr')) then $i[contains($i,'Centr')] else ())
let $step2b := if (count($step2) > 1) then $step2[2] else $step2 
let $step3 := if ($step2b != $step1[1]) then replace($step2b,'u%3D','') else $step2b
let $step4 := for $p in $step3 return replace($p,'\+',' ')
let $step5 := for $q in $step4 return replace($q,'%C3%A4','ä')
let $step6 := for $r in $step5 return replace($r,'%C3%B6','ö')
let $step7 := for $s in $step6 return replace($s,'%C3%A5','å')

let $archivalInst := $stepA

(:------ Files, folders and result doc: 'file_info.xml' ----------- :)

(:let $mimeTypes := for $t in $downloadURLclean return fetch:content-type($t):)
let $subFold := if (contains($mdFilePath,'https://')) then (file:create-dir(concat($path,'subFold'))) else ()
let $manDLname := if ($y//files//is__link__only/text()='true')(: or (string-length($y//files) = 0 ):)  then <manualFileName>Replace by manually downloaded filename!</manualFileName> else ()
let $manDLsize := if ($y//files//is__link__only/text()='true')(: or (string-length($y//files) = 0 ):)  then  <manualFileSize>Replace by manually downloaded fileSize!</manualFileSize> else ()
let $manDLmd5 := if ($y//files//is__link__only/text()='true')(: or (string-length($y//files) = 0 ):)  then <manualMD5>Replace by manually downloaded MD5!</manualMD5> else ()
let $warn := if (not ($authors/following-sibling::datacite:affiliation[contains(.,'Stockholm')]) or ($ORCount > 1)) then ('ID-check!') else if($y//files//is__link__only/text()='true')(: or (string-length($y//files) = 0 ):) then ('Manual file download!') else ('None') 
let $doc := <file_info  DOI="{($y//doi)[1]}" pubDate="{$y//publication__date}" created="{$y//created}" updated="{$y//updated}"  fileInfo-harvestDate="{current-dateTime()}" SW-Agent_eZFIxq="{'v0.7'}" FILELIST="{if(($y//files//is__link__only/text()='true') )  then 'external' else $z}" FILENAMECOUNT="{count($z)}"  
 prefSUauthorName="{$prefSUauthorInvert}" prefSUauthORCiD="{concat('https://orcid.org/',$pX)}" archivalInst="{$archivalInst[1]}"  ALERT="{$warn}">{$y//files,(: <mimeTypes>{$mimeTypes}</mimeTypes>,:) <references>{$y//references/_}</references>, $manDLname, $manDLsize, $manDLmd5 }</file_info> 
 
(:---- 3. Create item Folders: deprecated. 
Use Bash script:  "dir-mvOrigMD.sh" --  :)

(:--- 4. Create file_info.xml - parameter file for xslt -- :)

let $result := file:append(if (contains($mdFilePath,'https:\/\/')) then ($subFold/file_info.xml) else (concat($fileParent,"/file_info.xml")), $doc) 
 
(:---- 5. Fetch data files of individual items ---
                  - delete right ---> ')' and ':'  to turn off. Put back in to turn on again. --> 

let $fetchFiles := for $f in $downloadURL  return file:write-binary(concat($fileParent,replace(replace(replace(if (contains(substring-before(substring-after($f,'files/'),'?'),'/')) then substring-after(substring-before(substring-after($f,'files/'),'?'),'/') else (substring-before(substring-after($f,'files/'),'?')),'%20|%40','_'),'%C3%A5|%C3%A4','a'),'%C3%B6','o')), lazy:cache(fetch:binary($f))) 
:)
(: let $fetchFiles := if  ($y//total > 5 and $y//size < 823456790) 
then file:write-binary(concat($dataDir,'filesDownload'),fetch:binary(concat('https://su.figshare.com/ndownloader/articles/',$artId)))
else :)
let $fetchFiles := for $f in $downloadURL  return (file:write-binary(concat($dataDir,$f/ancestor::links/preceding-sibling::key), lazy:cache(fetch:binary($f)))) 
(: This WORKS for most items except for filenames with spaces! :)

(: 
let $fetchFiles := for $f in $y//files[contains(.,'https')]//links/content  return (file:write-binary(concat($fileParent,$f/ancestor::links/preceding-sibling::key), lazy:cache(fetch:binary($f)))) This does NOT work! :)

(: <-- delete left '('and ':'  to turn off. Put back in to turn on again. -- :)

return $doc
