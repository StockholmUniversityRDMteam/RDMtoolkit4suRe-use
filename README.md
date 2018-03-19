# figs2FGS-CSPackage
This repository will now for a start contain two files, one .xquery and one xslt, for the purpose of harvesting METS-files from the su.figshare.com instance by means of OAI-PMH, and transforming them to sip metadatafiles compliant with the Riksarkivet (RA) - National Archives of Sweden model FGS (Förvaltningsgemensam specifikation) - CSPackage (Common Specification). Since the METS file metadata obtained from figshare via OAI-PMH is insufficient for this purpose, it has to be complemented by metadata drawn from the source-code of the corresponding HTML-pages of the different items ("articles"), where the file metadata is stored in Javascript JSON-arrays. This is why the .xquery file is needed.

The xq-file is for extraxting figshare filedata from the JSON-arrays inherent in the corresponding html-pages of the DOI:s found in the dc:identifier-elements of the OAI-PMH-feeds, where these filedata are not as complete, lacking e.g. md5 CHECKSUMS and original filenames with extensions, from which MIMETYPE can be constructed in the transformation to FGS-CSPackage. The first declared variable in the .xq-file, $mdFilePath is your input file, the OAI-PMH-feed downloaded as an xml-file.The resulting "file_info feed" from running the xquery is not a wellformed xml-file yet, a root-element must be added in a local xml-editor, but it contains all filedata from the corresponding JSON-arrays of the corresponding html-pages, converted to xml. These will then be used as a parameter document in the transformation of the original feed data to FGS-CSPackage.

The xslt-file currently has 3 parameters to be specified in the setup: 

deliveryFeedType = 'oai'
deliveryMethodId = '3'
file_info_data = 'doc('${cfdu}/file_info.xml')' 

where the last is most essential and shoud be set up as an XPath expression (tick the box).
For the time being it should be run only for individual items, thus extracted from the resulting feeds, but this might change for coming versions, so that you could run it for a whole feed at a time.
Also, the file-extension to mime-type map inherent in this first version should be extended to cover many more possible file-extensions, such as e.g. .csv, .py, etc.

It should also be remarked that that the xslt-file contains a certain amount of preliminary hard coding (especially in the METS-header), awaiting recommended values from the development of a dedicated FGS - Common Specification model for research information and / or research datasets. This might produce also the necessity of adding further extension elements and / or attributes to the METS-file.

To work together, the specific 'file_info.xml' parameter doc (created by the .xquery) and the item xml-file (extracted from the OAI-PMH-feed) on which to run the xslt, should both be in the same folder.

