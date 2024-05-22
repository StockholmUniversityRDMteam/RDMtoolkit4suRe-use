declare namespace mets="http://www.loc.gov/METS/";
declare namespace xlink="http://www.w3.org/1999/xlink";
declare namespace datacite="http://datacite.org/schema/kernel-4";
declare namespace dc="http://purl.org/dc/elements/1.1/";
declare namespace lazy="http://basex.org/modules/lazy";
declare namespace local="local";
declare namespace OAI-PMH="http://www.openarchives.org/OAI/2.0/";


declare variable $recursive := true(); 
declare variable $mdFilePath as xs:string? external := "file:/C:/Users/joph9849/Desktop/reposit2fgsCSP/zenHarvesTransform/zenSUBdataCiteFeed04prod20231211R/zenodoFeed04prod20231211R.xml";
declare variable $path as xs:string? external := "file:/C:/Users/joph9849/Desktop/reposit2fgsCSP/zenHarvesTransform/zenSUBdataCiteFeed04prod20231211R";
let $fileParent := if (contains($mdFilePath,'file:/')) then file:parent($mdFilePath) else $path
let $pathChildren := file:children($path)
let $docMD := doc($mdFilePath)

(:-------  0. Splitting-up  zenFeeds: miniSplit.xq
                 'turn-off' for use on individual items "_originalMD" --> :)
                                  
let $itemSplit := for $i in $docMD//OAI-PMH:record  return $docMD//$i

let $origID :=   for $j in $itemSplit//datacite:identifier return if ($j[@identifierType="URL"]) then concat(substring-after($j,'record/'),'_originalMD') else concat(substring-after($j,'zenodo.'),'_originalMD')
let $originalMD := for $j in $origID,$i in $itemSplit 
return file:append(concat($fileParent,$j,".xml"),$i[contains(./OAI-PMH:header/OAI-PMH:identifier,substring-before($j,'_originalMD'))])
(:[position()[$j]]:)
return $originalMD 