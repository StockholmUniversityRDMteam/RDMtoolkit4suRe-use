(:v0.1 Latest update:2024-07-25 Changed $path to $parent :)

declare namespace mets="http://www.loc.gov/METS/";
declare namespace xlink="http://www.w3.org/1999/xlink";
declare namespace datacite="http://datacite.org/schema/kernel-4";
declare namespace dc="http://purl.org/dc/elements/1.1/";
declare namespace lazy="http://basex.org/modules/lazy";
declare namespace local="local";
(:declare namespace OAI-PMH="http://www.openarchives.org/OAI/2.0/";:)


declare variable $recursive := true(); 
declare variable $mdFilePath as xs:string? external := "file://dryadHarvesTransform/dryadPages20240725json2XMLoutput/dryadSUaffiliatesPage4/dryadSUaffiliatesPage4-api2024-07-25.xml";
declare variable $parent as xs:string? external := "file://dryadHarvesTransform/dryadPages20240725json2XMLoutput/dryadSUaffiliatesPage4";
let $fileParent := if (contains($mdFilePath,'file:/')) then file:parent($mdFilePath) else $parent
let $docMD := doc($mdFilePath)

(:--- 0. Splitting-up  dryad PagesFeeds from dryad2nd-mvPageFeeds.sh ---:)
                                  
let $itemSplit := for $i in $docMD//stash_X3a_datasets  return $docMD//$i
let $origID :=   for $j in $itemSplit/identifier return concat(substring-after($j,'/'),'_originalMD')
let $originalMD := for $j in $origID,$i in $itemSplit 
return file:append(concat($fileParent,$j,".xml"), $i[contains(./identifier,substring-before($j,'_originalMD'))])
(:[position()[$j]]:)
return $originalMD 