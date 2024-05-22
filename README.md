# Stockholm University _harvest combine_ for research data published in external repositories   

Here we will keep the tools used for harvesting and transforming for archival purpose research data deposited by Stockholm University affiliated researchers in repositories such as Dryad, Figshare and  Zenodo.

\[This project in part corresponds to the repository kept as (https://gitlab.com/JoakimPhilipson/StockholmUniversityRDMteamTransfer/wikis/Stockholm-University-Research-Data-Harvestor-and-Transformer/)

To start with we provided the tools used for this purpose in the management of our Figshare institutional instance. These have now developed from two basic files, one .xquery and one .xslt (+ a bash-script.sh for the creation of directories or subfolders, and moving original metadata files for items), for the purpose of harvesting METS-files from the *su.figshare.com* instance by means of OAI-PMH, and transforming them to sip metadatafiles compliant with the *Riksarkivet* (RA) - *National Archives of Sweden* model FGS (Förvaltningsgemensam specifikation) - CSPackage (Common Specification). Since the METS file metadata obtained from Figshare via OAI-PMH is insufficient for this purpose, it is supplemented by metadata from the Figshare API and other sources.

The _extractFigsFileInfo.xq_ file is for extracting figshare file metadata and datafiles, by means of the base API "https://api.figshare.com/v2/articles/" as a complement to the OAI-PMH-feeds in METS (base API - "https://api.figshare.com/v2/oai?verb=ListRecords&metadataPrefix=mets"), where these filedata are not as complete, lacking e.g. md5 CHECKSUMS and original filenames with extensions, from which MIMETYPE can be constructed in the transformation to FGS-CSPackage. The former FGS1.2 (2017) [Förvaltningsgemensam specifikation för paketstruktur för e-arkiv. Specifikation, RAFGS1V1.2](https://riksarkivet.se/Media/pdf-filer/doi-t/FGS_Paketstruktur_RAFGS1V1_2.pdf), for the earlier FGS-CSPackage structure, has now been replaced by **FGS Paketstruktur 2.0** Förvaltningsgemensam specifikation för paketstruktur för e-arkiv RAFGS1V2.0, an implementation of: [Common Specification for Information Packages E-ARK CSIP version 2.1.0](https://earkcsip.dilcis.eu/pdf/eark-csip.pdf) and [Specification for Submission Information Packages E-ARK SIP version 2.1.0.](https://earksip.dilcis.eu/pdf/eark-sip.pdf). Most of the files needed for **Figshare** harvest and transformation are now in the **figsHarvesTransform** directory. Only older versions and files that are common to the harvest and transformation for all repositories are directly at the root, notably the important parameter file _filext2mimetypeMapMAIN.xml_.  

In _extractFigsFileInfo.xq_ the declared external variable _$mdFilePath_ is your input file, the "\_originalMD"-item produced after splitting up of the Figshare OAI-PMH-feed in METS format, received e.g.  by "https://api.figshare.com/v2/oai?verb=ListRecords&metadataPrefix=mets&set=portal\_NN&from=2023-11-10&until=2023-12-31" (where 'set=portal\_NN' represent the local instance of Figshare). It is now automatically retrieved by means of another BASH script, _figMETSfeedfirst.sh_ , using curl. 

In the present workflow for Figshare, this xq-file has two different "modes", with different sections activated automatically, based on the input file representing a feed woth several item records or an individual item:

(i) First mode is for splitting up an OAI-PMH METSfeed into separate items, "$artId\_originalMD", and by default producing the "file_infoFeed", which is now amended and renamed automatically by the _dir-mvOrigMDfigMETS.sh_ to become well-formed xml. This will serve as a kind of ToC, together with the corresponding original METSfeed in the final figsMETSfeedNNpacs directory.
In this mode, **section 0** is turned **on**, and *section 5* (for fetching data files) is turned *off*.

(ii) Second mode, then, creates the necessary _file\_info.xml_ supplementary metadata-file, to be used as a parameter in the subsequent *figMETS2fgs.xsl* transformation of each item record to a *METS.xml* that is compliant with FGS 2.0. As explained, this is also when the actual data files belonging to an item are fetched to the corresponding package subdirectory. In this mode, then, **section 5** (fetching the data files) is turned **ON**.

The xslt-file now has 2 parameters to be specified in the setup:
`
* `file_info_data = 'doc('${cfdu}/file_info.xml')'`
* filext2mimetypeMap = 'doc('${cfdu}/filext2mimetypeMapMAIN.xml')'

both essential, to be set up as XPath expressions (tick the box). They should preferably be run only on individual items, that have been split up from the original feeds.

The xslt-file contains a certain amount of preliminary hard coding (especially in the METS-header), awaiting recommended values from the development of a dedicated FGS - Common Specification model folderfor research information and / or research datasets. This might produce also the necessity of adding further extension elements and / or attributes to the METS-file.

To work together, the specific 'file_info.xml' parameter doc (created by the _extractFigsFileInfo.xq_) and the item xml-file (split up from the original OAI-PMH-feed) on which to run the xslt, should both be in the same folder.

The bash script-file, *dir-mvOrigMDfigMETS.sh* in this repository is for making package folders and moving the items of original metadata xml files \*MD.xml, that were split up from the original METS-feed, in to their respective package folders, where subsequently also their associated data files will end up in the next run of the xq-file.

With this version comes also a similar directory with 3 script files for Zenodo, **zenHarvesTranform**: _extractZenFileInfo.xq_, _miniSplit.xq_ and _zeno2fgs.xsl_ . For Zenodo is also used the BASH script _dir-mvOrigMD.sh_ , that is located at the root together with the _filext2mimetypeMapMAIN.xml_, outside **zenHarvesTranform**. The use of these scripts for Zenodo is similar to that for Figshare, except there is no first automatic feed fetcher, and instead a separate _miniSplit.xq_ script for doing the split up. (This is partly due to a less frequent influx of new items to our Stockholm University Library community at Zenodo, compared to su.figshare.com, so we tend to make the harvest at irregular intervals, perhaps only once a year.)

We are also developing similar tools for Dryad, soon to be added to this repository. 

