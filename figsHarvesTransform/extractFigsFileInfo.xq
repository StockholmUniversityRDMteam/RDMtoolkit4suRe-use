(:This xq-file is for extracting figshare file metadata and datafiles, by means of the base API "https://api.figshare.com/v2/articles/" as a complement to the OAI-PMH-feeds in METS (base API - https://api.figshare.com/v2/oai?verb=ListRecords&metadataPrefix=mets), where these file metadata are not as complete, lacking e.g. md5 CHECKSUMS and original filenames with extensions, from which MIMETYPE can be constructed in the transformation to FGS-CSPackage. [In an earlier version of this xq-file these file metadata were instead extracted from the JSON-data inherent in the corresponding html-pages of the DOI:s found in the dc:identifier-elements of the OAI-PMH-feeds, but these were later also found to be incomplete, in particular for items with more than 10 associated datafiles.] 
The declared external variable $mdFilePath is your input file, the "_originalMD"-item produced after splitting up of the Figshare OAI-PMH-feed in METS format, received e.g.  by "https://api.figshare.com/v2/oai?verb=ListRecords&metadataPrefix=mets&set=portal_18&from=2018-12-10&until=2018-12-31" (where 'set=portal_18' stands specifically for SU items). It could be either downloaded as an xml-file to a target directory (folder), which will then be your $fileParent, with the whole file path of its new location as $mdFilePath, e.g. "file:/C:/Users/dummy/Desktop/FeedsFile_info/figsMETSfeed22pacs/figsMETSfeed22-api.figshare.com_v2_oai%20verb=ListRecords%26metadataPrefix=mets%26set=portal_18%26from=2018-12-10%26until=2018-12-31.xml". Or it could be input directly as a URL, but then xml-encoded for the ampersands, thus e.g."https://api.figshare.com/v2/oai?verb=ListRecords&amp;metadataPrefix=mets&amp;set=portal_18&amp;from=2018-12-10&amp;until=2018-12-31". 

The resulting "file_info feed" from running the xquery on a complete feed is not a wellformed xml-file yet (a root-element is added through the BASH script dir-mvOrigMDfig), but it contains all the necessary file metadata needed for the transform. These will then be used as a parameter document (file_info.xml) in the transformation of the original feed metadata to FGS-CSPackage sip.xml, acording tothe METS-profile of the Swedish National Archives. 

In the present workflow the former different "modes", with different sections activated at different times, have been replaced by if clauses, making "activation" and "deactivation" automatic  

(i) First mode is for splitting up an OAI-PMH METSfeed into separate items, "$artId_originalMD", and by default producing the "file_infoFeed",  appended through BASH-script dir-mvOrigMD.sh with a root-element [ formatted e.g. as <file_infoFeed nr="10" extractFigsFileInfo.xq="v0.994" prodate="20200210"> </file_infoFeed> ] to become well-formed xml. This will serve as a kind of ToC, together with the corresponding original METSfeed in the final figsMETSfeedNNpacs directory.
In this mode, then, section 0 is now activated through an if-clause, exclusively for feeds with several items / "records".  

It is possible that the steps in this first mode in the future workflow will also be part of the bash script (dir-mvOrigMD.sh) that now is run after this, presently only creating package subdirectories and moving the individual items resulting from the METS feedsplit-up ($artId_originalMD) into these subdirectories, to which the actual data files belonging with each item are then fetched in the following second mode of this xq-file.

(ii) Second mode, then, creates the necessary file_info.xml supplementary metadata-file, to be used as a parameter in the subsequent figMETS2fgs.xsl transformation of each item ($artId_originalMD) to a sip.xml compliant with FGS-CSPackage. As explained, this is also when the actual data files belonging to an item are fetched to the corresponding package subdirectory. In this mode, then, section 5 (fetching the data files) is activated, again through an if-clause exclusive to individual items, while section 0, for splitting up feeds, is deactivated.  

Changes to previous versions include:

2024-03-25	*Current version 1.1: Improved version treatment for $artId, in case item record was updated with new files since OAI-PMH feed harvest 
2024-02-20	Version 1.0: Adaptation to figMETS2fgs v1.0; added SRRD and Srrd as triggers for archivalInst='310 Sociologiska institutionen'.    
2023-02-10/2023-08-23	Version 0.9999: Added element $resourceDOI as first selection option for dcterms:isReferencedBy in figMETS2fgs.xsl. 2023-08-23: added $isSupplementTo as new first choice for dcterms:isReferencedBy, relegating to second choice $resourceDOI (both appear simultaneously in the fighare API output for now).  
2022-12-08   Version 0.9998: Updated $prefSUauthorName to handle cases with single authors without ORCiD
2022-03-28	 Version 0.9997: Complex change for alignment $prefSUauthorName and prefSUauthORCiD to always prefer ORCiD in Figshare ($prefSUauthORCiDinFigs), irrespective of 1 or more authors. 
2021-12-27 Version 0.9996: Make former modules (0) and (5) conditional on absence or presence of 'originalMD' to comply with the principle: 
"Do not comment and uncomment sections of code to control a program’s behavior (2h), since this is error prone and makes it difficult or impossible to automate analyses. Instead, put if/else statements in the program to control what it does." [Wilson et al. (2021) - Good Enough Practices in Scientific Computing (PLOS Submission)]    
2021-02-17 Version 0.9995: Adjusted $suAuthorInvert1 & 2 and $suAuthInv1 & 2 with element order occurrence no. to fit older cases with multiple authors.
2020-10-15 Version 0.9994: Changed "http://sukat.su.se" to new base-URL "https://personalsok.su.se" where needed, as were other changes in search URLs, and as result of no access to former $sukatID (username), or archivalInst -> $sukatInstnr through sukat, new method of getting $archivalInst by way of custom metadata field in su.figshare with drop-down menu. Added if-clause condition "string-length($suAuthInv1) < 1" to $suAuthorInvert  and "string-length($suAuthorInvert) < 1" to $warn ->ID-check! to cover cases where results from personsok.su.se give empty string (earlier covered by $sukatID). 
2020-05-06 Version 0.9993: 
Changed name of former variable $m to $downloadURL  to be more clear about what it stands for.
Reintroduced elements for producing file_info.xml from old version (2018-03-14) as alternative when the figshare-API for articles produces an error, such as in https://doi.org/10.17045/sthlmuni.9851387.v1 .
 
2020-04-27 Version 0.9992: In $fetchFiles CHANGED  further "replace($f/preceding-sibling::name/text(),' ','_'))" TO "replace(replace(replace(replace($f/preceding-sibling::name/text(),' ','_'),'å','a'),'ä','a'),'ö','o'))" in order to avoid manual replacement of "Swedish" characters 'å', 'ä', 'ö' in filenames. (Corresponding change made earlier in figMETS2fgs.xsl).
2020-04-01/02 Version 0.9991: $archivalInstList adjusted to accomodate deposits from Stockholm Resilience Centre, and replacing $instSUlist[1] in $instNum
2020-03-30 Version 0.999: In $fetchFiles CHANGED $f/preceding-sibling::name/text()) TO replace($f/preceding-sibling::name/text(),' ','_')) in order to avoid manual replacement of spaces in filenames. (Corresponding change made in figMETS2fgs.xsl).
2020-03-18 Version 0.998: Adjusted conditions for triggering manually downloaded files in $warn and $manDLname, to meet older cases where <files type="array"/> is empty, added $manDLsize and $manDLmd5 for the same purpose.
2020-03-10 Version 0.997: Added $y//references, $y//funding__list,$y//custom__fields to $doc for use in file_info.xml parameter to amend figMETS2fgs.xsl with elements for REFERENCES, FUNDER, and ASSOCIATED PUBLICATION . 

