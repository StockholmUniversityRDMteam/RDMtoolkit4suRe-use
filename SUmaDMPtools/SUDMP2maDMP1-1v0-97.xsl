<?xml version="1.0" encoding="UTF-8"?> 
<!--2023-04-17 Keeping version 0.97 for special cases with mixed up ORCiD and PI/contact person, but updated fundref-map with entries for Riksantikvarieämbetet / Swedish National Heritage Board. 
    2022-05-08 *New version 0.97 necessary to change from "relative paths" in JSON output to absolute paths, since DMP Online changed document output order to arbitrary(?). Replaced, thus, references in path regexes  "sections\[\d\]" and "questions\[\d\]" with e.g. sections[number/text()=9]/questions[number/text()=3].
    2022-02-22 Version 0.96: Change from $datasetIDstring = //sections[2]/questions[2]/answer/text to $datasetIDstring = replace(//sections[2]/questions[2]/answer/text,' ','') to avoid whitespace in identifiers, and $dataset_idNum2string made conditional on matches($datasetIDstring,'^\d+$') or not, that is whether it is an integer or a string literal.
            Changed the conditions for FAIR-score <A-value>1</A-value so as to match answers to sections[2]/questions[2] and [3]:$datasetIDtype.
            Added condition of ($datasetIDtype = 'other') to (string-length(//sections[2]/questions[3]/answer/text) > 4) for -> <F-value>1</F-value>.
            Inactivated PLACEHOLDER datasets, as no longer needed with the "new" explicit array conversion.
            Changed <grant_id> as first choice from  $DMPexport//funding[1]/array/grant_id/identifier with type 'other'.
            Several deptNames added in "affiliateDept2institutionNrMap" (Criminology, DSV, MISU, MMK et al.)
    2021-12-20  Version 0.95: Refactoring and replacing all instances of 'options/text' with 'options//text' and paths for FAIR-score to 'plan_content//sections', following change of conversion from JSON *array* to XML in Oxygen 24.0. 
            Adding dataset/array and moving Placeholder (possibly now no longer needed) + datasets#1-3 to within <array/> for new validation against madmp-schema-1.1. Adjusted path for main dataset <description> and removed <description> altogether from additional datasets registered in IX: sections[10].
            Making ethical_issues/sensitive_data -> global variable $ethicalNsensitive dataset, identifier string (//sections[2]/questions[2]/answer/text) -> global variable $datasetIDstring , <type> (//sections[2]/questions[3]/answer/options//text) -> global variable $datasetIDtype.
            Mapped additional Departments to Swedish Institution no. and names. Applied functions local:removeHtmltags and local:replacEndash to ethicalReviewAppQ4 text answer.
            Added param DMPexport as document-node from DMPexport.xml (conv. from .json) to get start and end dates of project. 
    2021-11-01  Version 0.94 with new named template for archivalVersions (initial, final) for sections [8] VII:Q1 and [10] IX:Q3. Beginning of sec.[9] VIII:Q3 map for dept ->institutions $affiliateDept2institutionNrMap. Fixed bugs in handling sec. [10] IX:Q1 Additional datasets (table). 
    2021-10-11  Version 0.93: New variable $funderName2fundRefIDmap to make use of Funder info in SU-VR template v. 34 section [9] VIII:Q5-Q7 funder_id, grant_id and funding_status; thus, enhancing compliance with RDA maDMP-1.1.json schema.
    2021-09-09  Version 0.92: Changed in section IX [10]:Q1 conditions for <when test=""/> to depend on string-length instead, since it appears the pre-formatted table will always render //answered = 'true' to this question.
    2021-08-23  Version 0.91: Changed from <language><xsl:value-of select="//sections[9]/questions[4]/answer/options//text"/></language> to <xsl:value-of select="substring(//sections[9]/questions[4]/answer/options//text,0,4)"/> 
                to adapt to next v.34 of template, while retaining compatibility with previous template versions; also corrected ISO-639-3 code for French from 'fre' to 'fra'.
                Also fixed non-validation of dataset identifier *type* for non-answers (empty fields), setting id-type 'other' as default for PLACEHOLDER datasets.
                The <xsl:call-template name="createFAIRscore"/> is now within the <extension/>, since the FAIR-score output is not part of the RDA maDMP-schema-1.1.json . 
    2021-08-05  Version 0.9: Fixed dataset_id when number to string in sections[2]/questions[2] with $dataset_id2string, prefixing *all* dataset_id with 'ID-' to be sure to comply with maDMP-schema-1.1.json, where string is required. 
                Same solution for section IX //sections[10]/questions[1] table.
                Accomodating multiple distributions (access_urls) of re-used datasets (//sections[2]/questions[7]) while removing unneccessary, not required placeholder distribution.
                Similar solution for title and formats of distributed re-used datasets (//sections[2]/questions[12])
                Revision / change of <license_ref> in sections[5]/questions[5]/answer/text.
                Updated filext2mimetypeMap until 20210803; latest entry '.inp' = text/plain.
                Added extension information elements about template, title and id (from API v0), and location/id and version of this XSLT file.  
                Further adjustments and additions of FAIR assessment in sections IV/[5] and V[6]. 
    2021-07-14/30 Version 0.8: Introduction of additional datasets in table of section[10] IX-Q1, 
                  following change to one-phase template Initial and Full/Final in all (to avoid repetition of information entries, questions & answers), 
                  reference list and statement on project end. Answers to former sections[5],q3 changed to q2 to adapt to new q-order in TemplateV33.
                  Added conditions for answers where order of questions have changed, to accomodate older DMP template versions.
                  Further FAIR evaluation measures for section V / sections[6] added, + minor changes in LABEL and Title of dmp (added local:removeHtmlTags).
                          
    2021-06-15 Version 0.7: Substantial changes in FAIR evaluation in section III and addition of section IV:Q5 Licenses. 
    2021-02-15 Version 0.6: Substantial change regarding licenses and adaptation to SU-VRtemplate v23- with multiple licenses possible, 
    both for reused datasets / files (Sec. I/2:Q9) and new, produced in project (IV/5:Q5).    
    2021-01-02/04 Version 0.5: Further FAIR evaluation measures added, sections I [= 2] and II [= 3]. 
        Additional dummy elements for <dataset> and <distribution> with required child-element hardcoded values, 
        to accomodate JSON *arrays*, thus avoiding post-conversion (XML -> JSON) *manual* removal of << ,"" >> in two places.  
     2020-12-30/31  Version 0.4: First steps to FAIR evaluation (section 2) with new template "createFAIRscore",  
        checked that it does not interfere with RDA maDMP-schema-1.1-compliance.  
     2020-11-30     Version 0.3: Fixed distribution with arrays of format as MIME-type from map, license + title.
     2020-11-03/17  Version 0.2: Adapt to rev. template and maDMP v1.1. 
     Change to ...select="//sections[5]/questions[3]/answer/options/replace(text,', but not \(a-e\)','')"
     to accomodate new answer option relating only to list items F-I. 
     2020-09-01     Version 0.1: First attempt ...  / joakim.philipson@su.se -->

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:mets="http://www.loc.gov/METS/"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:local="local-functions"
    xmlns:json="json"
    xmlns:html="http://www.w3.org/1999/xhtml"
    xmlns:xquery="http://www.w3.org/TR/xquery-3/"
    exclude-result-prefixes="xsl xs">
    <xsl:output indent="yes"/>

    <xsl:param name="DMPexport" as="document-node()"/>
    
    <xsl:variable name="filext2mimetypeMap">
        <map>
            <entry filext="aac" mimetype="audio/aac"/>
            <entry filext="alnfaa" mimetype="text/plain" source="personalCommunication"
                date="20190701"/>
            <entry filext="ams" mimetype="application/octet-stream" openwith="https://www.agico.com/text/software/anisoft/anisoft.php" source="SND2021-44"
                date="20210218"/>
            <entry filext="annot" applicationType="https://datatypes.net/freesurfer-file-types"
                mimetype="application/octet-stream" source="https://datatypes.net/" date="20200701"/>
            <entry filext="aspx" mimetype="text/plain" source="datatypes.net" date="20191003"/>
            <entry filext="bdf" mimetype="application/octet-stream" source="JHOVE 1.18.1"
                date="20200326"/>
            <entry filext="bib" mimetype="application/x-bibtex" source="https://datatypes.net/"
                date="20200325"/>
            <entry filext="brf" mimetype="application/x-binary-rdf" source="GraphDB9.2-webinar "
                date="20200514"/>
            <entry filext="bst" mimetype="application/x-bibtex" source="https://datatypes.net/"
                date="20200325"/>
            <entry filext="cbf" mimetype="application/octet-stream"
                source="BaseX9.1/fetch:content-type" date="20190922"/>           
            <entry filext="cdf" mimetype="application/x-netcdf" source="datatypes.net" PUID="fmt/282" date="20210426"/>
            <entry filext="cpg" mimetype="text/plain" source="JHOVE 1.18.1"/>
            <entry filext="css" mimetype="text/css" source="https://datatypes.net/" date="20180712"/>
            <entry filext="csv" mimetype="text/csv" source="https://datatypes.net/" date="20180712"/>
            <entry filext="codeml" mimetype="text/plain" source="JHOVE 1.18.1" date="20191203"/>
            <entry filext="dat" mimetype="text/plain" source="JHOVE 1.18.1" origin="PROGRAMITA"
                date="20201203"/>
            <entry filext="dbf" mimetype="application/octet-stream" source="JHOVE 1.18.1"/>
            <entry filext="dll" mimetype="application/x-msdownload" mimetype2="application/vnd.microsoft.portable-executable" 
                source="https://datatypes.net/open-dll-files" source2="PRONOM" date="20201027" PUID="fmt/899, fmt/900"/>
            <entry filext="dm3" mimetype="application/octet-stream" source="https://datatypes.net/"
                date="20200505" PUID="fmt/1131"/>
            <entry filext="dmp" mimetype="application/vnd.tcpdump.pcap" source="PRONOM"
                date="20200326"/>
            <entry filext="dng" mimetype="image/dng" source="https://datatypes.net/open-dng-files" date="20210303"/>            
            <entry filext="doc" mimetype="application/msword" source="https://datatypes.net/"
                date="20180712"/>
            <entry filext="docx" mimetype="application/vnd.openxmlformats"
                source="https://datatypes.net/" date="20180712"/>
            <entry filext="dta" mimetype="application/octet-stream" source="JHOVE 1.18.1"
                date="20200110"/>
            <entry filext="eeg" mimetype="application/octet-stream" source="https://datatypes.net/"
                date="20210701" openwith="https://bids.neuroimaging.io/"/>
            <entry filext="fif" mimetype="application/octet-stream" source="JHOVE 1.18.1"
                date="20200326"/>
            <entry filext="fig" mimetype="application/matlab-fig" source="https://datatypes.net/"
                date="20200722" PUID="fmt/806"/>
            <entry filext="fits" mimetype="application/octet-stream" source="https://datatypes.net/"
                date="20191003"/>
            <entry filext="gif" mimetype="image/gif" source="https://datatypes.net/" date="20180712"/>
            <entry filext="gii" applicationType="https://datatypes.net/freesurfer-file-types"
                mimetype="application/octet-stream" source="https://datatypes.net/" date="20200701"/>
            <entry filext="graphml" mimetype="text/xml" source="JHOVE 1.18.1" date="20200709"/>
            <entry filext="gz" mimetype="application/x-gzip" source="https://datatypes.net/"
                date="20200506" PUID="x-fmt/266"/>
            <entry filext="htm" mimetype="text/html" source="https://datatypes.net/" date="20180712"/>
            <entry filext="html" mimetype="text/html" source="https://datatypes.net/"
                date="20180712"/>
            <entry filext="inp" mimetype="text/plain" source="JHOVE 1.18.1" source2="http://gretl.sourceforge.net/" openwith="Mplus"
                date="20210803"/>
            <entry filext="ipynb" mimetype="application/octet-stream"
                source="https://datatypes.net/" date="20200331"/>
            <entry filext="irr" mimetype="text/plain" source="JHOVE 1.18.1" origin="PROGRAMITA"
                date="20201203"/>
            <entry filext="jar" mimetype="application/java-archive" source="https://datatypes.net/"
                date="20180712"/>
            <entry filext="jasp" mimetype="application/octet-stream" source="JHOVE 1.18.1"/>
            <entry filext="jpeg" mimetype="image/jpeg" source="https://datatypes.net/"
                date="20180712"/>
            <entry filext="jpg" mimetype="image/jpeg" source="https://datatypes.net/"
                date="20180712"/>
            <entry filext="jr6" mimetype="application/octet-stream" openwith="https://www.agico.com/text/software/remasoft/remasoft.php" source="   https://datatypes.net/open-jr6-files"
                date="20210218"/>
            <entry filext="jrn" mimetype="application/octet-stream" openwith="https://datatypes.net/sap-pos-file-types" source="https://datatypes.net/open-jrn-files"
                date="20210303"/>
            <entry filext="js" mimetype="text/javascript" source="https://datatypes.net/"
                date="20180712"/>
            <entry filext="json" mimetype="text/plain" source="JHOVE 1.18.1"/>
            <entry filext="label" applicationType="https://datatypes.net/freesurfer-file-types"
                mimetype="application/octet-stream" source="https://datatypes.net/" date="20200630"/>
            <entry filext="m" mimetype="application/matlab-m" source="https://datatypes.net/"
                date="20180712"/>
            <entry filext="m4v" mimetype="video/x-m4v" source="https://datatypes.net/"
                date="20180712"/>
            <entry filext="mat" mimetype="application/matlab-mat" source="https://datatypes.net/"
                date="20190118"/>
            <!-- Please note that same file extension '.mat' is also used for Microsoft Access Table, with mime-type: application/vnd.ms-access! -->            
            <entry filext="mb" mimetype="text/plain" source="JHOVE 1.18.1" date="20200109"/>
            <entry filext="md" mimetype="text/markdown" application="Markdown" source="PRONOM"
                date="20200709" PUID="fmt/1149"/>
            <entry filext="mgh" applicationType="https://datatypes.net/freesurfer-file-types"
                mimetype="application/octet-stream" source="https://datatypes.net/" date="20200630"/>
            <entry filext="mgz" applicationType="https://datatypes.net/freesurfer-file-types"
                mimetype="application/octet-stream" source="https://datatypes.net/" date="20200630"/>
            <entry filext="mp3" mimetype="audio/mpeg" source="https://datatypes.net/"
                date="20180712"/>
            <entry filext="mp4" mimetype="video/mp4" source="https://datatypes.net/" date="20180712"/>
            <entry filext="mpeg" mimetype="video/mpeg" source="https://datatypes.net/"
                date="20180712"/>
            <entry filext="mpg" mimetype="video/mpeg" source="https://datatypes.net/"
                date="20180712"/>
            <entry filext="mxd" mimetype="text/plain" source="JHOVE 1.18.1" date="20200330"/>
            <entry filext="nc" mimetype="application/x-netcdf" source="DROID v6.4" PUID="fmt/282"
                date="20191117"/>
            <entry filext="ncml" mimetype="text/xml" source="JHOVE 1.18.1"/>
            <entry filext="netCDF" mimetype="application/x-netcdf" source="PRONOM" PUID="fmt/282" date="20210426"/>     
            <entry filext="newick" mimetype="text/plain" source="JHOVE 1.18.1" date="20191203"/>
            <entry filext="nex" mimetype="text/plain"/>
            <entry filext="nexml" mimetype="text/xml" source="JHOVE 1.18.1"/>
            <entry filext="nhx" mimetype="text/plain"/>
            <entry filext="nxs" mimetype="text/plain" source="JHOVE 1.18.1" date="20200109"/>
            <entry filext="odp" mimetype="application/vnd.oasis.opendocument.presentation"
                source="https://datatypes.net/" date="20180712"/>
            <entry filext="ods" mimetype="application/vnd.oasis.opendocument.spreadsheet"
                source="https://datatypes.net/" date="20180712"/>
            <entry filext="odt" mimetype="application/vnd.oasis.opendocument.text"
                source="https://datatypes.net/" date="20180712"/>
            <entry filext="otf" applicationType="https://datatypes.net/amp-font-viewer-file-types"
                mimetype="application/vnd.ms-opentype" source="https://datatypes.net/"
                date="20200630"/>
            <entry filext="out" mimetype="text/plain" source="JHOVE 1.18.1" date="20191203"/>
            <entry filext="pdf" mimetype="application/pdf" source="JHOVE 1.18.1"/>
            <entry filext="ph" mimetype="application/octet-stream" source="https://datatypes.net/"
                date="20180712"/>
            <entry filext="phy" mimetype="application/octet-stream" source="https://datatypes.net/"
                date="20180712"/>
            <entry filext="phylip" mimetype="text/plain" source="JHOVE 1.18.1" date="20191203"/>
            <entry filext="PhyloXML" mimetype="application/xml"/>
            <entry filext="png" mimetype="image/png" source="JHOVE 1.18.1"/>
            <entry filext="ppt" mimetype="application/vnd.ms-powerpoint"/>
            <entry filext="pptx" mimetype="application/vnd.ms-powerpoint"/>
            <entry filext="prj" mimetype="text/plain" source="JHOVE 1.18.1"/>
            <entry filext="prn" mimetype="text/plain" source="JHOVE 1.18.1" date="20200330"/>
            <entry filext="pth" mimetype="text/x-python" source="https://datatypes.net/"
                date="20200330"/>
            <entry filext="py" mimetype="text/x-python" source="https://datatypes.net/"
                source2="BaseXQ:fetch:content-type()" date="20180207"/>
            <entry filext="pyc" mimetype="application/x-python-code"
                source="BaseXQ:fetch:content-type()" date="20200504"/>
            <entry filext="qpj" mimetype="application/octet-stream" source="https://datatypes.net/"
                date="20200331"/>
            <entry filext="rar" mimetype="application/vnd.rar" source="PRONOM" date="20201027" PUID="x-fmt/264(?)"/>
            <entry filext="raw" mimetype="text/plain" source="JHOVE 1.18.1" date="20200330"/>           
            <entry filext="R" mimetype="text/x-rsrc"
                source="https://www.digipres.org/formats/sources/githublinguist/formats/#307"
                date="20200317"/>
            <entry filext="r" mimetype="text/x-rsrc"
                source="https://www.digipres.org/formats/sources/githublinguist/formats/#307"
                date="20200331"/>
            <entry filext="RData" mimetype="text/x-rsrc"
                source="https://www.digipres.org/formats/sources/githublinguist/formats/#307-byAnalogy"
                date="20200317"/>
            <entry filext="Rda" mimetype="text/x-rsrc"
                source="https://www.digipres.org/formats/sources/githublinguist/formats/#307-byAnalogy"
                date="20200317"/>
            <entry filext="RDS" mimetype="text/x-rsrc"
                source="https://www.digipres.org/formats/sources/githublinguist/formats/#307-byAnalogy"
                date="20200614"/>
            <entry filext="Rmd" mimetype="text/x-gfm"
                source="https://www.digipres.org/formats/sources/githublinguist/formats/#313"
                date="20190319"/>
            <entry filext="rst" applicationType="restructuredText" mimetype="text/plain" source="JHOVE 1.18.1"
                date="20200723"/>
            <entry filext="sav" mimetype="application/octet-stream" source="JHOVE 1.18.1"
                date="20191216" PUID="fmt/638"/>
            <entry filext="sbn" mimetype="application/octet-stream" source="JHOVE 1.18.1"/>
            <entry filext="sbx" mimetype="application/octet-stream" source="JHOVE 1.18.1"/>
            <entry filext="seaview" applicationType="seaview.exe" url="http://doua.prabi.fr/software/seaview" mimetype="text/plain" source="JHOVE 1.18.1" date="20200729"/>        
            <entry filext="sfrm" mimetype="application/octet-stream" source="https://datatypes.net/"
                date="20190922"/>
            <entry filext="sh" mimetype="text/plain" source="https://datatypes.net/" date="20191110"/>
            <entry filext="shp" mimetype="application/octet-stream" source="JHOVE 1.18.1"/>
            <entry filext="shx" mimetype="application/octet-stream" source="JHOVE 1.18.1"/>
            <entry filext="sps" mimetype="text/plain" source="JHOVE 1.18.1" date="20191216"/>
            <entry filext="spv" mimetype="application/octet-stream" source="JHOVE 1.18.1"
                date="20191216"/>
            <entry filext="srjs" mimetype="application/x-sparqlstar-reults+json"
                source="GraphDB9.2-webinar " date="20200514"/>
            <entry filext="srt" mimetype="text/plain" source="https://datatypes.net/"
                date="20180712"/>
            <entry filext="stats" applicationType="https://datatypes.net/freesurfer-file-types"
                mimetype="application/octet-stream" source="https://datatypes.net/" date="20200630"/>
            <entry filext="sty" mimetype="application/x-latex" source="https://datatypes.net/"
                date="20200325"/>
            <entry filext="surf" applicationType="https://datatypes.net/v-sim-file-types"
                mimetype="application/octet-stream" source="https://datatypes.net/" date="20200630"/>
            <entry filext="svg" mimetype="image/svg+xml" source="https://datatypes.net/"
                date="20180816"/>
            <entry filext="tex" mimetype="application/x-latex" source="https://datatypes.net/"
                date="20200325"/>
            <entry filext="tif" mimetype="image/tiff" source="https://datatypes.net/"
                date="20180816"/>
            <entry filext="tiff" mimetype="image/tiff" source="https://datatypes.net/"
                date="20180816"/>
            <entry filext="tree" mimetype="application/octet-stream" source="https://datatypes.net/"
                date="20180712"/>
            <entry filext="trigs" mimetype="application/x-trigstar" source="GraphDB9.2-webinar "
                date="20200514"/>
            <entry filext="tsv" mimetype="text/tab-separated-values" source="fetch:content-type"
                date="20190710"/>
            <entry filext="tsvs" mimetype="text/x-tab-separated-values-star"
                source="GraphDB9.2-webinar " date="20200514"/>
            <entry filext="ttls" mimetype="text/x-turtlestar" source="GraphDB9.2-webinar "
                date="20200514"/>
            <entry filext="txt" mimetype="text/plain" source="https://datatypes.net/"
                date="20180816"/>
            <entry filext="vcf" mimetype="application/octet-stream" source="https://datatypes.net/"
                date="20200331"/>
            <entry filext="vhdr" mimetype="application/octet-stream" source="https://datatypes.net/open-vhdr-files"
                date="20210701" openwith="https://bids.neuroimaging.io/"/>
            <entry filext="vmrk" mimetype="application/octet-stream" source="https://datatypes.net/open-vmrk-files"
                date="20210701" openwith="https://bids.neuroimaging.io/"/>
            <entry filext="war" mimetype="application/java-archive" source="https://datatypes.net/"
                date="20180719"/>
            <entry filext="wav" mimetype="audio/x-wav" source="https://datatypes.net/"
                date="20180816"/>
            <entry filext="xls" mimetype="application/vnd.ms-excel" source="https://datatypes.net/"
                date="20180816"/>
            <entry filext="xlsx" mimetype="application/vnd.openxmlformats"
                source="https://datatypes.net/" date="20180816"/>
            <entry filext="xml" mimetype="text/xml" source="JHOVE 1.18.1"/>
            <entry filext="xsd" mimetype="text/xml" source="JHOVE 1.18.1"/>
            <entry filext="xsl" mimetype="text/xml" source="JHOVE 1.18.1" PUID="x-fmt/281"/>
            <entry filext="xq" mimetype="text/plain" source="JHOVE 1.18.1"/>
            <entry filext="xquery" mimetype="text/plain" source="JHOVE 1.18.1"/>
            <entry filext="zip" mimetype="application/x-zip-compressed"
                source="https://datatypes.net/" date="20180724"/>
        </map>
    </xsl:variable>
    <xsl:variable name="funderName2fundRefIDmap">
        <!-- Map entries cover presently only funders that are found in Swecris,  -->
        <map>
            <entry funderName="Energimyndigheten" fundRefID="501100004527" source="CrossrefAPI" date="20211004"/>
            <entry funderName="FORMAS" fundRefID="501100001862" source="CrossrefAPI" date="20211004"/>
            <entry funderName="FORTE" fundRefID="501100006636" source="CrossrefAPI" date="20211004"/>
            <entry funderName="Hjärt-Lungfonden" fundRefID="501100003793" source="CrossrefAPI" date="20211004"/>
            <entry funderName="IFAU" fundRefID="501100012549" source="CrossrefAPI" date="20211004"/>
            <entry funderName="Ragnar Söderbergs stiftelse" fundRefID="100007459" source="CrossrefAPI" date="20211004"/>
            <entry funderName="Riksantikvarieämbetet" fundRefID="501100019975" source="CrossrefAPI" date="20230228"/>            
            <entry funderName="Riksbankens jubileumsfond" fundRefID="501100004472" source="CrossrefAPI" date="20211004"/>
            <entry funderName="Rymdstyrelsen" fundRefID="501100001859" source="CrossrefAPI" date="20211004"/>
            <entry funderName="Statens Geotekniska institut" fundRefID="501100009244" source="CrossrefAPI" date="20211005"/>
            <entry funderName="Stockholm University" fundRefID="501100009244" source="CrossrefAPI" date="20211005"/>
            <entry funderName="Swedish National Heritage Board" fundRefID="501100019975" source="CrossrefAPI" date="20230228"/>      
            <entry funderName="Stiftelsen Olle Engkvist Byggmästare" fundRefID="501100004200" source="CrossrefAPI" date="20211222"/>
            <entry funderName="VR - Swedish Research Council" fundRefID="501100004359" source="CrossrefAPI" date="20210914"/>
            <entry funderName="Vinnova" fundRefID="501100001858" source="CrossrefAPI" date="20211004"/>
            <entry funderName="Östersjöstiftelsen" fundRefID="100009050" source="CrossrefAPI" date="20211004"/>
        </map>    
    </xsl:variable>
    
    <xsl:variable name="institutionList">https://www.su.se/medarbetare/ekonomi/institutionslista-1.4400</xsl:variable>
    
    <xsl:variable name="affiliateDept2institutionNrMap">
      <map>
        <entry deptName="Archaeology and Classical Studies" instNrNamn="108 Institutionen för arkeologi och antikens kultur" source="$institutionList" date="2022-02-21"/>
        <entry deptName="Asian and Middle Eastern Studies" instNrNamn="172 Institutionen för Asien-, Mellanöstern- och Turkietstudier" source="$institutionList" date="2022-02-21"/>   
        <entry deptName="Astronomy" instNrNamn="401 Institutionen för astronomi" source="$institutionList" date="2022-02-21"/>          
        <entry deptName="Biochemistry and Biophysics (DBB)" instNrNamn="431 Institutionen för biokemi och biofysik (DBB)" source="$institutionList" date="2021-12-20"/>
        <entry deptName="Computer and Systems Sciences" instNrNamn="323 Institutionen för data- och systemvetenskap (DSV)" source="$institutionList" date="2022-02-21"/>          
        <entry deptName="Child and Youth Studies" instNrNamn="318 Barn- och ungdomsvetenskapliga institutionen" source="$institutionList" date="2022-02-21"/>          
        <entry deptName="Criminology" instNrNamn="312 Kriminologiska institutionen" source="$institutionList" date="2022-02-21"/>                         
        <entry deptName="Culture and Aesthetics" instNrNamn="106 Institutionen för kultur och estetik" source="$institutionList" date="2022-02-21"/>
        <entry deptName="Economics" instNrNamn="305 Nationalekonomiska institutionen" source="$institutionList" date="2022-02-07"/>  
        <entry deptName="Economic History and International Relations" instNrNamn="301 Institutionen för ekonomisk historia och internationella relationer" source="$institutionList" date="2022-02-21"/>    
        <entry deptName="Education" instNrNamn="306 Institutionen för pedagogik och didaktik" source="$institutionList" date="2022-02-07"/>         
        <entry deptName="English" instNrNamn="150 Engelska institutionen" source="$institutionList" date="2021-10-26"/>
        <entry deptName="Environmental Science" instNrNamn="485 Institutionen för miljövetenskap (ACES)" source="$institutionList" date="2021-12-15"/>          
        <entry deptName="Ethnology, History of Religions and Gender Studies" instNrNamn="103 Institutionen för etnologi, religionshistoria och genusvetenskap" source="$institutionList" date="2021-10-26"/>
        <entry deptName="Humanities and Social Sciences Education" instNrNamn="130 Institutionen för ämnesdidaktik" source="$institutionList" date="2022-02-07"/>                    
        <entry deptName="Institute for International Economic Studies (IIES)" instNrNamn="303 Institutet för internationell ekonomi (IIES)" source="$institutionList" date="2021-10-26"/>         
        <entry deptName="Materials and Environmental Chemistry (MMK)" instNrNamn="432 Institutionen för material- och miljökemi (MMK)" source="$institutionList" date="2022-02-07"/>
        <entry deptName="Meteorology (MISU)" instNrNamn="404 Meteorologiska institutionen (MISU)" source="$institutionList" date="2022-02-07"/>
        <entry deptName="Organic Chemistry" instNrNamn="433 Institutionen för organisk kemi" source="$institutionList" date="2022-02-22"/>          
        <entry deptName="Physical Geography" instNrNamn="463 Institutionen för naturgeografi" source="$institutionList" date="2022-02-22"/>                    
        <entry deptName="Physics" instNrNamn="402 Fysikum" source="$institutionList" date="2022-02-21"/>          
        <entry deptName="Slavic and Baltic Studies, Finnish, Dutch and German" instNrNamn="158 Institutionen för slaviska och baltiska språk, finska, nederländska och tyska" source="$institutionList" date="2021-10-26"/>
        <entry deptName="Social Anthropology" instNrNamn="309 Socialantropologiska institutionen" source="$institutionList" date="2021-12-20"/>
        <entry deptName="Statistics" instNrNamn="311 Statistiska institutionen" source="$institutionList" date="2021-10-26"/>        
        <entry deptName="Stockholm Resilience Centre" instNrNamn="481 Stockholms Resilienscentrum" source="$institutionList" date="2021-02-07"/>          
        <entry deptName="Stockholm University Library" instNrNamn="680 Stockholms universitetsbibliotek" source="$institutionList" date="2021-10-26"/>
        <entry deptName="Teaching and Learning (merged from 2022-01-01)" instNrNamn="130 Institutionen för ämnesdidaktik" source="$institutionList" date="2022-02-07"/>  
      </map>
    </xsl:variable>
    <xsl:variable name="datasetIDstring">
      <!--  <xsl:value-of select="replace(//sections[2]/questions[2]/answer/text,' ','')"/> -->
        <xsl:value-of select="replace(//sections[number/text()=2]/questions[number/text()=2]/answer/text,' ','')"/>
    </xsl:variable>
    <xsl:variable name="datasetIDtype">
      <!-- <xsl:value-of select="//sections[2]/questions[3]/answer/options//text"/> -->
        <xsl:value-of select="//sections[number/text()=2]/questions[number/text()=3]/answer/options//text"/>
    </xsl:variable>
    
    <xsl:variable name="ethicsNsensitive">        
            <xsl:choose>
                <xsl:when
                    test="substring-before(replace(/array/creation_date, '-', ''), ' ') &lt; '20210718'">
                    <!-- <xsl:value-of
                        select="//sections[5]/questions[3]/answer/options//replace(text[1], ', but not \(a-e\)', '')"
                    /> -->
                    <xsl:value-of
                        select="//sections[number/text()=5]/questions[number/text()=3]/answer/options//replace(text, ', but not \(a-e\)', '')"
                    />
                </xsl:when>
                <xsl:when
                    test="contains(//sections[number/text()=5]/questions[number/text()=2]/answer/options//text,', but not \(a-e\)')">
                    <xsl:value-of
                        select="//sections[number/text()=5]/questions[number/text()=2]/answer/options//replace(text, ', but not \(a-e\)', '')"
                    />
                </xsl:when>
                <xsl:otherwise>             
                    <xsl:value-of
                            select="//sections[number/text()=5]/questions[number/text()=2]/answer/options//text"
                    />
                </xsl:otherwise>
            </xsl:choose>
        
    </xsl:variable>
    <xsl:template match="/">

        <dmp xmlns:xlink="http://www.w3.org/1999/xlink"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" OBJID="{array/id}"
            LABEL="{local:removeHtmlTags(array/title)}">

            <xsl:call-template name="createRDAmaDMPhead"/>

            <xsl:call-template name="createRDAdatasetSec"/>

            
            
            <extension>
                
                <affiliationSUdepartment>
                    <xsl:variable name="affiliateText"><xsl:value-of select="array/plan_content/sections[number/text()=9]/questions[number/text()=3]/answer/text"/></xsl:variable>
                    <xsl:for-each select="for $i in (//sections[number/text()=9]/questions[number/text()=3]/answer/options//text) return local:removeHtmlTags($i)">          
                        <archivalInstitution>
                             
                                <xsl:value-of
                                    select="
                                    for $f in (.)
                                    return
                                    (if ($affiliateDept2institutionNrMap//entry[@deptName = $f]/@instNrNamn) then
                                    $affiliateDept2institutionNrMap//entry[@deptName = $f]/@instNrNamn else if ($f = 'Other') then ($affiliateText) else  $f)"
                                />
                        </archivalInstitution>
                            
                        
                    </xsl:for-each> 
                </affiliationSUdepartment>
                
                <xsl:call-template name="archivalVersions"/>
                
                <xsl:call-template name="createFAIRscore"/>
                
                <DMPonline>
                    <template>
                        <id><xsl:value-of select="/array/template/id"/></id>
                        <title><xsl:value-of select="/array/template/title"/></title>
                    </template>                   
                </DMPonline>
                <Dataverse>
                    <transform_file>
                        <dataset_id>10.7910/DVN/MGZBAL</dataset_id>
                        <id_type>doi</id_type>
                        <file_name>SUDMP2maDMP1-1.xsl</file_name>
                        <file_version>0.97</file_version>
                        <file_format>xslt</file_format>
                        <mimetype>text/xml</mimetype>
                    </transform_file>
                </Dataverse>
            </extension>

        </dmp>
    </xsl:template>

    <!--  <xsl:function name="local:removeHtmlTags" as="xs:string">
        <xsl:param name="element"/>
        <xsl:value-of select="normalize-space(replace($element,'&lt;|[^\s]|[^&lt;]|&amp;|nbsp;|&lt;p&gt;|&lt;/p&gt;|&#xA;|&#xD;',''))"/>
    </xsl:function> Replaced with JM-Mimer function: -->
    
    <xsl:function name="local:removeHtmlTags" as="xs:string">
        <xsl:param name="element"/>
        <xsl:value-of
            select="normalize-space(replace($element, '&lt;[^\s][^&lt;]*>|&amp;nbsp;|&#xA;|&#xD;',' '))"
        />
    </xsl:function>
    <xsl:function name="local:replaceSpace">
        <xsl:param name="element"/>
        <xsl:value-of select="replace($element, 'nbsp;', ' ')"/>
    </xsl:function>
    <xsl:function name="local:replacEndash">
        <xsl:param name="element"/>
        <xsl:value-of select="replace($element, '&amp;ndash;', '-')"/>
    </xsl:function>
    <xsl:function name="local:quoteReplace" as="xs:string">
        <xsl:param name="element"/>
        <xsl:value-of
            select="normalize-space(replace($element, 'ldquo;|rdquo;|#39;|quot;', &quot;&apos;&quot;))"
        />
    </xsl:function>
    <xsl:function name="local:replaceOuml">
        <xsl:param name="element"/>
        <xsl:value-of select="replace($element, 'Ouml;', 'Ö')"/>
    </xsl:function>
    <xsl:function name="local:replaceSouml">
        <xsl:param name="element"/>
        <xsl:value-of select="replace($element, 'ouml;', 'ö')"/>
    </xsl:function>
    <xsl:function name="local:replaceSauml">
        <xsl:param name="element"/>
        <xsl:value-of select="replace($element, 'auml;', 'ä')"/>
    </xsl:function>
    <xsl:function name="local:replaceAuml">
        <xsl:param name="element"/>
        <xsl:value-of select="replace($element, 'Auml;', 'Ä')"/>
    </xsl:function>
    <xsl:function name="local:replaceSaring">
        <xsl:param name="element"/>
        <xsl:value-of select="replace($element, 'aring;', 'å')"/>
    </xsl:function>
    <xsl:function name="local:replaceAring">
        <xsl:param name="element"/>
        <xsl:value-of select="replace($element, 'Aring;', 'Å')"/>
    </xsl:function>
    <xsl:function name="local:replaceSuuml">
        <xsl:param name="element"/>
        <xsl:value-of select="replace($element, 'uuml;', 'ü')"/>
    </xsl:function>
    <xsl:function name="local:replaceUuml">
        <xsl:param name="element"/>
        <xsl:value-of select="replace($element, 'Uuml;', 'Ü')"/>
    </xsl:function>
    <xsl:function name="local:ampURL">
        <xsl:param name="element"/>
        <xsl:value-of select="replace($element, 'amp;', '&amp;')"/>
    </xsl:function>
    <xsl:function name="local:inputCount">
        <xsl:param name="element"/>
        <xsl:param name="chars"/>
        <xsl:value-of select="count(tokenize($element, $chars))"/>
    </xsl:function>
    <xsl:function name="local:datasetID2string">
        <xsl:param name="element"/>
        <xsl:value-of select="if (matches($element,'^\d+$')) then (concat('ID-',$element)) else $element"/> 
    </xsl:function>
    
    <xsl:template name="createRDAmaDMPhead">
        <title>
            <xsl:value-of select="local:removeHtmlTags(array/title)"/>
        </title>
        <description>
            <xsl:value-of select="local:removeHtmlTags(array/description)"/>
        </description>
        <created>
            <xsl:value-of select="replace(replace(array/creation_date, ' UTC', 'Z'), ' ', 'T')"/>
        </created>
        <modified>
            <xsl:value-of select="replace(replace(array/last_updated, ' UTC', 'Z'), ' ', 'T')"/>
        </modified>
        <contact>
            <mbox>
                <xsl:value-of
                    select="
                        if (string-length(array/data_contact/email) &lt; 1) then
                            (array/principal_investigator/email)
                        else
                            array/data_contact/email"
                />
            </mbox>
            <name>
                <xsl:value-of
                    select="
                        if (string-length(array/data_contact/name) &lt; 1) then
                            (array/principal_investigator/name)
                        else
                            array/data_contact/name"
                />
            </name>
            <contact_id>
                <identifier>
                    <xsl:value-of select="if (string-length(//sections[number/text()=9]/questions[number/text()=1]/answer/text) &gt; 1) then (//sections[number/text()=9]/questions[number/text()=1]/answer/text) else if (string-length(array/data_contact/email) &gt; 1) then array/data_contact/email else array/principal_investigator/email"/>
                
                </identifier>
                <type>
                    <xsl:value-of select="if (string-length(//sections[number/text()=9]/questions[number/text()=1]/answer/text) &gt; 1 and string-length(//sections[number/text()=9]/questions[number/text()=2]/answer/options//text) &gt; 1) then //sections[number/text()=9]/questions[number/text()=2]/answer/options//text else 'other'"/>
                </type>
            </contact_id>
        </contact>
        <language>
            <!-- <xsl:value-of select="if (//sections[9]/questions[4]/answered = 'false') then 'und' else substring(//sections[9]/questions[4]/answer/options//text,0,4)"/> -->
            <xsl:value-of select="if (//sections[number/text()=9]/questions[number/text()=4]/answered = 'false') then 'und' else substring(//sections[number/text()=9]/questions[number/text()=4]/answer/options//text,0,4)"/>  
        </language>        
       <array> 
        <project>
           
            <title><xsl:value-of select="local:removeHtmlTags(array/title)"/></title>
            <start><xsl:value-of select="substring-before($DMPexport//start,'T')"/></start>
            <end><xsl:value-of select="substring-before($DMPexport//end,'T')"/></end>
            <array>   
              <funding>
                  <xsl:for-each select="//sections[number/text()=9]/questions[number/text()=5]/answer/options//text">   
                    <funder_id>
                        <identifier><xsl:value-of select="if (contains(.,'Östersjöstift')) then '100009050' else if (contains(.,'VR')) then '501100004359' else if (contains(.,'Vinnova')) then '501100001858' else if (contains(.,'FORTE')) then '501100006636' else if (contains(.,'FORMAS')) then '501100001862' else if (contains(.,'IFAU')) then '501100012549' else if (contains(.,'Riksbank')) then '501100004472' else if (contains(.,'Ragnar')) then '100007459' else if (contains(.,'Geotekniska')) then '100016779' else ()"/></identifier>
                        <xsl:choose>
                            <xsl:when test=". = 'Other'"/>
                            <xsl:otherwise><type>fundref</type></xsl:otherwise>
                        </xsl:choose>   
                    </funder_id>
                  </xsl:for-each>
              
                  <xsl:for-each select="for $i in tokenize(//sections[number/text()=9]/questions[number/text()=5]/answer/text,', ') return local:removeHtmlTags($i)">          
                            <funder_id>
                                <identifier> 
                                <xsl:value-of
                                    select="
                                    for $f in (.)
                                    return
                                    (if ($funderName2fundRefIDmap//entry[@funderName = $f]/@fundRefID) then
                                    $funderName2fundRefIDmap//entry[@funderName = $f]/@fundRefID else $f)"
                                />
                                </identifier>
                                <type><xsl:value-of
                                    select="for $f in (.)
                                    return
                                    (if ($funderName2fundRefIDmap//entry[@funderName = $f]/@fundRefID) then 'fundref' else 'other')"/></type>
                            </funder_id> 
                        </xsl:for-each>        
                    
                  <xsl:choose>
                      <xsl:when test="string-length($DMPexport//funding/array/grant_id/identifier) &gt; 2">
                          <grant_id>
                              <identifier><xsl:value-of select="$DMPexport//funding/array/grant_id/identifier"/></identifier>
                              <type><xsl:value-of select="'other'"/></type>    
                          </grant_id>
                      </xsl:when>
                      <xsl:when test="string-length(//sections[number/text()=9]/questions[number/text()=6]/answer/text) &gt; 4">
                        <grant_id>
                            <identifier><xsl:value-of select="local:removeHtmlTags(//sections[number/text()=9]/questions[number/text()=6]/answer/text)"/></identifier>
                            <type><xsl:value-of select="if (contains(//sections[number/text()=9]/questions[number/text()=6]/answer/text,'http')) then 'url' else 'other'"/></type>    
                        </grant_id>
                      </xsl:when>
                      <xsl:otherwise/>     
                 </xsl:choose> 
                  
                  
                  <funding_status><xsl:value-of select="if (string-length(//sections[number/text()=9]/questions[number/text()=7]/answer/options//text) &gt; 2) then (//sections[number/text()=9]/questions[number/text()=7]/answer/options//text) else 'planned'"/></funding_status> 
                   
                  </funding>
               </array>
        </project>
       </array> 
              
        <ethical_issues_exist>
            <xsl:value-of select="local:removeHtmlTags($ethicsNsensitive)"/>
        </ethical_issues_exist>
        <dmp_id>
            <identifier>
                <xsl:value-of select="concat('https://dmp.su.se/plans/', array/id)"/>
            </identifier>
            <type>url</type>
        </dmp_id>
    </xsl:template>

    <xsl:template name="createRDAdatasetSec">
       
        <dataset>
           <array>            <!--no. 0: head/main/start -->
            <title>
                <xsl:value-of select="local:removeHtmlTags(//sections[number/text()=2]/questions[number/text()=5]/answer/text)"/>
            </title>
            <description>
                <xsl:value-of
                    select="local:removeHtmlTags(//sections[number/text()=2]/questions[number/text()=4]/answer/text/text())"
                />
            </description>
            <type>
                <xsl:value-of
                    select="
                    if (//sections[number/text()=2]/questions[number/text()=10]/answered = 'true') then
                        (//sections[number/text()=2]/questions[number/text()=10]/answer/options//text)
                        else
                            ('PLACEHOLDER:comingQ10answer')"
                />
            </type>
            <issued>
                <xsl:value-of
                    select="
                    if (//sections[number/text()=2]/questions[number/text()=11]/answered = 'true') then
                    (//sections[number/text()=2]/questions[number/text()=11]/answer/text)
                        else
                            substring-before(string(current-date()), '+')"
                />
            </issued>

            <dataset_id>
              <!-- The following variable is used to avoid getting pure numbers as values for dataset_ids in the conversion from xml to json -->  
                <xsl:variable name="dataset_idNum2string">
                    <xsl:value-of
                        select="if (matches($datasetIDstring,'^\d+$')) then (concat('ID-',$datasetIDstring)) else $datasetIDstring"/> 
                    <!-- <xsl:value-of
                        select="concat('ID-',normalize-space($datasetIDstring))"/> -->
                </xsl:variable>                
                <identifier>
                    <xsl:value-of
                        select="$dataset_idNum2string"/>
                </identifier>
                <type>
                    <xsl:value-of
                        select="if (//sections[number/text()=2]/questions[number/text()=2]/answered = 'true') then local:removeHtmlTags($datasetIDtype) else 'other'"
                    />
                </type>
            </dataset_id>
            <xsl:if
                test="$datasetIDtype/text()   = 'other'">
                <otherIdType>
                    <xsl:value-of
                        select="normalize-space(local:removeHtmlTags(/array/plan_content[1]//sections[number/text()=2]/questions[number/text()=3]/answer/text))"
                    />
                </otherIdType>
            </xsl:if>
            <personal_data>
                <xsl:value-of select="//sections[number/text()=5]/questions[number/text()=1]/answer/options//text"/>
            </personal_data>
            <sensitive_data>
                <xsl:value-of select="local:removeHtmlTags($ethicsNsensitive)"/>
            </sensitive_data>
            <!--  -->
            
               <xsl:variable name="TableRowNo" select="('T1','T2','T3','T4','T5')"/>
               <xsl:variable name="Ttest" select="for $i in $TableRowNo return substring-before(substring-after(//sections[number/text()=10]/questions[number/text()=1]/answer/text/text(),$i),'&lt;/em')"/>
                <xsl:choose>
                    <xsl:when test="not(exists(//sections[number/text()=10])) or string-length(local:removeHtmlTags(substring-before(substring-after(//sections[number/text()=10]/questions[number/text()=1]/answer/text/text(), 'T1:'), '&lt;/em'))) &lt; 1 or contains(substring-before(substring-after(//sections[number/text()=10]/questions[number/text()=1]/answer/text/text(), 'T1:'), '&lt;/em'),'None')">
                     <!--   <dataset>  
                            <title>PLACEHOLDER</title>
                            <dataset_id>
                                <identifier>PLACEHOLDER</identifier>
                                <type>other</type>
                            </dataset_id>
                            <personal_data>unknown</personal_data>
                            <sensitive_data>unknown</sensitive_data>
                        </dataset>  -->
                    </xsl:when>
                    <xsl:when test="string-length(substring-after(//sections[number/text()=10]/questions[number/text()=1]/answer/text/text(), 'T1:')) &gt; 1">
                    <!--    <dataset>  -->
                            <!--no. 1 -->
                            <title>
                                <!--    <xsl:value-of select="local:removeHtmlTags(substring-before(//sections[10]/questions[1]/answer/text/substring(.,690,50),'&lt;/em'))"/> -->
                                <xsl:value-of
                                    select="local:removeHtmlTags(substring-before(substring-after(//sections[number/text()=10]/questions[number/text()=1]/answer/text/text(), 'T1:'), '&lt;/em'))"/>
                            </title>
                                                 
                            <type>
                                <xsl:value-of
                                    select="
                                    if (//sections[number/text()=2]/questions[number/text()=10]/answered = 'true') then
                                    (//sections[number/text()=2]/questions[number/text()=10]/answer/options//text)
                                    else
                                    ('PLACEHOLDER:comingQ10answer')"
                                />
                            </type>
                            <issued>
                                <xsl:value-of
                                    select="
                                    if (//sections[number/text()=2]/questions[number/text()=11]/answered = 'true') then
                                    (//sections[number/text()=2]/questions[number/text()=11]/answer/text)
                                    else
                                    substring-before(string(current-date()), '+')"
                                />
                            </issued>
                            
                            <dataset_id>
                                <identifier>
                                   <xsl:value-of
                                        select="local:datasetID2string(normalize-space(local:removeHtmlTags(substring-before(substring-after(//sections[number/text()=10]/questions[number/text()=1]/answer/text/text(), 'Id1:'), '&lt;/em'))))"
                                    />
                                </identifier>
                                <type>
                                    <xsl:value-of
                                        select="normalize-space(local:removeHtmlTags(substring-before(substring-after(//sections[number/text()=10]/questions[number/text()=1]/answer/text/text(), 'Type1:'), '&lt;/em')))"
                                    />
                                </type>
                            </dataset_id>
                            
                            <personal_data>
                                <xsl:value-of select="//sections[number/text()=5]/questions[number/text()=1]/answer/options//text"/>
                            </personal_data>
                            <sensitive_data>
                                <xsl:value-of select="local:removeHtmlTags($ethicsNsensitive)"/>
                            </sensitive_data>
                    <!--    </dataset>  -->
                    </xsl:when>
                    <xsl:otherwise/>    
                </xsl:choose>
                <xsl:choose>
                    <xsl:when test="not(exists(//sections[number/text()=10])) or string-length(substring-after(//sections[number/text()=10]/questions[number/text()=1]/answer/text/text(), 'T2:')) &lt; 1 or contains(substring-before(substring-after(//sections[10]/questions[1]/answer/text/text(), 'T2:'), '&lt;/em'),'None')"/>
                    <!--    <xsl:when
                test="local:removeHtmlTags(substring-before(substring-after(//sections[10]/questions[1]/answer/text/text(), 'T2:'), '&lt;/em')) != 'None'"> -->
                    <xsl:when test="string-length(substring-after(//sections[number/text()=10]/questions[number/text()=1]/answer/text/text(), 'T2:')) &gt; 1">
                        <!--    <dataset>  -->
                            <!--no. 2 -->
                            <title>
                                <xsl:value-of
                                    select="local:removeHtmlTags(substring-before(substring-after(//sections[number/text()=10]/questions[number/text()=1]/answer/text/text(), 'T2:'), '&lt;/em'))"/>
                            </title>
                   
                            <type>
                              <xsl:value-of
                                    select="
                                    if (//sections[number/text()=2]/questions[number/text()=10]/answered = 'true') then
                                    (//sections[number/text()=2]/questions[number/text()=10]/answer/options//text)
                                    else
                                    ('PLACEHOLDER:comingQ10answer')"/> 
                                
                            </type>
                            <issued>
                                <xsl:value-of
                                    select="
                                    if (//sections[number/text()=2]/questions[number/text()=11]/answered = 'true') then
                                    (//sections[number/text()=2]/questions[number/text()=11]/answer/text)
                                    else
                                    substring-before(string(current-date()), '+')"
                                />
                            </issued>
                            
                            <dataset_id>
                                <identifier>
                                    <xsl:value-of
                                        select="local:datasetID2string(normalize-space(local:removeHtmlTags(substring-before(substring-after(//sections[number/text()=10]/questions[number/text()=1]/answer/text/text(), 'Id2:'), '&lt;/em'))))"/>
                                </identifier>
                                <type>
                                    <xsl:value-of
                                        select="normalize-space(local:removeHtmlTags(substring-before(substring-after(//sections[number/text()=10]/questions[number/text()=1]/answer/text/text(), 'Type2:'), '&lt;/em')))"
                                    /> 
                                </type>
                            </dataset_id>
                            
                            <personal_data>
                                <xsl:value-of select="//sections[number/text()=5]/questions[number/text()=1]/answer/options//text"/>
                            </personal_data>
                            <sensitive_data>
                                <xsl:value-of select="local:removeHtmlTags($ethicsNsensitive)"/>
                            </sensitive_data>
                        <!--    </dataset>  -->
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
                <xsl:choose>
                    <xsl:when test="not(exists(//sections[number/text()=10])) or string-length(substring-after(//sections[number/text()=10]/questions[number/text()=1]/answer/text/text(), 'T3:')) &lt; 1 or contains(substring-before(substring-after(//sections[number/text()=10]/questions[number/text()=1]/answer/text/text(), 'T3:'), '&lt;/em'),'None')"/>
                    <!--    <xsl:when
                test="local:removeHtmlTags(substring-before(substring-after(//sections[10]/questions[1]/answer/text/text(), 'T3:'), '&lt;/em')) != 'None'"> -->
                    <xsl:when test="string-length(substring-after(//sections[number/text()=10]/questions[number/text()=1]/answer/text/text(), 'T3:')) &gt; 1">   
                        <!--    <dataset>  -->
                            <!--no. 3 -->
                            <title>
                                <xsl:value-of
                                    select="local:removeHtmlTags(substring-before(substring-after(//sections[number/text()=10]/questions[number/text()=1]/answer/text/text(), 'T3:'), '&lt;/em'))"/>
                                
                            </title>                      
                            <type>
                                <xsl:value-of
                                    select="
                                    if (//sections[number/text()=2]/questions[number/text()=10]/answered = 'true') then
                                    (//sections[number/text()=2]/questions[number/text()=10]/answer/options//text)
                                    else
                                    ('PLACEHOLDER:comingQ10answer')"
                                />
                            </type>
                            <issued>
                                <xsl:value-of
                                    select="
                                    if (//sections[number/text()=2]/questions[number/text()=11]/answered = 'true') then
                                    (//sections[number/text()=2]/questions[number/text()=11]/answer/text)
                                    else
                                    substring-before(string(current-date()), '+')"
                                />
                            </issued>
                            
                            <dataset_id>
                                <identifier>
                                    <xsl:value-of
                                        select="local:datasetID2string(normalize-space(local:removeHtmlTags(substring-before(substring-after(//sections[number/text()=10]/questions[number/text()=1]/answer/text/text(), 'Id3:'), '&lt;/em'))))"
                                    />
                                </identifier>
                                <type>
                                    <xsl:value-of
                                        select="normalize-space(local:removeHtmlTags(substring-before(substring-after(//sections[number/text()=10]/questions[number/text()=1]/answer/text/text(), 'Type3:'), '&lt;/em')))"
                                    />
                                </type>
                            </dataset_id>
                            
                            <personal_data>
                                <xsl:value-of select="//sections[number/text()=5]/questions[number/text()=1]/answer/options//text"/>
                            </personal_data>
                            <sensitive_data>
                                <xsl:value-of select="local:removeHtmlTags($ethicsNsensitive)"/>
                            </sensitive_data>
                        <!--    </dataset>  -->
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
                
            
            </array>            
        </dataset>

        <xsl:choose>
            <xsl:when test="//sections[number/text()=2]/questions[number/text()=6]/answer/options//text = 'yes'">
                <distribution>
                    <xsl:variable name="accessURLs">
                        <xsl:value-of select="tokenize(//sections[number/text()=2]/questions[number/text()=7]/answer/text,', ')"/>
                    </xsl:variable>
                      
                    <xsl:for-each select="for $i in ($accessURLs) return (if (string-length($i) &gt; 10) then ($i)  else 'None')">
                          <access_url><xsl:value-of select="."/></access_url>
                      </xsl:for-each>

                    <data_access>
                        <xsl:value-of select="//sections[number/text()=2]/questions[number/text()=8]/answer/options//text"/>
                    </data_access>
                    <array>
                        <xsl:for-each select="for $i in (tokenize(//sections[number/text()=2]/questions[number/text()=12]/answer/text,', ')) return (if (string-length($i ) &gt; 5) then ($i)  else 'None')">   
                     
                       <format>
                           <xsl:value-of
                               select="
                               for $f in (tokenize(., '\.')[last()])
                               return
                               (if ($filext2mimetypeMap//entry[@filext = $f]/@mimetype) then
                               $filext2mimetypeMap//entry[@filext = $f]/@mimetype
                               else
                               'application/unknown')"
                           />
                       </format>
                       
                       </xsl:for-each> 
                    </array>
                    <array>
                        <license>
                            <xsl:for-each
                                select="
                                tokenize(for $i in (/array/plan_content//sections[number/text()=2]/questions[number/text()=9]/answer/text)
                                    return
                                        local:removeHtmlTags($i), ',')">
                                <license_ref>
                                    <xsl:value-of select="."/>
                                </license_ref>
                                <start_date>
                                    <xsl:value-of
                                        select="substring-before(string(current-date()), '+')"/>
                                </start_date>
                            </xsl:for-each>
                            <xsl:for-each select="//sections[number/text()=2]/questions[number/text()=9]/answer/options//text">
                                <license_ref>
                                    <xsl:value-of select="."/>
                                </license_ref>
                                <start_date>
                                    <xsl:value-of
                                        select="substring-before(string(current-date()), '+')"/>
                                </start_date>
                            </xsl:for-each>
                            <xsl:for-each
                                select="//sections[number/text()=5]/questions[number/text()=5]/answer/text">
                                <license_ref>
                                    <xsl:value-of
                                        select="if (contains(., 'http')) then local:removeHtmlTags(tokenize(., ',')) else (.)"/>
                                </license_ref>
                                <start_date>
                                    <xsl:value-of
                                        select="substring-before(string(current-date()), '+')"/>
                                </start_date>
                            </xsl:for-each>
                            <xsl:for-each select="//sections[number/text()=5]/questions[number/text()=5]/answer/options//text">
                                <license_ref>
                                    <xsl:value-of select="."/>
                                </license_ref>
                                <start_date>
                                    <xsl:value-of
                                        select="substring-before(string(current-date()), '+')"/>
                                </start_date>
                            </xsl:for-each>

                        </license>

                    </array>
                    <xsl:for-each select="for $i in (tokenize(//sections[number/text()=2]/questions[number/text()=12]/answer/text,', ')) return (if (string-length($i ) &gt; 5) then ($i)  else ())">
                    <title>
                        <xsl:value-of select="substring-before(.,concat('.',tokenize(.,'\.')[last()]))"/>
                    </title>
                    </xsl:for-each>    
                </distribution>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
      
    </xsl:template>
    
    <xsl:template name="archivalVersions">
        <xsl:variable name="archiveInitial">
            <xsl:value-of select="//sections[number/text()=8]/questions//answer/options//text"/>
        </xsl:variable> 
        <initialVersion>
              <xsl:value-of select="if ($archiveInitial = 'Yes') then 'Archive Initial' else ()"/>               
        </initialVersion>
        <xsl:variable name="archiveFinal">
            <xsl:value-of select="//sections[number/text()=10]/questions[number/text()=3]/answer/options//text"/>
        </xsl:variable> 
        <finalVersion>
            <xsl:value-of select="if ($archiveFinal = 'Yes') then 'Archive Final' else ()"/>               
        </finalVersion>
    </xsl:template>

    <xsl:template name="createFAIRscore">
        <FAIRscore>
            <sectionI>
                <DataDescription>
                    <FileFormatsUNamesQ1>
                        <xsl:for-each
                            select="//plan_content[1]//sections[number/text()=2]/questions[number/text()=1]/answer/options//text">
                            <xsl:variable name="checkNr">
                                <xsl:value-of
                                    select="
                                        for $i in .
                                        return
                                            substring-before($i, '. ')"
                                />
                            </xsl:variable>
                            <Option>
                                <xsl:value-of select="."/>
                            </Option>
                            <xsl:choose>
                                <xsl:when
                                    test="($checkNr = '5' or $checkNr = '6' or $checkNr = '7')">
                                    <F-value>1</F-value>
                                </xsl:when>
                                <xsl:when
                                    test="($checkNr = '1' or $checkNr = '2' or $checkNr = '7')">
                                    <I-value>1</I-value>
                                    <R-value>1</R-value>
                                </xsl:when>
                                <xsl:otherwise/>
                            </xsl:choose>
                        </xsl:for-each>
                    </FileFormatsUNamesQ1>

                    <URL-idQ2>

                        <xsl:choose>
                            <xsl:when
                                test="string-length($datasetIDstring) > 4">
                                <Text>
                                    <xsl:value-of select="$datasetIDstring"/>
                                </Text>
                            </xsl:when>
                            <xsl:otherwise/>
                        </xsl:choose>
                        <xsl:choose>
                            <xsl:when
                                test="contains($datasetIDstring, 'http')">
                                <A-value>1</A-value>
                            </xsl:when>
                            <xsl:otherwise/>
                        </xsl:choose>
                    </URL-idQ2>

                    <idTypeQ3>
                        <Option>
                            <xsl:value-of select="$datasetIDtype"/>
                        </Option>
                        
                        <xsl:choose>
                        <!--    <xsl:when
                                test="$datasetIDtype/text() = 'other' or string-length($datasetIDtype) = 0"/> -->
                            <xsl:when test="contains($datasetIDstring,'ark') and $datasetIDtype/text() = 'ark'">
                                 <A-value>1</A-value>
                            </xsl:when>
                            <xsl:when test="contains($datasetIDstring,'doi') and $datasetIDtype/text() = 'doi'">
                                <A-value>1</A-value>
                            </xsl:when>
                            <xsl:when test="contains($datasetIDstring,'handle') and $datasetIDtype/text() = 'handle'">
                                <A-value>1</A-value>
                            </xsl:when>
                            <xsl:when test="contains($datasetIDstring,'http') and $datasetIDtype/text() = 'url'">
                                <A-value>1</A-value>
                            </xsl:when>
                            <xsl:otherwise/>
                        </xsl:choose>

                        <xsl:choose>
                            <xsl:when
                                test="$datasetIDtype/text() = 'other' and string-length(//sections[number/text()=2]/questions[number/text()=3]/answer/text) > 4">
                                <Text>
                                    <xsl:value-of
                                        select="local:removeHtmlTags(//sections[number/text()=2]/questions[number/text()=3]/answer/text)"
                                    />
                                </Text>
                                <F-value>1</F-value>
                            </xsl:when>
                            <xsl:otherwise/>
                        </xsl:choose>
                    </idTypeQ3>


                    <ReusedDatasetURL-licenseQ9>

                        <xsl:choose>
                            <xsl:when
                                test="string-length(//sections[number/text()=2]/questions[number/text()=9]/answer/text) > 8">
                                <Text>
                                    <xsl:value-of select="//sections[number/text()=2]/questions[number/text()=9]/answer/text"/>
                                </Text>
                            </xsl:when>
                            <xsl:when
                                test="contains(//sections[number/text()=2]/questions[number/text()=9]/answer/text, 'http')">
                                <R-value>1</R-value>
                            </xsl:when>
                            <xsl:otherwise/>
                        </xsl:choose>

                    </ReusedDatasetURL-licenseQ9>

                </DataDescription>

                <!--   -->
            </sectionI>

            <sectionII>
                <Metadata>
                    <!--    -->
                    <RepositoryQ1>
                      <xsl:variable name="optionText"><xsl:value-of select="//plan_content[1]//sections[number/text()=3]/questions[number/text()=1]/answer/options//text"/>
                      </xsl:variable> 
                      
                      <xsl:variable name="checkNr">
                          <xsl:value-of select="for $i in ($optionText) return
                                            substring-before($i, '.')"/>
                      </xsl:variable>
                   
                      <Options>
                           <xsl:value-of select="tokenize(local:removeHtmlTags($optionText),' ')"/>
                      </Options>
                            <xsl:choose>
                                <xsl:when
                                    test="($checkNr = '1' or $checkNr = '2' or $checkNr = '3' or $checkNr = '4' or $checkNr = '7')">
                                    <F-value>1</F-value>
                                    <A-value>1</A-value>
                                    <I-value>1</I-value>
                                    <R-value>1</R-value>
                                </xsl:when>
                                <xsl:otherwise/>
                            </xsl:choose>
                    
                    </RepositoryQ1>

                    <RepositoryURL>

                        <xsl:for-each
                            select="
                            for $i in (//plan_content[1]//sections[number/text()=3]/questions[number/text()=1]/answer/text)
                                return
                                    tokenize($i, ',')">
                            <Text>
                                <xsl:value-of
                                    select="
                                        for $j in .
                                        return
                                            local:removeHtmlTags($j)"
                                />
                            </Text>

                            <xsl:choose>
                                <xsl:when test="contains(., 'http')">
                                    <F-value>1</F-value>
                                    <A-value>1</A-value>
                                </xsl:when>
                                <xsl:otherwise/>
                            </xsl:choose>
                        </xsl:for-each>


                    </RepositoryURL>
                    <Repo-VocabQ2>
                        <xsl:for-each
                            select="//plan_content[1]//sections[number/text()=3]/questions[number/text()=2]/answer/options//text">
                            <xsl:variable name="checkNr">
                                <xsl:value-of
                                    select="
                                        for $i in (.)
                                        return
                                            substring-before($i, '.')"
                                />
                            </xsl:variable>
                            <Option>
                                <xsl:value-of select="tokenize(local:removeHtmlTags(.), ' ')"/>
                            </Option>
                            <xsl:choose>                               
                               <xsl:when
                                    test="($checkNr = '1' or $checkNr = '2' or $checkNr = '3' or $checkNr = '4' or $checkNr = '5' or $checkNr = '6' or $checkNr = '7' or $checkNr = '8' or $checkNr = '9' or $checkNr = '10')"> 
                                    <F-value>1</F-value>
                                    <A-value>1</A-value>
                                    <I-value>1</I-value>
                                    <R-value>1</R-value>
                                </xsl:when>
                                <xsl:otherwise/>
                            </xsl:choose>
                        </xsl:for-each>
                    </Repo-VocabQ2>

                    <Repo-VocabURLQ2T>

                        <xsl:for-each
                            select="tokenize(local:removeHtmlTags(//plan_content[1]//sections[number/text()=3]/questions[number/text()=2]/answer/text), '\n')">
                            <Text>
                                <xsl:value-of select="."/>
                            </Text>
                        </xsl:for-each>

                        <xsl:choose>
                            <xsl:when
                                test="contains(//plan_content[1]//sections[number/text()=3]/questions[number/text()=2]/answer/text, 'http')">
                                <F-value>1</F-value>
                                <A-value>1</A-value>
                                <I-value>1</I-value>
                                <R-value>1</R-value>
                            </xsl:when>
                            <xsl:otherwise/>
                        </xsl:choose>
                    </Repo-VocabURLQ2T>
                </Metadata>


                <DataQualityQ3>
                    <xsl:for-each
                        select="//plan_content[1]//sections[number/text()=3]/questions[number/text()=3]/answer/options//text">
                        <xsl:variable name="checkNr">
                            <xsl:value-of
                                select="
                                    for $i in (.)
                                    return
                                        substring-before($i, '.')"
                            />
                        </xsl:variable>
                        <Option>
                            <xsl:value-of select="tokenize(local:removeHtmlTags(.), ' ')"/>
                        </Option>
                        <xsl:choose>
                            <xsl:when
                                test="($checkNr = '2' or $checkNr = '4' or $checkNr = '6' or $checkNr = '8')">
                                <F-value>1</F-value>
                                <A-value>1</A-value>
                                <I-value>1</I-value>
                                <R-value>1</R-value>
                            </xsl:when>
                            <xsl:when
                                test="($checkNr = '1' or $checkNr = '3' or $checkNr = '5' or $checkNr = '7' or $checkNr = '8')">
                                <I-value>1</I-value>
                                <R-value>1</R-value>
                            </xsl:when>
                            <xsl:otherwise/>
                        </xsl:choose>
                    </xsl:for-each>
                </DataQualityQ3>
                <!--        -->

            </sectionII>
            <sectionIII>
                <StorageQ1>
                    <xsl:for-each select="//sections[number/text()=4]/questions[number/text()=1]/answer/options//text">
                        <xsl:variable name="checkNr">
                            <xsl:value-of
                                select="
                                    for $i in (.)
                                    return
                                        substring-before($i, '.')"
                            />
                        </xsl:variable>
                        <Option>
                            <xsl:value-of select="tokenize(local:removeHtmlTags(.), ' ')"/>
                        </Option>
                    </xsl:for-each>
                    <xsl:variable name="opt">
                        <xsl:value-of select="//sections[number/text()=4]/questions[number/text()=1]/answer/options//text"/>
                    </xsl:variable>
                    <xsl:choose>
                        <xsl:when
                            test="contains($opt, '1') and contains($opt, '6') and (contains($opt, '3') or contains($opt, '4') or contains($opt, '9'))">
                            <A-value>1</A-value>
                        </xsl:when>
                        <xsl:when
                            test="contains($opt, '1') and contains($opt, '6') and (contains($opt, '5') or contains($opt, '7')) and contains(ancestor::answer/text, 'http')">
                            <A-value>1</A-value>
                        </xsl:when>
                        <xsl:otherwise/>
                    </xsl:choose>
                </StorageQ1>

            </sectionIII>
            <sectionIV>
                <PreventIllegitimateAccessQ2-Q3>                    
                        <xsl:choose>
                            <xsl:when
                                test="substring-before(replace(/array/creation_date, '-', ''), ' ') &lt; '20210718'">
                                <xsl:for-each select="//sections[number/text()=5]/questions[number/text()=2]/answer/options//text">
                                    <Option><xsl:value-of select="."/></Option>                    
                                </xsl:for-each>
                                
                                <xsl:variable name="optionsQ"><xsl:value-of select="for $i in (//sections[number/text()=5]/questions[number/text()=2]/answer/options//text) return $i"/></xsl:variable>
                                <xsl:choose>    
                                    <xsl:when test="string-length($optionsQ)> 10">       
                                        <A-value>1</A-value>
                                    </xsl:when>
                                    <xsl:otherwise/>
                                </xsl:choose>    
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:for-each select="//sections[number/text()=5]/questions[number/text()=3]/answer/options//text">
                                    <Option><xsl:value-of select="."/></Option> 
                                </xsl:for-each>
                                <xsl:if test="string-length((//sections[number/text()=5]/questions[number/text()=3]/answer/options//text)[1]) > 10">
                                    <A-value>1</A-value>
                                </xsl:if>
                            </xsl:otherwise>
                        </xsl:choose>
                 </PreventIllegitimateAccessQ2-Q3>
                
                <EthicalReviewApplQ4>
                    <xsl:for-each select="//sections[number/text()=5]/questions[number/text()=4]/answer/options//text">
                        <Option>
                            <xsl:value-of select="normalize-space(.)"/>
                        </Option>
                        <xsl:choose>
                            <xsl:when test="contains(.,'yes')">
                                <F-value>1</F-value>
                                <A-value>1</A-value> 
                            </xsl:when>
                            <xsl:when test="contains(.,'yet')">
                                <F-value>1</F-value>
                            </xsl:when>
                            <xsl:otherwise/>
                        </xsl:choose>                               
                    </xsl:for-each> 
                    <Text>
                        <xsl:value-of select="local:replacEndash(local:removeHtmlTags(//sections[number/text()=5]/questions[number/text()=4]/answer/text))"/>
                    </Text>
                    <xsl:choose>
                        <xsl:when test="contains(//sections[number/text()=5]/questions[number/text()=4]/answer/text, 'http')">
                            <F-value>1</F-value>
                            <A-value>1</A-value>                           
                        </xsl:when>
                        <xsl:when
                            test="string-length(//sections[number/text()=5]/questions[number/text()=4]/answer/text) &gt; 5">
                            <F-value>1</F-value>
                        </xsl:when>
                        <xsl:otherwise/>
                    </xsl:choose>                    
                </EthicalReviewApplQ4>
                
                <LicenseQ5>
                    <Text>
                        <xsl:value-of select="//sections[number/text()=5]/questions[number/text()=5]/answer/text"/>
                    </Text>
                    <xsl:choose>
                        <xsl:when test="contains(//sections[number/text()=5]/questions[number/text()=5]/answer/text, 'http')">
                            <A-value>1</A-value>
                            <R-value>1</R-value>
                        </xsl:when>
                        <xsl:when
                            test="string-length(//sections[number/text()=5]/questions[number/text()=5]/answer/text) &gt; 8 and (//sections[number/text()=5]/questions[number/text()=1]/answer/options//text) = 'yes'">
                            <R-value>1</R-value>
                        </xsl:when>
                        <xsl:otherwise/>
                    </xsl:choose>
                    <xsl:choose>
                        <xsl:when
                            test="substring-before(replace(/array/creation_date, '-', ''), ' ') &lt; '20210201'"/>
                        <xsl:otherwise>
                            <xsl:for-each select="//sections[number/text()=5]/questions[number/text()=5]/answer/options//text">
                                <xsl:variable name="checkNr">
                                    <xsl:value-of
                                        select="
                                            for $i in (.)
                                            return
                                                substring-before($i, '.')"/>
                                </xsl:variable>
                                
                                <Option>
                                    <xsl:value-of select="tokenize(local:removeHtmlTags(.), ' ')"/>
                                </Option>
                                <xsl:choose>
                                    <xsl:when test="$checkNr = '01' or $checkNr = '06'">
                                        <A-value>1</A-value>
                                        <R-value>1</R-value>
                                    </xsl:when>
                                    <xsl:when test="$checkNr = '12' or $checkNr = '13'"/>
                                    <xsl:otherwise>
                                        <R-value>1</R-value>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                        </xsl:otherwise>
                    </xsl:choose>
                </LicenseQ5>
            </sectionIV>
            <sectionV>
                
                        <AccessibleLocationQ1>
                            <xsl:for-each select="//sections[number/text()=6]/questions[number/text()=1]/answer/options//text">
                                <xsl:variable name="checkNr">
                                    <xsl:value-of
                                        select="
                                            for $i in (.)
                                            return
                                                substring-before($i, '.')"
                                    />
                                </xsl:variable>
                                <Option>
                                    <xsl:value-of select="tokenize(local:removeHtmlTags(.), ' ')"/>
                                </Option>
                                <xsl:choose>
                                    <xsl:when test="$checkNr = '1' or contains(., 'Repository')">
                                        <F-value>1</F-value>
                                        <A-value>1</A-value>
                                        <I-value>1</I-value>
                                        <R-value>1</R-value>
                                    </xsl:when>

                                    <xsl:otherwise/>
                                </xsl:choose>
                            </xsl:for-each>
                        </AccessibleLocationQ1>
                        <AccessibleContentQ2>
                            <xsl:for-each select="//sections[number/text()=6]/questions[number/text()=2]/answer/options//text">
                                <Option>
                                    <xsl:value-of select="."/>
                                </Option>
                                <xsl:choose>
                                    <xsl:when test="contains(., 'all')">

                                        <F-value>1</F-value>
                                        <A-value>1</A-value>
                                        <I-value>1</I-value>
                                        <R-value>1</R-value>
                                    </xsl:when>
                                    <xsl:when test="contains(., 'some')">

                                        <F-value>1</F-value>
                                        <A-value>1</A-value>
                                        <I-value>1</I-value>
                                    </xsl:when>
                                    <xsl:when test="contains(., 'Only')">
                                        <F-value>1</F-value>
                                        <A-value>1</A-value>
                                    </xsl:when>
                                    <xsl:otherwise/>
                                </xsl:choose>
                                <xsl:choose>
                                    <xsl:when test="contains(., 'Software')">
                                        <I-value>1</I-value>
                                        <R-value>1</R-value>
                                    </xsl:when>
                                    <xsl:otherwise/>
                                </xsl:choose>
                                <xsl:choose>
                                    <xsl:when test="contains(., 'Code')">

                                        <I-value>1</I-value>
                                        <R-value>1</R-value>
                                    </xsl:when>
                                    <xsl:otherwise/>
                                </xsl:choose>
                            </xsl:for-each>
                            <Text>
                                <xsl:value-of
                                    select="local:removeHtmlTags(//sections[number/text()=6]/questions[number/text()=2]/answer/text)"
                                />
                            </Text>
                            <xsl:choose>
                                <xsl:when
                                    test="string-length(local:removeHtmlTags(//sections[number/text()=6]/questions[number/text()=2]/answer/text)) &gt; 8">
                                    <R-value>1</R-value>
                                </xsl:when>
                                <xsl:otherwise/>
                            </xsl:choose>

                        </AccessibleContentQ2>
                        <AccessibleTimeQ3>
                            <xsl:variable name="optionsQ3">
                                <xsl:value-of
                                    select="//sections[number/text()=6]/questions[number/text()=3]/answer/options//text"/>
                            </xsl:variable>
                            <xsl:for-each select="//sections[number/text()=6]/questions[number/text()=3]/answer/options//text">
                                <Option>
                                    <xsl:value-of select="."/>
                                </Option>
                            </xsl:for-each>
                            <xsl:choose>
                                <xsl:when
                                    test="
                                        for $i in $optionsQ3
                                        return
                                            contains($i, 'Continuously')">
                                    <!--  <xsl:if test="for $i in $optionsQ3 return contains($i,'Continuously')">  -->
                                    <F-value>1</F-value>
                                    <A-value>1</A-value>
                                    <R-value>1</R-value>
                                    <!--     </xsl:if>    -->

                                </xsl:when>
                                <xsl:when
                                    test="
                                        for $i in $optionsQ3
                                        return
                                            contains($i, 'Only') or contains($i, 'completion') or contains($i, 'embargo')">

                                    <F-value>1</F-value>
                                    <A-value>1</A-value>
                                </xsl:when>
                                <xsl:otherwise/>
                            </xsl:choose>
                            <Text>
                                <xsl:value-of
                                    select="local:removeHtmlTags(//sections[number/text()=6]/questions[number/text()=3]/answer/text)"
                                />
                            </Text>
                            <xsl:choose>
                                <xsl:when
                                    test="string-length(local:removeHtmlTags(//sections[number/text()=6]/questions[number/text()=3]/answer/text)) &gt; 8">
                                    <A-value>1</A-value>
                                </xsl:when>
                                <xsl:otherwise/>
                            </xsl:choose>
                        </AccessibleTimeQ3>
                        <SpecialSWtoAnalyseQ5>
                            <xsl:for-each select="//sections[number/text()=6]/questions[number/text()=5]/answer/options//text">
                                <Option>
                                    <xsl:value-of select="."/>
                                </Option>
                                <xsl:choose>
                                    <xsl:when test=". = 'no'">
                                        <A-value>1</A-value>
                                        <I-value>1</I-value>
                                        <R-value>1</R-value>
                                    </xsl:when>
                                    <xsl:otherwise/>
                                </xsl:choose>
                            </xsl:for-each>
                            <Text>
                                <xsl:value-of
                                    select="local:removeHtmlTags(//sections[number/text()=6]/questions[number/text()=5]/answer/text)"/>
                            </Text>
                            <xsl:choose>
                                <xsl:when
                                    test="contains(local:removeHtmlTags(//sections[number/text()=6]/questions[number/text()=5]/answer/text), 'http')">
                                    <F-value>1</F-value>
                                    <A-value>1</A-value>
                                </xsl:when>
                                <xsl:when
                                    test="string-length(local:removeHtmlTags(//sections[number/text()=6]/questions[number/text()=5]/answer/text)) > 8">
                                    <F-value>1</F-value>
                                </xsl:when>
                                <xsl:otherwise/>
                            </xsl:choose>
                        </SpecialSWtoAnalyseQ5>
                        <SpecialSWtoRerunQ6>
                            <xsl:for-each select="//sections[number/text()=6]/questions[number/text()=6]/answer/options//text">
                                <Option>
                                    <xsl:value-of select="."/>
                                </Option>
                                <xsl:choose>
                                    <xsl:when test=". = 'no'">
                                        <A-value>1</A-value>
                                        <I-value>1</I-value>
                                        <R-value>1</R-value>
                                    </xsl:when>
                                    <xsl:otherwise/>
                                </xsl:choose>
                            </xsl:for-each>
                            <Text>
                                <xsl:value-of
                                    select="local:removeHtmlTags(//sections[number/text()=6]/questions[number/text()=6]/answer/text)"
                                />
                            </Text>
                            <xsl:choose>
                                <xsl:when
                                    test="contains(local:removeHtmlTags(//sections[number/text()=6]/questions[number/text()=6]/answer/text), 'http')">
                                    <F-value>1</F-value>
                                    <A-value>1</A-value>
                                </xsl:when>
                                <xsl:when
                                    test="string-length(local:removeHtmlTags(//sections[number/text()=6]/questions[number/text()=6]/answer/text)) > 8">
                                    <F-value>1</F-value>
                                </xsl:when>
                                <xsl:otherwise/>
                            </xsl:choose>
                        </SpecialSWtoRerunQ6>
                        <ProprietarySoftwareQ7>
                            <xsl:variable name="optionsQ7">
                                <xsl:value-of
                                    select="//sections[number/text()=6]/questions[number/text()=7]/answer/options//text"/>
                            </xsl:variable>
                            <xsl:for-each select="//sections[number/text()=6]/questions[number/text()=7]/answer/options//text">
                                <Option>
                                    <xsl:value-of select="normalize-space(.)"/>
                                </Option>
                            </xsl:for-each>
                            <xsl:choose>
                                <xsl:when
                                    test="
                                        for $i in $optionsQ7
                                        return
                                            contains($i, 'Open')">
                                    <A-value>1</A-value>
                                    <I-value>1</I-value>
                                    <R-value>1</R-value>
                                </xsl:when>
                                <xsl:otherwise/>
                            </xsl:choose>
                            <Text>
                                <xsl:value-of
                                    select="local:removeHtmlTags(//sections[number/text()=6]/questions[number/text()=7]/answer/text)"
                                />
                            </Text>
                            <xsl:choose>
                                <xsl:when
                                    test="contains(local:removeHtmlTags(//sections[number/text()=6]/questions[number/text()=7]/answer/text), 'http')">
                                    <F-value>1</F-value>
                                    <A-value>1</A-value>
                                </xsl:when>
                                <xsl:when
                                    test="string-length(local:removeHtmlTags(//sections[number/text()=6]/questions[number/text()=7]/answer/text)) > 8">
                                    <F-value>1</F-value>
                                </xsl:when>
                                <xsl:otherwise/>
                            </xsl:choose>
                        </ProprietarySoftwareQ7>
                        <SaaSinCloudQ8>
                            <xsl:for-each select="//sections[number/text()=6]/questions[number/text()=8]/answer/options//text">
                                <Option>
                                    <xsl:value-of select="normalize-space(.)"/>
                                </Option>
                            </xsl:for-each>
                            <Text>
                                <xsl:value-of
                                    select="local:removeHtmlTags(//sections[number/text()=6]/questions[number/text()=8]/answer/text)"
                                />
                            </Text>
                            <xsl:choose>
                                <xsl:when
                                    test="contains(local:removeHtmlTags(//sections[number/text()=6]/questions[number/text()=8]/answer/text), 'http')">
                                    <F-value>1</F-value>
                                    <A-value>1</A-value>
                                </xsl:when>
                                <xsl:when
                                    test="string-length(//sections[number/text()=6]/questions[number/text()=8]/answer/text) > 8">
                                    <F-value>1</F-value>                                    
                                </xsl:when>
                                <xsl:otherwise/>
                            </xsl:choose>
                        </SaaSinCloudQ8>
                       <PersonalDataProcessAgreeSaaSQ9>
                           <xsl:for-each select="//sections[number/text()=6]/questions[number/text()=9]/answer/options//text">
                               <Option>
                                   <xsl:value-of select="normalize-space(.)"/>
                               </Option>
                               <xsl:choose>
                                   <xsl:when test="contains(.,'yes')">
                                       <A-value>1</A-value> 
                                   </xsl:when>
                                   <xsl:otherwise/>
                               </xsl:choose>                               
                           </xsl:for-each>                         
                       </PersonalDataProcessAgreeSaaSQ9>
            </sectionV>
        </FAIRscore>
    </xsl:template>
</xsl:stylesheet>
