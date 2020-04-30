(:This is the Public version 2.0 of the eFFI.xq-file (the local version of which has substantially developed and was continuously pushed to GitLab) for extracting figshare file metadata and datafiles, by means of the base API "https://api.figshare.com/v2/articles/" as a complement to the OAI-PMH-feeds in METS (base API - https://api.figshare.com/v2/oai?verb=ListRecords&metadataPrefix=mets), where these filedata are not as complete, lacking e.g. md5 CHECKSUMS and original filenames with extensions, from which MIMETYPE can be constructed in the transformation to FGS-CSPackage. [In an earlier version of this xq-file these filedata were instead extracted from the JSON-data inherent in the corresponding html-pages of the DOI:s found in the dc:identifier-elements of the OAI-PMH-feeds, but these were later also found to be incomplete, in particular for items with more than 10 associated datafiles.] 
The declared external variable $mdFilePath is your input file, it could be - at different phases of the work process - either  the "_originalMD"-item produced after splitting up of the Figshare OAI-PMH-feed in METS format, or it could be the xml-file representing an entire feed, comprising at most 10 items. It could be either downloaded as an xml-file to a target directory (folder), which will then be your $fileParent, with the whole file path of its new location as $mdFilePath, e.g. "file:/C:/Users/dummy/Desktop/FeedsFile_info/figsMETSfeed22pacs/figsMETSfeed22-api.figshare.com_v2_oai%20verb=ListRecords%26metadataPrefix=mets%26set=portal_NN%26from=2018-12-10%26until=2018-12-31.xml". Or it could be input directly as a URL, but then xml-encoded for the ampersands, thus e.g."https://api.figshare.com/v2/oai?verb=ListRecords&amp;metadataPrefix=mets&amp;set=portal_NN&amp;from=2018-12-10&amp;until=2018-12-31". 

The resulting "file_info feed" from running the xquery on a complete feed is not a wellformed xml-file yet (unless there is only one item in the input file $mdFilePath), a root-element must be added in a local xml-editor, but it contains all the necessary file metadata needed for the transform. These will then be used as a parameter document (file_info.xml) in the transformation of the original feed metadata to FGS-CSPackage, the METS-based standard for Submission Information Packages (SIPs) of the Swedish National Archives, by means of the figMETS2fgs.xsl. 

In the present workflow, this xq-file has two different "modes", with different sections activated:

(i) First mode is for splitting up an OAI-PMH METSfeed into separate items, "$artId_originalMD", and by default producing the "file_infoFeed", which must be appended (at present manually) with a root-element [formatted e.g. as <file_infoFeed nr="10" extractFigsFileInfo.xq="v0.994" prodate="20200210"> </file_infoFeed> ] to become well-formed xml. This will serve as a kind of ToC, together with the corresponding original METSfeed in the final figsMETSfeedNNpacs directory.
In this mode, then, section 0 (doing the split-up into items) is turned on (by removing the commenting  colons with parentheses), and section 5 ( for fetching data files) is turned *off*).

It is possible that the steps in this first mode in the future workflow will also be part of the bash script (dir-mvOrigMD.sh) that now is run after this, presently only creating package subdirectories and moving the individual items resulting from the METS feedsplit-up ($artId_originalMD) into these subdirectories, to which the actual data files belonging with each item are then fetched in the following second mode of this xq-file.

(ii) Second mode, then, creates the necessary file_info.xml supplementary metadata-file, to be used as a parameter in the subsequent figMETS2fgs.xsl transformation of each item ($artId_originalMD) to a sip.xml compliant with FGS-CSPackage. As explained, this is also when the actual data files belonging to an item are fetched to the corresponding package subdirectory.
In this mode, then, section 5 (fetching the data files) is turned ON, while it is important that section 0, for splitting up feeds, is turned  *off* (with "out-commenting parentheses and colons), otherwise the "$artId_originalMD" files will suffer inherent duplication, producing non well-formed xml, and making them unfit for use in the next step, the actual figMETS2fgs.xsl transformation.  

Changes to the original version include:
2020-04-30: *Public version 2.0: Removed internal local user db SUKAT-URLs, replacing variable names including 'sukat','su', 'SU' for Stockholm University, with 'local' or 'LOCAL'. Removed also creation of folders / directories for storage of files directly on local disc. These changes then are not reflected in the version history below.
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
declare namespace mets="http://www.loc.gov/METS/";
declare namespace xlink="http://www.w3.org/1999/xlink";
declare namespace dc="http://purl.org/dc/elements/1.1/";
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
declare variable $mdFilePath as xs:string? external := "file:/C:/Users/dummy/Desktop/FeedsFile_info/figsMETSfeed30pacs/figsMETSfeed30-api.figshare.com_v2_oai verb=ListRecords%26metadataPrefix=mets%26set=portal_18%26from=2019-06-01%26until=2019-08-01";
declare variable $path as xs:string? external := "file:/C:/Users/dummy/Desktop/FeedsFile_info/";
let $fileParent := if (contains($mdFilePath,'file:/')) then file:parent($mdFilePath) else $path
let $pathChildren := file:children($path)
let $docMD := doc($mdFilePath)

(:-------  0. Splitting-up  figsMETSfeeds:  
                 'turn-off' for use on individual items "_originalMD" -----> :)

let $itemSplit := for $i in $docMD//OAI-PMH:record  return $docMD//$i
let $origID :=   for $j in $itemSplit//dc:identifier return concat(substring-after($j,'localPrefix.'),'_originalMD')
let $originalMD := for $j in $origID,$i in $itemSplit 
return file:append(concat($fileParent,$j,".xml"),$i[contains(.//dc:identifier,substring-before($j,'_originalMD'))])

(:<delete me to turn off----- END itemSplit ---------------- :)

(:---------------------- 1. Preliminaries------------------:)
let $artId := for $x in $docMD//dc:identifier return if (contains($x,'.v')) then substring-before(substring-after($x,'localPrefix.'),'.')  else substring-after($x,'localPrefix.')
for $u in $artId
let $url := concat("https://api.figshare.com/v2/articles/",$u)
let $jsonMD := html:parse(unparsed-text($url))
let $json2xml := json:parse($jsonMD)
for $y in ($json2xml)
let $z := if ($y//files//is__link__only/text()='true') then 'LinkOnly' else $y//files//name
let $zURIs := for $n in $z return <fileNameURI>{replace($n,'%20',' ')}</fileNameURI>
let $arrayZ := for $i in $y//files return array{$i//name/text()}
let $arrayU := array{$zURIs/text()} 
let $xURIs := for $x  in $zURIs return if ($x[not(deep-equal($arrayZ,$arrayU))]) then $x else <note>Filename OK</note> 
let $m := $y//files//download__url 
let $w :=  if ($y//embargo__date/@type='null') then 'None'  else $y//embargo__date

(:------- 2. Authors, localAuthorNames & identifiers------------:)

let $authors :=  $y//authors//full__name
let $authorCount := count($authors)

let $localAuthorNames := for $a in $authors return $a[html:parse(unparsed-text(concat("localDB-URL",encode-for-uri($a))))//a/@href[contains(.,'person.jsp?')]] 

let $localAuthor1 := for $a in $localAuthorNames[1] return html:parse(unparsed-text(concat("localDB-URL",encode-for-uri($a))))//a/@href[contains(.,'person.jsp?')]
let $localAuthor2 := for $a in $localAuthorNames[2] return html:parse(unparsed-text(concat("localDB-URL",encode-for-uri($a))))//a/@href[contains(.,'person.jsp?')]

let $localId1 := for $i in $localAuthor1 return (substring-before(substring-after($i,'person.jsp?dn=uid%3D'),'%2Cdc'))
let $localId2 := for $i in $localAuthor2 return (substring-before(substring-after($i,'person.jsp?dn=uid%3D'),'%2Cdc'))
let $localId := if ((count($localId1) > 1) and (string-length($localId2) > 1)) then ($localId2) else $localId1[1] 

let $authInvRaw := for $c in (substring-before($y//citation,'):')) return (tokenize($c,';'))
let $authInv := for $i in $authInvRaw return replace($i,' \(\d\d\d\d','')
let $authInvPur := for $i in $authInv return replace($i,'^ ','')

let $localAuthorInvert1 := for $c in ($localAuthorNames[1]) return reverse(tokenize($c,' '))
let $localAuthInv1 := for $a in ($localAuthorInvert1[1]) return $authInvPur[contains(.,$a)]
let $localAuthorInvert2 := for $c in ($localAuthorNames[2]) return reverse(tokenize($c,' '))
let $localAuthInv2 := for $a in ($localAuthorInvert2[1]) return $authInvPur[contains(.,$a)]

let $localAuthorInvert := if ((count($localId1) > 1) and (string-length($localId2) > 1)) then $localAuthInv2 else $localAuthInv1

let $prefLOCALauthLname := replace(substring-before($localAuthorInvert,','),' ','')
let $prefLOCALauthLNuri := encode-for-uri($prefLOCALauthLname)
let $localAuth1ORCiDinFigs := for $a in $localAuthorNames[1] return ($a/following-sibling::orcid__id)let $localAuth2ORCiDinFigs := for $a in $localAuthorNames[2] return ($a/following-sibling::orcid__id)
let $prefLOCALauthORCiDinFigs := if ((count($localId1) > 1) and (string-length($localId2) > 1)) then $localAuth2ORCiDinFigs else $localAuth1ORCiDinFigs

let $localAuth1ORCiDurl := for $i in $localAuthorNames[1] return (html:parse(unparsed-text(concat("https://pub.orcid.org/v2.1/search?q=%22", encode-for-uri(($i)),"%22")))//uri)
let $localAuth2ORCiDurl := for $i in $localAuthorNames[2] return (html:parse(unparsed-text(concat("https://pub.orcid.org/v2.1/search?q=%22", encode-for-uri(($i)),"%22")))//uri)
let $prefLOCALauthORCiDurl := if ((count($localId1) > 1) and (string-length($localId2) > 1)) then $localAuth2ORCiDurl else $localAuth1ORCiDurl


let $prefLOCALauthORCiD := if (string-length($prefLOCALauthORCiDinFigs) > 1 ) then concat('https://orcid.org/',$prefLOCALauthORCiDinFigs) else $prefLOCALauthORCiDurl
let $pX := if (count($prefLOCALauthORCiD) >= 1) then $prefLOCALauthORCiD else if (string-length($prefLOCALauthORCiD) = 0) then 'None' else $prefLOCALauthORCiD

let $ORCount := count($prefLOCALauthORCiD) 
let $localCount := count($localId) 

(:---- Departments/Institutions and Inst.numbers for METS:AGENT @ROLE="ARCHIVIST" ----:)

let $localAuthor1Inst := for $a in $localAuthorNames[1] return (html:parse(unparsed-text(concat("localDB-URL",encode-for-uri($a))))//a/@href[contains(.,'org.jsp?')])
let $localAuthor2Inst := for $a in $localAuthorNames[2] return (html:parse(unparsed-text(concat("localDB-URL",encode-for-uri($a))))//a/@href[contains(.,'org.jsp?')])

let $stepA := if ((count($localId1) > 1) and (string-length($localId2) > 1)) then $localAuthor2Inst[1] else $localAuthor1Inst[1] 
let $step1 := tokenize(substring-after($stepA,'%3D'),'%2Co')
let $step2 := for $i in ($step1) return if (contains($i,'nstitut')) then $i[contains($i,'nstitut')] else if (contains($i,'bibliotek')) then $i[contains($i,'bibliotek')] else (if (contains($i,'Centr')) then $i[contains($i,'Centr')] else ())
let $step2b := if (count($step2) > 1) then $step2[2] else $step2 
let $step3 := if ($step2b != $step1[1]) then replace($step2b,'u%3D','') else $step2b
let $step4 := for $p in $step3 return replace($p,'\+',' ')
let $step5 := for $q in $step4 return replace($q,'%C3%A4','ä')
let $step6 := for $r in $step5 return replace($r,'%C3%B6','ö')
let $step7 := for $s in $step6 return replace($s,'%C3%A5','å')

let $instNrList := "localDepartmentsList-URL"
let $instNrCList := for $c in (html:parse(unparsed-text($instNrList))//text()) return replace($c,',','')
let $instLOCALlist := for $i in $step7 return ($instNrCList)[matches(.,$i)][1]
let $archivalInstList := for $i in $step7 return (if (contains($i,'bibliotek')) then (html:parse(unparsed-text($instNrList))//text()[contains(.,'bibliotek')]) else (if(contains($i,'Resilien')) then (html:parse(unparsed-text($instNrList))//text()[contains(.,'Resilien')]) else $instLOCALlist)[1])
let $archivalInst := for $i in $archivalInstList return substring-after($i,' ')
let $instNum := for $i in $archivalInstList return substring-before(substring-after($i,'&#xA;'),' ')

(:------ Files, folders and result doc: 'file_info.xml' -----------:)

let $mimeTypes := for $t in $m return fetch:content-type($t)
let $subFold := if (contains($mdFilePath,'https://')) then (file:create-dir("file:/C:/Users/dummy/FeedsFile_info/subFold/")) else ()
let $manDLname := if(($y//files//is__link__only/text()='true') or (string-length($y//files) = 0 ))  then <manualFileName>Replace by manually downloaded filename!</manualFileName> else ()
let $manDLsize := if(($y//files//is__link__only/text()='true') or (string-length($y//files) = 0 ))  then <manualFileSize>Replace by manually downloaded fileSize!</manualFileSize> else ()
let $manDLmd5 := if(($y//files//is__link__only/text()='true') or (string-length($y//files) = 0 ))  then <manualMD5>Replace by manually downloaded MD5!</manualMD5> else ()
let $warn := if (not($localId) or ($ORCount > 1) or ($localCount > 1)) then ('ID-check!') else if(($y//files//is__link__only/text()='true') or (string-length($y//files) = 0 )) then ('Manual file download!') else ('None') 
let $doc := <file_info cite="{$y//citation}" DOI="{$y//doi}" pubDate="{$y//published__date}" fileInfo-harvestDate="{current-dateTime()}" SW-Agent_eFFIxq="{'v0.9992'}" FILELIST="{if(($y//files//is__link__only/text()='true') or (string-length($y//files) = 0 ))  then 'external' else $z}" FILENAMECOUNT="{if(($y//files//is__link__only/text()='true') or (string-length($y//files) = 0 ))  then 0 else count($z)}" LicenseURL="{$y//license/url}" LicenseNAME="{$y//license/name}" EMBARGODATE="{$w}" prefLOCALauthorNameInv="{$localAuthorInvert}" prefLOCALauthORCiD="{$pX}" localID="{$localId}" archivalInst="{$archivalInst[1]}" localInstnr="{$instNum[1]}" ALERT="{$warn}">{$y//files, <mimeTypes>{$mimeTypes}</mimeTypes>,$xURIs, $manDLname, $manDLsize, $manDLmd5, $y//references, $y//funding__list,$y//custom__fields}</file_info>

(:---- 3. Create item Folders: deprecated. 
Use Bash script:  "dir-mvOrigMD.sh" 
in bin for this. Earlier turned off for use on individual items.  

let $itemFolds := for $i in $doc return if (contains($mdFilePath,'https://')) then file:create-dir(concat($fileParent,'subFold/',$prefLOCALauthLNuri,substring-after($y//doi,'sthlmuni.'))) else file:create-dir(concat($fileParent,$prefLOCALauthLname,substring-after($y//doi,'sthlmuni.')))
let $itemOriginals := for $j in (doc($mdFilePath)//record) return doc($j)
   ---  :)

(:--- 4. Create file_info.xml - parameter file for xslt --- :)

let $result := file:append(if (contains($mdFilePath,'https://')) then ("file:/C:/Users/dummy/FeedsFile_info/subFold/file_infoFeed.xml") else (concat($fileParent,"/file_info.xml")), $doc) 
 
 
(:---- 5. Fetch data files of individual items -----
                (turn off for feeds --- delete me-> :)

let $fetchFiles := for $f in $m return if (not(contains($f,'ndownloader.figshare'))) then () else file:write-binary(concat($fileParent,replace(replace(replace(replace($f/preceding-sibling::name/text(),' ','_'),'å','a'),'ä','a'),'ö','o')),lazy:cache(fetch:binary($f)))  

(:<-delete me to turn off for feeds --- :)

return $doc