2020-02-27 Version 0.996: Following up on previous v0.995, made also $z, $warn and @FILENAMECOUNT conditional on presence or absence of data files in Figshare. 

2020-02-21 Version 0.995: Update of preamble above and change of $artId to be conditional on the presence or absence of version id in dc:identifier, which proved necessary for earlier items. Further made $fetchFiles conditional on data file(s) being deposited in Figshare, and not only providing download-link to external source.

2020-02-09/11 Version 0.994: Change of $instNum, $instSUlist and  $insNrClist after apparent changes in src-code of SUKAT, to retrieve correct institution name  and nr  by changes in  / additions of variables $instNrCList, $instSUlist, $archivalInst and $instNum. 
 
20200207 Version 0.993: Alternative $artId := for $x in ($docMD//header/identifier) return  substring-after($x,'article/') to accomodate identifiers without version no. '.v\d', as was common earlier, and skipping module 3. creation of $itemFolds to be performed in bash together with moving ...OriginMD.xml to $itemFolds (00).
20191124 Version 0.992: Added LicenseURL="{$y//license/url}" LicenseNArME="{$y//license/name}" to output in $doc, for (future) possible use of mets:rightsMD in sip.xml.
Fixed previously erroneous $fetchFiles from getting same duplicate files with diff. names, to getting all data files with correct names. 
20190827 Version 0.991: Changed handling of filenames with spaces, replacing '%20' by '_' (underscore) instead of encoding for URI. Further added file extension '.html' for files represented by external links (e.g. such as YouTube).
20190718 Version 0.99: Moved/redefined <fileNameURI/> as conditional on diff. between encoded-for-uri(filename) and original filename with new variable $xURIs. 
Also adjusted $ORCount so as to $warn only if $prefSUauthORCiD > 1 (i.e. not for $prefSUauthORCiDurl > 1, in case there is already a prioritized $ORCiDinFigs.) 
 Also created $prefSUauthLname for use in folder names for packages.
 This version also creates a package subfolder (either in a predefined packages folder for the whole feed set as $fileParent or in a subdirectory created through $subFold directly under the $path) for each item in the feed, with the last name of the $prefSUauthor + the corresponding "DOI-slug", i.e. substring-after(.,'sthlmuni.'). 
 It further fetches all the data files, prefixing the filenames with the same item-subfolder names, to make it easier to move them to the right subfolder. [This is until we manage to place them where they should be automatically. An idea is to cut again substring-before(.,"end-of-DOI-slug") after using it to move data files to the right folders.]   
20190712 Version 0.98: Substantial changes and introduction of new variables e.g. $suAuthorNames, $prefSUauthor etc. to accomodate cases with only last of given 4 authors having $sukatId, firstSUauthor having multiple $sukatIds etc. Also total revision of   method for finding and aligning archival institution with prefSUauthor ($archivalInst -> METS:AGENT[@ROLE=""ARCHIVIST" @TYPE="ORGANIZATION"]).
Further added $zURIs for resulting file_info/@fileNameURIs to (reluctantly) accomodate  irregular use of filenames containing e.g. Swedish 'å,ä,ö' or spaces ' '. Ideally, these should replace in such cases the filenames in the  @OWNERID of the sip.xml METS fileSec, to ensure local, direct, clickable access from the metadata (sip.xml) to the data files harvested.     
20190702  Version 0.97: Changed @SW-Agent_eFFIxq-version="{'0.96'}" to @SW-Agent_eFFIxq="{'v0.97'}".
20190611  Version 0.96: Added $archivalInst as variable depending on sukat-entries of $firstSUauth- and $sukatId, solving problem of getting archivist agent for sip.xml.   

20190607 Version 0.95: Added $firstSUauth- variables for differentiating between authors affiliated with SU or not and extracting ORCiDs, sukatIDs and sukatInstitutions in cases when first author is not SU-affiliated, incl. $firstSUauthLname to be used for creating subdirectories (package folders) instead of first author last names. $nameSplit-variables were made encode-for-uri(), to accomodate names with special characters.
20190522 Version 0.94: Added $ORCiDinFigs and $auth1ORCiD to basis for firstAuthORCiD in $doc output
20190521 Version 0.93: Took out trailing spaces from $instNr with #replace((substring-before($i, $sukatInstitution[1])),' ','')#
20190513 Version 0.92: Replaced in $doc: firstAuthorNameInv="{$nameSplitL1}, {$nameSplitF1}" with more accurate for 3-part names firstAuthorNameInv="{substring-before($y//citation,';')}"
20190510 Version 0.91: Added for the case when there are namesakes at different
SU-institutions in SUKAT, or the same firstAuthor have multiple mother institutions, a numeral [1] selecting as default the first of these has been added here for the $instNr, to avoid parsing errors. But all the listed institutions will appear in the output, together with an Alert="ID-check!"

20190214 Version 0.9: Added $itemFolds for creation of individual folders for each item in a feed, in which the split-up feed item's "file_info.xml" files should go. 
Added @ALERT $warn to notify about need for manual ID-check in 3 cases: 
i) when no sukatID is found (hence, affiliation of first author with Stockholm University is doubtful)
ii) multiple ORCiDs and/or iii) multiple sukatIDs for the first author were found.

