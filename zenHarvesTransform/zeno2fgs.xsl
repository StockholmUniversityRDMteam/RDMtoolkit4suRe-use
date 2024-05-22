<?xml version="1.0" encoding="UTF-8"?>

<!--2024-01-05 *Current version 0.91: Changed [aligning with figDataCite2FGS.xsl v0.2-v.0.3] <metsDocumentID/> from sip.xml to *METS.xml*, <xsl:copy-of select="//datacite:titles" copy-namespaces="no"/> to
     <titles><title><xsl:value-of select="local:removeHtmlTags(//datacite:title)"/></title></titles> AND csip:OTHERTYPE="{if (//datacite:resourceType/@resourceTypeGeneral='Text') then 'Publication' else 'Dataset'}" to csip:OTHERTYPE="{if (string-length(//datacite:resourceType) > 1) then //datacite:resourceType else //datacite:resourceType/@resourceTypeGeneral}"; 
     adjustments of mets/@OBJID, mets/@TYPE, mets/@PROFILE, mets/@csip:CONTENTINFORMATIONTYPE="MIXED", note/@csip:NOTETYPE="IDENTIFICATIONCODE" ... in accordance with https://www.riksarkivet.se/Media/pdf-filer/doi-t/Riksarkivets_tillampning_av_E-ARK_CSIP_och_SIP_V1.0.pdf 
    2023-12-15 Version 0.9: Changed datacite:resource/@xsi:schemaLocation (from //kernel-4.1) to: http://schema.datacite.org/meta/kernel-4.4/metadata.xsd ; thereby also allowing copy of <rights/>-element containing attributes. 
    Further changed to FGS Paketstruktur 2.0 (E-ARK CSIP & SIP 2.1.0) med xmlns:sip="https://DILCIS.eu/XML/METS/SIPExtensionMETS",  xsi:schemaLocation="http://www.loc.gov/METS/ schemas/mets.xsd csip schemas/DILCISExtensionMETS.xsd sip schemas/DILCISExtensionSIPMETS.xsd" and 
    PROFILE="https://earkcsip.dilcis.eu/profile/CSIP.xml" ext:CONTENTTYPESPECIFICATION="SIP">. This also means that relevant schemas must be part of each package locally.   
    2022-11-17 Version 0.8: Added mimetypes for '.kml', and '.kmz'
    2022-04-07 Version 0.7: Changed <description descriptionType="Abstract"> to replace also 'Uuml' and 'uuml' with Ü and ü. New function $local:replacePlusMinus to replace [&#177; or] &amp;plusmn; with ±. 
    2021-07-05 Version 0.6: Moved function local:removeHtmlTags before first template, and added '|&#xA;' to strings replaced by '', applied to mets/@LABEL.
              Added mimetypes for '.eeg', '.vhdr', '.vmrk' and (later update 20230104 from figMETS2fgs.xsl).inp.
              Prel. change of mets/@TYPE from hardcoded "Single records" to conditional TYPE="{if (//datacite:resourceType/@resourceTypeGeneral='Text') then 'Publication' else 'Unstructured'}
    2021-02-18/04-26 Version 0.5: Added file format info and mimetype for variants of netCDF /.cdf (20210426), + file extensions .ams and .jr6 (SND2021-44 geo magnetism case), + .dng (RA-guide on photo) and .jrn (su.figshare)  
    20201203-1204 Version 0.4: Added / changed mimetypes and file format info for file extensions for .dat and .irr, after manual test + DROID and JHOVE ...     
    2020-07-09/29 Version 0.3: Fixed replacement of forbidden characters in filenames with addition of '@' and replaced key with $keySlug to harmonize filenames received from eZFI.xq v0.3 and escape '/'. 
                  Also fixed file-IDs for multiple files, and multiple //datacite:description[@descriptionType="Other"]. Added more local functions to further normalize datacite:description[@descriptionType=Abstract]
                  incl. "Swedish" vowels Å/å, Ä/ä and Ö/ö.
                  Added mimetypes and file format info for file extensions '.fig', '.graphml', '.md', '.rst', '.seaview'.
    2020-07-06/08 Version 0.2: Updated filext2mimetypeMap from figMETS2fgs.xsl latest entries (20200701). Introduced new local function for replacement of html in datacite:description, local:quoteReplace. 
                    Revised dmd-ID to handle cases with datacite @identifierType="URL" (not valid acc. to schema, but still occurring) instead of DOI.
                    Changed from collective <xsl:copy-of select="//datacite:resource"/> to copy-of or amendments of individual datacite elements; notably changed source for datacite:identifier[@identifierType='DOI'] 
                    to $file_info_data/file_info/@DOI, which should work for all cases, even with datacite @identifierType="URL" (invalid)
    2020-06-16 Version 0.1, built on figMETS2fgs:
     [20200514-0722: latest v.09994: Added mimetypes and file format info for file extensions '.annot', '.brf','.fig', '.gii', '.graphml', '.label','.mgh', '.mgz', '.otf', '.RDS', 'srjs','.stats', '.surf', '.trigs', '.tsvs', '.ttls' .     
     20200424-0506 v0.9993: Replacement of 'Swedish' characters å,ä, ö + addition of possible (Dimensions) Grant_url, removed unused variables and code correction for Funder_title.
                   Added mimetypes for '.gz', '.dm3' and '.pyc' to $filext2mimetypeMap, for '.gz' and '.dm3' also added @PUID from PRONOM.]
    / joakim.philipson@su.se-->

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:mets="http://www.loc.gov/METS/"
        xmlns:csip="https://DILCIS.eu/XML/METS/CSIPExtensionMETS"
        xmlns:sip="https://DILCIS.eu/XML/METS/SIPExtensionMETS"
        xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xmlns:datacite="http://datacite.org/schema/kernel-4"
    xmlns:local="local-functions"
    exclude-result-prefixes="xsl xs mets">
    <xsl:output indent="no"/>


    <xsl:param name="file_info_data" as="document-node()"/>
    <xsl:param name="deliveryFeedType" as="xs:string"/>
    <xsl:variable name="OAI_FEED_TYPE" select="xs:string('oai')"/>

    <xsl:variable name="filext2mimetypeMap">
        <map>
            <entry filext="aac" mimetype="audio/aac"/>
            <entry filext="alnfaa" mimetype="text/plain" source="personalCommunication"
                date="20190701"/>
            <entry filext="ams" mimetype="application/octet-stream" openwith="https://www.agico.com/text/software/anisoft/anisoft.php" source="SND2021-44"
                date="20210218"/>
            <entry filext="annot" applicationType="https://datatypes.net/freesurfer-file-types"
                mimetype="application/octet-stream" source="https://datatypes.net/" date="20200701"/>
            <entry filext="asc" mimetype="text/plain" source="datatypes.net" date="20230619"/>
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
            <entry filext="exe" mimetype="application/vnd.microsoft.portable-executable"
                source="https://www.iana.org/assignments/media-types/application/vnd.microsoft.portable-executable"
                date="20220126" source2="PRONOM" PUID="fmt/899 or fmt/900 (64-bit)"/>
            <entry filext="fa" mimetype="application/octet-stream" fileinfo="FASTA-file(s) for DNA sequences" openwith="https://www.dnabaser.com/download/DNA-Baser-sequence-assembler/index.html" source="https://datatypes.net/"
                date="20230104"/>
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
            <entry filext="inp" mimetype="text/plain" source="JHOVE 1.18.1"
                source2="http://gretl.sourceforge.net/" openwith="Mplus" date="20210803"/>
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
            <entry filext="kml" applicationType="https://fileinfo.com/extension/kml"
                mimetype="application/vnd.google-earth.kml+xml" source="https://datatypes.net/open-kml-files" date="20221115"/>
            <entry filext="kmz" applicationType="https://fileinfo.com/extension/kmz"
                mimetype="application/vnd.google-earth.kmz" source="https://datatypes.net/open-kmz-files" date="20221115"/>
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
            <entry filext="omv" mimetype="application/java-archive" source="DROID v6.4" PUID="x-fmt/412"
                date="20220906"/>
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
            <entry filext="qmd" mimetype="text/plain" source="JHOVE 1.18.1" date="20220109"/>
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
            <entry filext="tar" mimetype="application/x-tar" source="https://datatypes.net/open-tar-files"
                date="20230104"/>
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
            <entry filext="vsdx" mimetype="application/vnd.visio"
                source="https://datatypes.net/open-vsdx-files" date="20230801"
                openwith="https://fileinfo.com/extension/vsdx" openwith2="https://drawio.com"/>
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
    
    <xsl:function name="local:removeHtmlTags" as="xs:string">
        <xsl:param name="element"/>
        <xsl:value-of
            select="normalize-space(replace($element, '&lt;[^\s][^&lt;]*>|&amp;nbsp;|&#xA;',' '))"/>
    </xsl:function>
    
<xsl:template match="/">
    
    <mets xmlns="http://www.loc.gov/METS/"
        xmlns:csip="https://DILCIS.eu/XML/METS/CSIPExtensionMETS"
        xmlns:sip="https://DILCIS.eu/XML/METS/SIPExtensionMETS"
        xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:schemaLocation="http://www.loc.gov/METS/ schemas/mets.xsd csip schemas/DILCISExtensionMETS.xsd sip schemas/DILCISExtensionSIPMETS.xsd"
        OBJID="{concat('IP_',substring-after(//datacite:identifier,'zenodo.'))}" LABEL="{local:removeHtmlTags(//datacite:title)}" TYPE="OTHER" csip:OTHERTYPE="{if (string-length(//datacite:resourceType) > 1) then //datacite:resourceType else //datacite:resourceType/@resourceTypeGeneral}" 
        PROFILE="https://earksip.dilcis.eu/profile/E-ARKSIP.xml" csip:CONTENTINFORMATIONTYPE="MIXED">

            <xsl:call-template name="createMetsHeader"/>


            <xsl:call-template name="createDmdSec"/>



            <xsl:call-template name="createFileSec"/>

            <xsl:call-template name="createStructMap"/>
       </mets>
    </xsl:template>

   
    <xsl:function name="local:replaceSpace">
        <xsl:param name="element"/>
        <xsl:value-of select="replace($element, 'nbsp;', '')"/>
    </xsl:function>
    <xsl:function name="local:replaceDash">
        <xsl:param name="element"/>
        <xsl:value-of select="replace($element, 'ndash;', '-')"/>
    </xsl:function>
    <xsl:function name="local:quoteReplace" as="xs:string">
        <xsl:param name="element"/>
        <xsl:value-of
            select="normalize-space(replace($element, 'ldquo;|rdquo;|#39;|quot;', &quot;&apos;&quot;))"/>
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
    <xsl:function name="local:replacePlusMinus">
        <xsl:param name="element"/>
        <xsl:value-of select="replace($element, '&amp;plusmn;', '±')"/></xsl:function>

    <xsl:template name="createMetsHeader">

        <metsHdr xmlns="http://www.loc.gov/METS/" CREATEDATE="{current-dateTime()}" RECORDSTATUS="NEW" csip:OAISPACKAGETYPE="SIP">


            <agent ROLE="ARCHIVIST" TYPE="ORGANIZATION">
                <name>
                    <xsl:value-of
                        select="concat('Stockholms universitet, ', $file_info_data/file_info/substring-after(@archivalInst,' '))"/>
                </name>
                <note csip:NOTETYPE="IDENTIFICATIONCODE">ORG:2021003062</note>
                <xsl:choose>
                    <xsl:when test="string-length($file_info_data/file_info/@archivalInst) &gt; 0">
                        <note>
                            <xsl:value-of
                                select="concat('InstNr:', $file_info_data/file_info/substring-before(@archivalInst,' '))"/>
                        </note>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>

            </agent>

            <agent ROLE="CREATOR" TYPE="ORGANIZATION">
                <name>Stockholms universitet</name>
                <note>ORG:2021003062</note>
            </agent>
            <agent ROLE="OTHER" OTHERROLE="PRODUCER" TYPE="ORGANIZATION">
                <name>Stockholms universitetsbibiliotek</name>
                <note>ORG:2021003062</note>
            </agent>

            <!-- 2019-07-02: amended note to include both main transform (XSLT) file with version no and extractFigsFileInfo.xq file with version no. -->
            <agent ROLE="ARCHIVIST" TYPE="OTHER" OTHERTYPE="SOFTWARE">
                <name>SUB-harvestTransformer_from_zenodo.org</name>
                <note>
                    <xsl:value-of
                        select="concat('zeno2fgs.xsl v0.91', ' extractZenFileInfo.xq ', $file_info_data/file_info/@SW-Agent_eZFIxq)"
                    />
                </note>
            </agent>

            <!-- 2020-03-10 Added Funder information. 
                  2020-04-21/27 Revision to handle multiple funders, addition of possible (Dimensions) Grant_url, removed unused variables and code correction for Funder_title.
             -->

            <xsl:for-each select="$file_info_data/file_info/funding__list/_">
                <agent ROLE="OTHER" TYPE="ORGANIZATION">

                    <xsl:choose>
                        <xsl:when
                            test="
                                exists(for $n in (./funder__name)
                                return
                                    $n[string-length($n) &gt; 0])">
                            <name>
                                <xsl:value-of select="concat('Funder_name:', ./funder__name/text())"
                                />
                            </name>

                        </xsl:when>

                        <xsl:when
                            test="
                                exists(for $t in (./title)
                                return
                                    $t[string-length($t) &gt; 0])">

                            <name>
                                <xsl:value-of select="concat('Funder_title:', ./title/text())"/>
                            </name>
                        </xsl:when>
                        <xsl:otherwise/>
                    </xsl:choose>

                    <xsl:choose>
                        <xsl:when
                            test="
                                exists(for $n in (./funder__name)
                                return
                                    $n[string-length($n) &gt; 0])">
                            <note>
                                <xsl:value-of select="concat('Funder_title:', ./title/text())"/>
                            </note>

                        </xsl:when>


                        <xsl:otherwise/>
                    </xsl:choose>

                    <xsl:choose>
                        <xsl:when
                            test="
                                exists(for $u in (./url)
                                return
                                    $u[string-length($u) &gt; 0])">
                            <note>
                                <xsl:value-of select="concat('Grant_url: ', ./url/text())"/>
                            </note>

                        </xsl:when>


                        <xsl:otherwise/>
                    </xsl:choose>
                    <xsl:choose>
                        <xsl:when
                            test="
                                exists(for $g in (./grant__code)
                                return
                                    $g[string-length($g) &gt; 0])">
                            <note>
                                <xsl:value-of select="concat('Grant_code:', ./grant__code/text())"/>
                            </note>

                        </xsl:when>


                        <xsl:otherwise/>
                    </xsl:choose>

                    <xsl:choose>
                        <xsl:when
                            test="
                                exists(for $i in (./id)
                                return
                                    $i[string-length($i) &gt; 0])">
                            <note>
                                <xsl:value-of
                                    select="concat('Funder_id:', replace(./id/text(), ' ', ''))"/>
                            </note>

                        </xsl:when>


                        <xsl:otherwise/>
                    </xsl:choose>

                </agent>
            </xsl:for-each>


            <agent ROLE="EDITOR" TYPE="INDIVIDUAL">
                <name>
                    <xsl:value-of select="$file_info_data/file_info/@prefSUauthorName"/>
                </name>
                <note>
                    <xsl:choose>
                        <xsl:when test="$file_info_data/file_info[@ALERT = 'ID-check!']">
                            <xsl:value-of select="'ID-check!'"/>
                        </xsl:when>
                        <xsl:when
                            test="string-length($file_info_data/file_info/@prefSUauthORCiD) &gt; 4">
                            <xsl:value-of
                                select="concat('ORCID:', $file_info_data/file_info/@prefSUauthORCiD)"
                            />
                        </xsl:when>
                        <xsl:when test="string-length($file_info_data/file_info/@sukatID) &gt; 1">
                            <xsl:value-of
                                select="concat('sukatID:', $file_info_data/file_info/@sukatID)"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="'No prefSUauthorID found!'"/>
                        </xsl:otherwise>
                    </xsl:choose>
                    <!-- End revision. -->
                </note>
            </agent>
            <altRecordID TYPE="SUBMISSIONAGREEMENT">https://zenodo.org</altRecordID>
            <metsDocumentID>METS.xml</metsDocumentID>

        </metsHdr>
    </xsl:template>
    
    <xsl:template name="createDmdSec">

        <dmdSec xmlns="http://www.loc.gov/METS/"
            ID="{if (//datacite:identifier/@identifierType='URL') then concat('dmd-',substring-after(//datacite:identifier,'record/')) else concat('dmd-',substring-after(//datacite:identifier,'zenodo.'))}">
            <mdWrap MDTYPE="OTHER">
                <xmlData>

                    <!--   <xsl:copy-of select="//datacite:resource"/>  -->
                    <resource xmlns="http://datacite.org/schema/kernel-4"
                        xsi:schemaLocation="http://datacite.org/schema/kernel-4 http://schema.datacite.org/meta/kernel-4.4/metadata.xsd">
                        <identifier identifierType="DOI">
                            <xsl:value-of select="$file_info_data/file_info/@DOI"/>
                        </identifier>
                        <xsl:copy-of select="//datacite:creators" copy-namespaces="no"/>
                        <!--   <xsl:copy-of select="//datacite:titles" copy-namespaces="no"/>  -->
                        <titles>
                            <title><xsl:value-of
                                select="local:removeHtmlTags(//datacite:title)"/></title>
                        </titles>
                        <xsl:copy-of select="//datacite:publisher" copy-namespaces="no"/>
                        <xsl:copy-of select="//datacite:publicationYear" copy-namespaces="no"/>
                        <xsl:copy-of select="//datacite:subjects" copy-namespaces="no"/>
                        <xsl:copy-of select="//datacite:dates" copy-namespaces="no"/>
                        <xsl:copy-of select="//datacite:resourceType" copy-namespaces="no"/>
                        <xsl:copy-of select="//datacite:relatedIdentifiers" copy-namespaces="no"/>
                        <xsl:copy-of select="//datacite:rightsList" copy-namespaces="no"/> 
                  
                        <descriptions>
                           <description descriptionType="Abstract">
                                 <xsl:value-of
                                     select="local:replacePlusMinus(local:replaceSuuml(local:replaceUuml(local:replaceSaring(local:replaceAuml(local:replaceSauml(local:replaceSouml(local:replaceOuml(local:replaceDash(local:replaceSpace(local:quoteReplace(local:removeHtmlTags(//datacite:description[@descriptionType = 'Abstract']))))))))))))"
                                /> 
                            </description>
                            <xsl:for-each
                                select="//datacite:description[@descriptionType = 'Other']/text()">
                                <description descriptionType="Other">
                                    <xsl:copy select="." copy-namespaces="no"/>
                                </description>
                            </xsl:for-each>
                        </descriptions>
                    </resource>
                </xmlData>

            </mdWrap>
        </dmdSec>
    </xsl:template>

    <xsl:template name="createFileSec">

        <fileSec xmlns="http://www.loc.gov/METS/">
            <xsl:variable name="linkOnly">
                <xsl:value-of select="($file_info_data/file_info/files/_/is__link__only)"/>
            </xsl:variable>
            <xsl:variable name="fileXtID">
                <xsl:value-of select="'fileXternal-'"/>
            </xsl:variable>

            <fileGrp
                ID="{if (//datacite:identifier/@identifierType='URL') then concat('files-',substring-after(//datacite:identifier,'record/')) else concat('files-',substring-after(//datacite:identifier,'zenodo.'))}">
                <!--  USED-TO-BE: ID="{for $f in ($file_info_data/file_info/files/_) return (concat('files-',substring-after(//datacite:identifier,'/')))}">   -->
                <xsl:choose>
                    <xsl:when test="string-length($file_info_data/file_info/files/_[1]) &gt; 1">
                        <xsl:for-each select="$file_info_data/file_info/files/_">
                            <file>
                                <!-- <xsl:attribute name="ID" select="if (is__link__only = 'true') 
                         then ('file-0') else
                                    concat('file-', id)"/> -->
                                <xsl:variable name="keySlug"
                                    select="
                                        for $s in key
                                        return
                                            if (contains($s, '/')) then
                                                substring-after($s, '/')
                                            else
                                                $s"/>
                                <xsl:variable name="replaceSpace"
                                    select="replace($keySlug, ' |@', '_')"/>
                                <xsl:variable name="replace-å"
                                    select="
                                        for $i in $replaceSpace
                                        return
                                            replace($i, 'å', 'a')"/>
                                <xsl:variable name="replace-ä"
                                    select="
                                        for $j in $replace-å
                                        return
                                            replace($j, 'ä', 'a')"/>
                                <xsl:variable name="replace-ö"
                                    select="
                                        for $k in $replace-ä
                                        return
                                            replace($k, 'ö', 'o')"/>
                                <xsl:attribute name="ID"
                                    select="
                                        concat('file-', (
                                        for $f in .
                                        return
                                            position()[$f]))"/>
                                <xsl:attribute name="CREATED" select="ancestor::file_info/@created"/>
                                <xsl:attribute name="OWNERID"
                                    select="
                                        if (is__link__only = 'true') then
                                            ancestor::file_info/manualFileName
                                        else
                                            $replace-ö"/>
                                <xsl:attribute name="SIZE"
                                    select="
                                        if (is__link__only = 'true')
                                        then
                                            ancestor::file_info/manualFileSize
                                        else
                                            size"/>
                                <xsl:attribute name="CHECKSUMTYPE" select="'MD5'"/>


                                <xsl:attribute name="CHECKSUM"
                                    select="
                                        if (is__link__only = 'true') then
                                            ancestor::file_info/manualMD5
                                        
                                        else
                                            substring-after(checksum, 'md5:')"/>

                                <xsl:attribute name="MIMETYPE"
                                    select="
                                        if (is__link__only = 'true') then
                                            for $f in (tokenize(ancestor::file_info/manualFileName, '\.')[last()])
                                            return
                                                (if ($filext2mimetypeMap//entry[@filext = $f]/@mimetype) then
                                                    $filext2mimetypeMap//entry[@filext = $f]/@mimetype
                                                else
                                                    'application/unknown')
                                        else
                                            for $i in (tokenize(key, '\.')[last()])
                                            return
                                                (if ($filext2mimetypeMap//entry[@filext = $i]/@mimetype) then
                                                    $filext2mimetypeMap//entry[@filext = $i]/@mimetype
                                                else
                                                    'application/unknown')"/>
                                <!-- alternative older solution, does not work for filenames with inherent '.':s: <xsl:attribute name="MIMETYPE" select="for $i in (substring-after(name,'.')) return $filext2mimetypeMap//entry[@filext = $i]/@mimetype"/> -->
                                <FLocat xmlns:xlink="http://www.w3.org/1999/xlink"
                                    LOCTYPE="URL" xlink:href="{links/self}"/>

                            </file>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:when test="string-length($file_info_data/file_info/files) = 0">
                        <file>
                            <xsl:attribute name="ID" select="'file-0'"/>
                            <xsl:attribute name="CREATED"
                                select="$file_info_data/file_info/@created"/>
                            <xsl:attribute name="OWNERID"
                                select="
                                    $file_info_data/file_info/manualFileName
                                    "/>
                            <xsl:attribute name="SIZE"
                                select="$file_info_data/file_info/manualFileSize"/>
                            <xsl:attribute name="CHECKSUMTYPE" select="'MD5'"/>


                            <xsl:attribute name="CHECKSUM"
                                select="$file_info_data/file_info/manualMD5"/>

                            <xsl:attribute name="MIMETYPE"
                                select="
                                    for $f in (tokenize($file_info_data/file_info/manualFileName, '\.')[last()])
                                    return
                                        (if ($filext2mimetypeMap//entry[@filext = $f]/@mimetype) then
                                            $filext2mimetypeMap//entry[@filext = $f]/@mimetype
                                        else
                                            'application/unknown')"/>
                            <FLocat xmlns:xlink="http://www.w3.org/1999/xlink" LOCTYPE="URL"
                                xlink:href="{$file_info_data/file_info/references}"/>

                        </file>
                    </xsl:when>
                </xsl:choose>





            </fileGrp>
        </fileSec>
    </xsl:template>

    <xsl:template name="createStructMap">
        <structMap xmlns="http://www.loc.gov/METS/" TYPE="physical">
            <div LABEL="files">

                <xsl:for-each select="$file_info_data/file_info/files/_">
                    <div
                        LABEL="{substring-before(for $i in (tokenize(key,'\.')[last()]) return $filext2mimetypeMap//entry[@filext = $i]/@mimetype,'/')}">


                        <fptr
                            FILEID="{concat('file-',(
                            for $f in .
                            return
                            position()[$f]))}"
                        />
                    </div>
                </xsl:for-each>
            </div>
        </structMap>

    </xsl:template>

    <xsl:template match="datacite:identifier">
        <mets>
            <xsl:copy-of select="@*"/>
            <xsl:value-of select="."/>
        </mets>
    </xsl:template>

</xsl:stylesheet>
