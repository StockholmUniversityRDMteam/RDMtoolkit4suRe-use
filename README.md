# figs2FGS-CSPackage
This repository contains two files, one XQuery *extractFigsFileInfoPublic.xq* and one XSLT *figMETS2fgs.xsl*, for the purpose of harvesting METS-files from the su.figshare.com instance by means of OAI-PMH, and transforming them to sip metadata files compliant with the Riksarkivet (RA) - *National Archives of Sweden* model FGS ("Förvaltningsgemensam specifikation") - CSPackage (Common Specification). 

The xq-file is for extracting figshare filedata by means of the base API "https://api.figshare.com/v2/articles/" as a complement to the OAI-PMH-feeds in METS (base API - https://api.figshare.com/v2/oai?verb=ListRecords&metadataPrefix=mets), where these filedata are not as complete, lacking e.g. md5 CHECKSUMS and original filenames with extensions, from which the required attribute @MIMETYPE can be constructed in the transformation to FGS-CSPackage. (In an earlier version of this xq-file these filedata were instead extracted from the JSON-arrays inherent in the corresponding html-pages of the DOI:s found in the dc:identifier-elements of the OAI-PMH-feeds, but these were later also found to be incomplete, in particular for items with more than 10 associated datafiles.) The first declared variable in the .xq-file, *$mdFilePath* is your input file, the OAI-PMH-feed, as a URL or (better), downloaded as an xml-file. The resulting "file_info feed" from running the xquery is not a wellformed xml-file yet, a root-element must be added, unless the $mdFilePath contains only one item (recommended; could be obtained simply by splitting up the original feed into single item xml-files). The resulting *file_info.xml* from running the xquery anyway contains all necessary file metadata from the api plus some extra data drawn from ORCID and user info from a local database. (The search URL:s for the local database SUKAT user data have been removed here in the public version, but with the variable names preserved, to be replaced if needed by other local metadata sources.)  This *file_info.xml* will then be used as a parameter document in the transformation of the original feed data to FGS-CSPackage by the xslt-file *figMETS2fgs.xsl*. The new .xquery-file has an inherent 'readme' comment section and version history, describing internal development before this newest version is published.   

The xslt-file has 3 parameters to be specified in the setup: 

deliveryFeedType = 'oai'

deliveryMethodId = '3'

file_info_data = 'doc('${cfdu}/file_info.xml')' 

where the last is most essential and should be set up as an XPath expression (tick the box).
For the time being it should be run only for individual items, thus extracted from the resulting feeds, but this might change for coming versions, so that you could run it for a whole feed at a time.
Also, the file-extension to mime-type map has been extended and updated to cover many more file-extensions, such as *.csv, .py, .R, .Rmd*  etc. For later additions of file extensions to the mapping table, sources and dates are also shown, adding (meta)data provenance.
The xslt-file also has an inherent version history.

Please note that the xslt-file still contains some preliminary hard coding (especially in the METS-header), awaiting recommended values from the development of a dedicated FGS - Common Specification model for research information and / or research datasets. This might necessitate adding further extension elements and / or attributes to the METS-file.

To work together, the *file_info.xml* parameter doc (created by the .xquery) and the item xml-file (extracted from the OAI-PMH-feed) on which to run the xslt, should both be in the same folder. If the local path of the item xml-file is used already for *$mdFilePath* in running the xquery, this will happen "automatically" when using the default end return _$result_. (If using a URL instead, the end return before running the xquery should be changed to _$doc_ .) 

The result of running the xslt-file, then, on the original item xml-file will be a *sip.xml* file compliant with the FGS-CSPackage http://xml.ra.se/e-arkiv/METS/CSPackageMETS.xsd and http://xml.ra.se/e-arkiv/METS/CSPackageExtensionMETS.xsd. The *sip.xml* file should be packaged together with the original metadata item xml-file and the associated data files into a SIP that is fit for delivery to the National Archives of Sweden or a local digital archive.

