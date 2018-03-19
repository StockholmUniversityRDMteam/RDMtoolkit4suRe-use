declare namespace mets="http://www.loc.gov/METS/";
declare namespace xlink="http://www.w3.org/1999/xlink";
declare namespace dc="http://purl.org/dc/elements/1.1/";
declare namespace local="local";

(:This xq-file is for extraxting figshare filedata from the JSON-arrays inherent in the corresponding html-pages of the DOI:s found in the dc:identifier-elements of the OAI-PMH-feeds, where these filedata are not as complete, lacking e.g. md5 CHECKSUMS and original filenames with extensions, from which MIMETYPE can be constructed in the transformation to FGS-CSPackage. The first declared variable $mdFilePath is your input file, the OAI-PMH-feed downloaded as an xml-file.The resulting "file_info feed" from running the xquery is not a wellformed xml-file yet, a root-element must be added in a local xml-editor, but it contains all filedata from the corresponding json-arrays of the corresponding html-pages, converted to xml. These will then be used as a parameter document in the transformation of the original feed data to FGS-CSPackage.:)

declare  variable $mdFilePath as xs:string? external := "file:/C:/Users/joph9849/Desktop/Figshare@SU/ProF/figsMETSfeed0-https%20_api.figshare.com_v2_oai%20verb=ListRecords%26metadataPrefix=mets%26set=portal_18%26from=2014-01-01%26until=2016-10-09.xml";
declare  variable $resultPath as xs:string? external := "file:/C:/Users/joph9849/Desktop/Figshare@SU/ProF/fileTry.xml";


for $x in   doc($mdFilePath)//dc:identifier
(:let $apiDates := replace(substring-after($mdFilePath,"from="),'%26',''):)
let $url := concat("https://doi.org/",$x)
let $jsonFiles := html:parse(unparsed-text($url))//script[@id='app-data']/node()
let $json2xml := json:parse($jsonFiles)
for $y in ($json2xml)
let $z := $y//files//name
let $doc := <file_info cite="{$y//text}" DOI="{$y//citation/doi}" pubDate="{$y//publishedDate}" harvestDate="{current-dateTime()}" FILELIST="{$z}"> {$y//files}</file_info>

return $doc
