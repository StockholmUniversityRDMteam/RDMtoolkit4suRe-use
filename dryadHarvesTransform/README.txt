**dryadHarvesTransform** has 6 scripts + a 0-list.txt of deliveries, numbered after usage order.  
First check that the  _0dryadUpdateList.txt_  is uppdated with latest deliverydate on line 7.  
Then bash 1dryadUpdate.sh downloads native metadata as JSON for new/updated (modified) datasets, with at least one SU-affiliated contributor, saved as a JSON-fil  _dryadSUaffiliatesUpdateYYYYMMDD.json_ (current = harvesting date). In the  header _count/total_ shows how many datasets .  Convert the json-file to XML _dryadSUaffiliatesUpdateYYYYMMDD.xml_ in Oxygen  with Tools> JSON Tools>JSON.  
Copy Location for the resulting XML-file and open BaseX - dryad2splitUpdateFile.xq. Paste this on line 13 as your $mdFilePath (in ” ” , + corresponding path (shortened to the parent folder) in $parent  (line 14). Run BaseX!  > Ctrl+Enter
Go back to GitBASH current `cd dryadSUaffiliatesUpdateYYYYMMDDjson2xml`,  run: `bash  ../dryad3mvOrigMD.sh`. 
This should also copy-paste the current folder _dryadSUaffiliatesUpdateYYYYMMDDjson2xml_  with all its contents to /MADIArkiv/…  or wherever you want to place it locally, by changing the path in _dryad3mvOrigMD.sh_]  
In Oxygen, _Copy Location_ for *_originalMD.xml* of the first package; paste in BaseX  - _dryad4extractFileInfo.xq_, on line 40 as $mdFilePath (between ” ”).  Run BaseX (_Ctrl+Enter_)
Check in Oxygen; in the same parent folder there should now also be a file named _file_info.xml_ and a subfolder _data_ with one or more datafiles. 
After running all *_originalMD.xml* in BaseX, go back to GitBASH: 
`cd /m/MADIArkiv/dryadHarvesTransform/dryadSUaffiliatesUpdateYYYYMMDDjson2xml` and `bash ../  dryad5MADIArkDataCheXpand.sh`.  
Back in Oxygen: in each package folder open  _file_info.xml_ for inspection, Format and Indent (Ctrl+Shift+P). Check in particular e.g. ORCID and ALERT=”None”. Save (Ctrl+S) and Close (Ctrl+W).
Open for each the corresponding  *_originalMD.xml* and then run the XSLT transformation file _dryad6DataCite2FGS.xsl_ . The resulting file _METS.xml_ is automatically opened and saved.
Use XPath //file or Outline to check file names in OWNERID, MIMETYPE etc.  