20190115 Version 0.8: Added $mimeTypes by means of fetch:content-type as an alternative replacing the construction of mimeTypes from file extensions in the figMETS2fgs.xsl transform file. Later tests proved these to be ambigous sometime, so will only be used as potential fallback in case of need. 

20190111 Version 0.7: Refined firstAuthorNameInv to accomodate names with middle initial, thus having parts. Also introduced new variable $artId to adapt to API-input (instead of html-source), allowing for whole feeds with multiple items as $mdFilePath 

20180915 Version 0.6: Added firstAuthorNameInv and $auth1id to output, removed $persID and dependent variable $jsonORCiD to be replaced by more stable $ORCiDuri in $auth1id, but also noted - later - some instances of double ORCiDs, either associated with the same individual, or from homonyms, different individuals with the same name. Also found better, more stable expresssion for $sukat_info and dependent $sukatInstitution. 

20180816 Version 0.5: Replaced parsing-error problematic $sukatIdExt with $sukat_info temp. in output of $sukatID1. Also detected yet unexplained errors / missing values for $sukatInstititution.

20180720 Version 0.4: Added $sukatID1 and $sukatInstitution in output. Made EMBARGODATE conditional to avoid empty values. 

20180718 Version 0.3: Added @FILECOUNT and @EMBARGODATE in output. :)

