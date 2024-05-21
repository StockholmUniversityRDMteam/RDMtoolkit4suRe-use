# Stockholm University _harvest combine_ for research data published in external repositories   

Here we will keep the tools used for harvesting and transforming for archival purpose research data deposited by Stockholm University affiliated researchers in repositories such as Dryad, Figshare and  Zenodo.
.
\[This project in part corresponds to the repository kept as (https://gitlab.com/JoakimPhilipson/StockholmUniversityRDMteamTransfer/wikis/Stockholm-University-Research-Data-Harvestor-and-Transformer/)

To start with we provided the tools used for this purpose in the management of our su.figshare.com institutional instance. These have now developed from two basic files, one .xquery and one .xslt (+ a bash-script.sh for the creation of directories or subfolders, and moving original metadata files for items), for the purpose of harvesting METS-files from the *su.figshare.com* instance by means of OAI-PMH, and transforming them to sip metadatafiles compliant with the *Riksarkivet* (RA) - *National Archives of Sweden* model FGS (Förvaltningsgemensam specifikation) - CSPackage (Common Specification). Since the METS file metadata obtained from figshare via OAI-PMH is insufficient for this purpose, it is supplemented by metadata from the Figshare API, from ORCID.

The _extractFigsFileInfo.xq_ file is for extracting figshare file metadata and datafiles, by means of the base API "https://api.figshare.com/v2/articles/" as a complement to the OAI-PMH-feeds in METS (base API - "https://api.figshare.com/v2/oai?verb=ListRecords&metadataPrefix=mets"), where these filedata are not as complete, lacking e.g. md5 CHECKSUMS and original filenames with extensions, from which MIMETYPE can be constructed in the transformation to FGS-CSPackage. The former FGS1.2 (2017) [Förvaltningsgemensam specifikation för paketstruktur för e-arkiv. Specifikation, RAFGS1V1.2](https://riksarkivet.se/Media/pdf-filer/doi-t/FGS_Paketstruktur_RAFGS1V1_2.pdf), for the earlier FGS-CSPackage structure, has now been replaced by **FGS Paketstruktur 2.0** Förvaltningsgemensam specifikation för paketstruktur för e-arkiv RAFGS1V2.0, an implementation of: [Common Specification for Information Packages E-ARK CSIP version 2.1.0](https://earkcsip.dilcis.eu/pdf/eark-csip.pdf) and [Specification for Submission Information Packages E-ARK SIP version 2.1.0.](https://earksip.dilcis.eu/pdf/eark-sip.pdf). 

The declared external variable _$mdFilePath_ is your input file, the "\_originalMD"-item produced after splitting up of the Figshare OAI-PMH-feed in METS format, received e.g.  by "https://api.figshare.com/v2/oai?verb=ListRecords&metadataPrefix=mets&set=portal\_NN&from=2023-11-10&until=2023-12-31" (where 'set=portal\_NN' represent the local instance of Figshare). It is now automatically retrieved by means of another BASH script, _figMETSfeedfirst.sh_ , using curl. 

The initial resulting "file\_info feed" from running this xq-file instead on a complete feed is not a wellformed xml-file yet (unless there is only one item in the input file $mdFilePath), a root-element must be added in a local xml-editor, but it contains all the necessary file metadata needed for the transform. These will then be used as a parameter document (file_info.xml) in the transformation of the original feed metadata to FGS-CSPackage, the METS-based standard for Submission Information Packages (SIPs) of the Swedish National Archives. 

In the present workflow, this xq-file thus has two different "modes", with different sections activated:

(i) First mode is for splitting up an OAI-PMH METSfeed into separate items, "$artId\_originalMD", and by default producing the "file_infoFeed", which must be appended (at present manually) with a root-element [formatted e.g. as <file\_infoFeed nr="30" extractFigsFileInfo.xq="v0.9992" prodate="2020-04-29"> </file_infoFeed> ] to become well-formed xml. This will serve as a kind of ToC, together with the corresponding original METSfeed in the final figsMETSfeedNNpacs directory.
In this mode, **section 0** is turned **on** (by removing the commenting  colons with parentheses), and *section 5* (for fetching data files) is turned *off*.

It is possible that the steps in this first mode in the future workflow will also be part of the bash script (*dir-mvOrigMD.sh*) that now is run after this, presently only creating package subdirectories and moving the individual items resulting from the METS feedsplit-up ($artId_originalMD) into these subdirectories, to which the actual data files belonging with each item are then fetched in the following second mode of this xq-file.

(ii) Second mode, then, creates the necessary _file\_info.xml_ supplementary metadata-file, to be used as a parameter in the subsequent *figMETS2fgs.xsl* transformation of each item ($artId_originalMD) to a *sip.xml* that is compliant with FGS-CSPackage. As explained, this is also when the actual data files belonging to an item are fetched to the corresponding package subdirectory.
In this mode, then, **section 5** (fetching the data files) is turned **ON**, while it is important that section 0, for splitting up feeds, is turned *off* (with "out-commenting parentheses and colons), otherwise the "$artId_originalMD" files will suffer inherent duplication, producing non well-formed xml, and making them unfit for use in the next step, the actual figMETS2fgs.xsl transformation.

The xslt-file now has 2 parameters to be specified in the setup:
`
* `file_info_data = 'doc('${cfdu}/file_info.xml')'`
* filext2mimetypeMap = 'doc('${cfdu}/filext2mimetypeMapMAIN.xml')'

both essential, to be set up as XPath expressions (tick the box). For they should be run only for individual items, that have been split up from the original feeds.

The xslt-file contains a certain amount of preliminary hard coding (especially in the METS-header), awaiting recommended values from the development of a dedicated FGS - Common Specification model for research information and / or research datasets. This might produce also the necessity of adding further extension elements and / or attributes to the METS-file.

To work together, the specific 'file_info.xml' parameter doc (created by the .xquery) and the item xml-file (extracted from the OAI-PMH-feed) on which to run the xslt, should both be in the same folder.

The bash script-file, *dir-mvOrigMD.sh* in this repository is for making package folders and moving the items of original metadata files \*MD.xml, that were splitted up from the original METS-feed, in to their respective package folders, were subsequently also their associated data files will end up in the next run of the xq-file.

Thus the whole workflow is still under revision and developed continuously.