xquery version "3.0";
declare namespace mets = "http://www.loc.gov/METS/";
declare namespace xlink = "http://www.w3.org/1999/xlink";
declare namespace dc = "http://purl.org/dc/elements/1.1/";
declare namespace lazy = "http://basex.org/modules/lazy";
declare namespace local = "local";
declare namespace OAI-PMH = "http://www.openarchives.org/OAI/2.0/";

(:These namespace declarations might also be needed if xq is run outside BaseX: 
declare namespace file="http://expath.org/ns/file";
declare namespace fetch="http://basex.org/modules/fetch";
declare namespace html="http://www.w3.org/1999/xhtml";
declare namespace json="json";
:)
declare variable $recursive := true();
declare variable $mdFilePath as xs:string? external := "file:/C:/Users/joph9849/Desktop/reposit2fgsCSP/figsHarvesTransform/figsMETSfeed85pacs/figsMETSfeed85-api20240215until20240318.xml";
declare variable $path as xs:string? external := "file:/C:/Users/joph9849/Desktop/reposit2fgsCSP/figsHarvesTransform/figsMETSfeed85pacs";
let $fileParent := if (contains($mdFilePath, 'file:/')) then file:parent($mdFilePath) else $path
let $pathChildren := file:children($path)
let $docMD := doc($mdFilePath)

(:-------  0. Splitting-up  figsMETSfeeds------------------- :)

let $itemSplit := if (contains($mdFilePath,'originalMD')) then () else for $i in $docMD//OAI-PMH:record  return $docMD//$i 
let $origID :=   for $j in $itemSplit//dc:identifier return concat(substring-after($j,'sthlmuni.'),'_originalMD')
let $originalMD := for $j in $origID,$i in $itemSplit 
return file:append(concat($fileParent,$j,".xml"),$i[contains(.//dc:identifier,substring-before($j,'_originalMD'))])



(:---------------------- 1. Preliminaries------------------:)

(: Old, alternative version for cases when API for articles somehow fails - from "extract_suFigsDOIandJSON.xquery", 2018-03-14  -> 
for $x in   doc($mdFilePath)//dc:identifier
let $apiDates := replace(substring-after($mdFilePath,"from="),'%26','')
let $url := concat("https://doi.org/",$x)
let $jsonFiles := html:parse(unparsed-text($url))//script[@id='app-data']/node()
let $json2xml := json:parse($jsonFiles)
-  :)
(: Present version -  delete right parentheses to activate old version above -> :)
let $artId := for $x in $docMD//dc:identifier
return
    if (contains($x, '.v')) then
        concat(substring-before(substring-after($x, 'sthlmuni.'), '.'),'/versions/',substring-after($x,'.v'))
    else 
        substring-after($x, 'sthlmuni.')
for $u in $artId
let $url := concat("https://api.figshare.com/v2/articles/", $u)
let $jsonMD := html:parse(unparsed-text($url))
let $json2xml := json:parse($jsonMD)
(: <- delete me to activate old, alternative version instead  :)
let $resourceDOI := for $i in $json2xml//resource__doi  return if(string-length($i) = 0)  then () else concat("https://doi.org/",$i)
let $isSupplementTo := for $i in $json2xml//relation return if ($i='IsSupplementTo') then if(string-length($i) = 0)  then () else $i/following-sibling::link
for $y in ($json2xml)
let $z := if ($y//files//is__link__only/text() = 'true') then
    'LinkOnly'
else
    $y//files//name
let $zURIs := for $n in $z
return
    <fileNameURI>{replace($n, '%20', ' ')}</fileNameURI>
let $arrayZ := for $i in $y//files
return
    array {$i//name/text()}
let $arrayU := array {$zURIs/text()}
let $xURIs := for $x in $zURIs
return
    if ($x[not(deep-equal($arrayZ, $arrayU))]) then
        $x
    else
        <note>Filename OK</note>
let $downloadURL := $y//files//download__url 
(:let $downloadURL := $docMD//mets:FLocat/@xlink:href:)
let $w := if ($y//embargo__date/@type = 'null') then
    'None'
else
    $y//embargo__date
    
    (:------- 2. Authors, suAuthorNames & identifiers------------:)

let $authors := $y//authors//full__name/text()
let $authorCount := count($authors)

let $authInvRaw := for $c in (substring-before($y//citation, ' ('))
return (tokenize($c, ';'))
let $authInv := for $i in $authInvRaw
return replace($i, ' \(\d\d\d\d', '')
let $authInvPur := for $i in $authInv return replace($i, '^ ', '')

(:let $suAuthorInvert := for $c in ($authors) return reverse(tokenize($c, ' '))
let $suAuthInv := for $a in ($suAuthorInvert) return $authInvPur[contains(., $a)]:)

let $suAuthORCiDinFigs := $y//url__name/following-sibling::orcid__id
let $prefSUauthORCiDinFigs := if ((count($authors) > 1) and (string-length($suAuthORCiDinFigs[1]) != 19) and (string-length($suAuthORCiDinFigs[2]) = 19)) then
$suAuthORCiDinFigs[2]
else $suAuthORCiDinFigs[1]

let $suAuth1ORCiDurl := for $i in $authors[1]
return
    (html:parse(unparsed-text(concat("https://pub.orcid.org/v2.1/search?q=%22", encode-for-uri(($i)), "%22")))//uri)
let $suAuth2ORCiDurl := for $i in $authors[2]
return
    (html:parse(unparsed-text(concat("https://pub.orcid.org/v2.1/search?q=%22", encode-for-uri(($i)), "%22")))//uri)
    
let $prefSUauthORCiDurl := if ((count($authInvPur) > 1) and 
(count($suAuth1ORCiDurl) != 1) and (count($suAuth2ORCiDurl) = 1))  
then 
  $suAuth2ORCiDurl
else
    $suAuth1ORCiDurl
let $prefSUauthORCiD := if (string-length($prefSUauthORCiDinFigs) = 19) then
    concat('https://orcid.org/', $prefSUauthORCiDinFigs)
else
    $prefSUauthORCiDurl
let $pX := if (count($prefSUauthORCiD) >= 1) then
    $prefSUauthORCiD
else
    if (string-length($prefSUauthORCiD) = 0) then
        'None'
    else
        $prefSUauthORCiD
let $ORCount := count($prefSUauthORCiD)

let $prefSUauthorName :=  if ($authorCount = 1) then $authInvPur
else
for $i in $prefSUauthORCiD return (if (string-length($suAuthORCiDinFigs[1]) >1 and $i = concat('https://orcid.org/',$suAuthORCiDinFigs[1]/text())) then $authInvPur[1] else
(if  (string-length($suAuthORCiDinFigs[2]) >1 and $i = concat('https://orcid.org/',$suAuthORCiDinFigs[2]/text())) then $authInvPur[2]
else
(if ($prefSUauthORCiDurl = $suAuth1ORCiDurl) then $authInvPur[1]
else
if ($prefSUauthORCiDurl = $suAuth2ORCiDurl) then $authInvPur[2] )))


(:---- Departments/Institutions and Inst.numbers for METS:AGENT @ROLE="ARCHIVIST" ----:)

let $archivalInst := if ($y//references/_[contains(.,'suda.su.se')]) then '310 Sociologiska institutionen' 
else if ($y//tags/_[contains(.,'CeUL')]) then '306 Institutionen för pedagogik och didaktik' 
else if ($y//tags/_[contains(.,'Public Health')]) then '333 Institutionen för folkhälsovetenskap'
else if ($z[contains(.,'wps')]) then '310 Sociologiska institutionen'
else if ($z[contains(.,'SRRD')]) then '310 Sociologiska institutionen'
else if ($z[contains(.,'Srrd')]) then '310 Sociologiska institutionen'
else if ($z[contains(.,'TLHE')]) then '306 Institutionen för pedagogik och didaktik' 
else if ($z[contains(.,'Design')]) then '306 Institutionen för pedagogik och didaktik'
else $y//name[contains(.,'Affiliation')]//following-sibling::value/_/substring-before(text(),' |')
    
    (:------ Files, folders and result doc: 'file_info.xml' -----------:)

let $mimeTypes := for $t in $downloadURL return fetch:content-type($t)
let $subFold := if (contains($mdFilePath, 'https://')) then
    (file:create-dir("file:/C://figsHarvesTransform/subFold/")) else ()
let $manDLname := if (($y//files//is__link__only/text() = 'true') or (string-length($y//files) = 0)) then
<manualFiles>
    <manualFileName>Replace by manually downloaded filename!</manualFileName> 
    <manualFileSize>Replace by manually downloaded fileSize!</manualFileSize> 
    <manualMD5>Replace by manually downloaded MD5!</manualMD5>
</manualFiles>
 else ()

let $warn := if ($ORCount > 1 or string-length($archivalInst) < 1 or string-length($authInvPur[1]) < 1) then
    ('ID-check!')
    else
    if (($y//files//is__link__only/text() = 'true') or (string-length($y//files) = 0)) then
        ('Manual file download!')
    else ('None')
    
(: pubDate="{$y//published__date}"
   DOI="{concat('https://doi.org/',$docMD//dc:identifier)}" :)

let $doc := <file_info cite="{$y//citation}" DOI="{$y//doi}" pubDate="{$docMD//dc:date}" fileInfo-harvestDate="{current-dateTime()}" SW-Agent_eFFIxq="{'v1.1'}" FILELIST="{
if (($y//files//is__link__only/text() = 'true') or (string-length($y//files) = 0)) then 'external' else $z}"
FILENAMECOUNT="{if (($y//files//is__link__only/text() = 'true') or (string-length($y//files) = 0)) then 0 else count($z)}" LicenseURL="{$y//license/url}" LicenseNAME="{$y//license/name}" EMBARGODATE="{$w}"
prefSUauthorNameInv="{$prefSUauthorName}" prefSUauthORCiD="{$pX}" archivalInst="{$archivalInst}" 
ALERT="{$warn}" resourceDOI="{$resourceDOI}" isSupplementTo="{$isSupplementTo}">{$y//files, <mimeTypes>{$mimeTypes}</mimeTypes>, $xURIs, $manDLname, $y//references, $y//funding__list, $y//custom__fields}</file_info>

(:---- 3. Create item Folders: deprecated. 
Use Bash script:  "dir-mvOrigMDfig.sh". Earlier turned off for use on individual items.  

let $itemFolds := for $i in $doc return if (contains($mdFilePath,'https://')) then file:create-dir(concat($fileParent,'subFold/',$prefSUauthLNuri,substring-after($y//doi,'sthlmuni.'))) else file:create-dir(concat($fileParent,$prefSUauthLname,substring-after($y//doi,'sthlmuni.')))
let $itemOriginals := for $j in (doc($mdFilePath)//record) return doc($j)   ---  :)

(:--- 4. Create file_info.xml - parameter file for xslt --- :)

let $result := file:append(if (contains($mdFilePath, 'https://')) then
 ($subFold/"file_infoFeed.xml")
else  (concat($fileParent, "/file_info.xml")), $doc)

(:---- 5. Fetch data files of individual items ----- :)

let $fetchFiles := if (contains($mdFilePath,'originalMD')) then for $f in $downloadURL
return
    if (not(contains($f, 'ndownloader.figshare'))) then ()
    else
        file:write-binary(concat($fileParent, replace(replace(replace(replace($f/preceding-sibling::name/text(), ' ', '_'), 'å', 'a'), 'ä', 'a'), 'ö', 'o')), lazy:cache(fetch:binary($f)))
        
(: ---- :)
                 
return $doc

    (: -- END of script --:)
