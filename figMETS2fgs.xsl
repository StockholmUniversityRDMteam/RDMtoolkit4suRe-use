<?xml version="1.0" encoding="UTF-8"?>
<!--This is the Public version 2.0 of the figMETS2fgs.xslt (the Stockholm University specific version of which has substantially developed and was continuously pushed to GitLab).
    2020-04-30: *Public version 2.0: Removed internal local user db SUKAT-URLs, replacing variable names including 'sukat','su', 'SU' for Stockholm University, with 'local' or 'LOCAL'. 
    These changes then are not reflected in the version history below.
    2020-04-24/27: v0.9993: Replacement of 'Swedish' characters å, ä, ö + addition of possible (Dimensions) Grant_url, removed unused variables and code correction for Funder_title.
    2020-04-21: v0.9992: Revision to handle presence of multiple funders in file_info.xml .
    2020-04-01: v0.9991: dc:date added to dmdSec, and order of dc-elements changed.
    2020-03-30/31: v0.999 Changed handling of filenames in replace(name, '%20', '_') to replace(name, ' ', '_') to sync with eFFi.xq v0.999. (Also added mimetypes for file extensions .ipynb, .mxd, .prn, .pth, .qpj, .r, .raw and .vcf).   
    2020-03-25/26: v0.9981 Added/changed mimetype="application/x-bibtex" for file extensions .bib and .bst, mimetype="application/x-latex" for .sty and .tex, all used within LaTex files. Further added/changed mimetypes for .bdf, .dmp and .fif! 
    2020-03-18: v0.998 Adjusted conditions for older items of only metadata, with data file(s) deposited externally to Figshare, downloaded manually ($manualFileName, $manualFileSize, $manualMD5 and FLocat/@href from dcterms:references.   
    2020-03-17: v0.997 Added/updated mimetype="text/x-rsrc", source and date for file-extensions .R, .Rda, .RData from digipres.org; not ideal, since different fileformat identification tools (Datatypes.net, DROID, JHOVE, PRONOM) give other results, 
    and files should not be opened simply as text-files, but with RStudio or R.     
    2020-03-11: v0.996 Added references as dcterms:references, Associated Publication as dcterms:isReferencedBy, and DMP reference as dcterms:relation.  
    2020-03-10: v0.995 Added possible Funder information as mets:agent.
    2020-03-01: v0.994 Updated and fixed major flaw, to get @CHECKSUMTYPE and @CHECKSUM for all files, for $linkOnly cases to be retrieved manually.
    2020-02-28: v0.993 Updated and changed $linkOnly, @FILENAME och @MIMETYPE to accommodate items with datafiles external to figshare, and to align with eFFIxq v0.996.  
    2020-01-09/10: v0.9921 Added mimetype (text/plain) for '.mb' and '.nxs', 'application/octet-stream' for .dta (Stata data).
    2019-12-03/16: v0.992 Added mimetype (text/plain) for '.codeml', '.out', '.phylip and '.newick'; 2019-12-16 also mimetype text/plain for '.sps', application/octet-stream for '.sav', '.spv' (SPSS-file formats). 
    2019-09-22: v0.9912 Added mimetypes for '.cbf' and '.sfrm' + introduced separate attribute @date of @source consulted for file format identification in filext2mimetypeMap/entry
    2019-09-12: v0.9911 Added mimetype for '.fif' to mapping-table. 
    2019-08-29: v0.991 Changed handling of filenames with spaces, replacing '%20' by '_' (underscore) instead of encoding for URI in attribute @OWNERID, to make sure files can still be opened by clickable file names.
                       Further changed condition for preference of ORCID to string-length(@prefSUauthORCID > 4), since file_info.xml will have value "None" if no ORCID found.
    2019-07-18: v0.99 Aligned with extractFigsFileInfo.xq - v0.99 insofar as tested to work with it, but without taking advantage of new properties and possibilities.  
    2019-07-10: v0.98 Aligned with extractFigsFileInfo.xq - v0.98 by replacing @firstAuth- and @firstSUauth-attributes with @prefSUauth-attributes and new variables.
                      Also added mime-type for file-extension '.tsv' to filext2mimetypeMap, with @source and @date. 
    2019-07-02: v0.97 Amended <mets:agent ROLE="ARCHIVIST" TYPE="OTHER" OTHERTYPE="SOFTWARE"> mets:note to include both main transform (XSLT) file with version no and extractFigsFileInfo.xq file with version no. for metadata provenance. 
    2019-07-01: v0.96 Replaced @sukatInst with @archivalInst and @sukat1Instnr with @sukatInstnr in <mets:agent ROLE="ARCHIVIST" TYPE="ORGANIZATION"> to align with updated extractFigsFileInfo.xq - v0.96. Also added new file extension .alnfaa to filext2mimetypeMap. -->
<!-- 2019-05-21: v0.9 Added new conditional <mets:note>-element to agent for SU institutionNr if not empty in file_info. 
                      Removed second <mets:agent ROLE="EDITOR" TYPE="INDIVIDUAL"><copy-of agent[2]/> 
                      Removed firstAuthorID <mets:agent ROLE="EDITOR" TYPE="INDIVIDUAL"><mets:note/> substantially for different cases 1) Alert: ID-check! (e.g. > 1 ORCIDs or sukatIDs found), 2) ORCID found, 3) sukatID found, 4) No firstSUauthorID found. -->
<!-- 2019-03-19: v0.8 Added new variable $firstAuthorID, to accomodate ORCiDs or other personID, if no @ALERT="ID-check!" in param doc file_info.xml. 
                      Added mime-type for file extension '.Rmd' to filext2mimetypeMap, with @source and @date. -->
<!-- 2019-01-18: v0.7 Added mime-type for file extension '.mat' to filext2mimetypeMap, with comment about alternative use. -->
<!-- 2018-09-05: v0.6 Added and changed AGENT values; 2018-09-12 added mets:agent with mets:note ORCID / sukatID of first author.  --> 
<!-- 2018-07-24: v0.5 Added  missing last digit in default for mets:agent[@ROLE="ARCHIVIST" TYPE="ORGANIZATION"]/mets:note = "ORG:2021003062". -->
<!-- 2018-07-17: v0.4 Updated with enlarged filext2mimetypeMap for some shapefiles and some 
    opendocument fileformats (.odp, .ods, .odt), including 'source' of mimetype attribution for provenance
    + added default @MIMETYPE = 'application/unknown' for file-extensions that are not (yet) found in the 
    filext2mimetypeMap. Also added default mets:fileGrp/@ID = 'filembargo-article-(no.)' for cases of 
    embargoed file access. Removed automatic namespace inclusion from 'copy-of' elements in dmdSec 
    by means of @copy-namespaces="no". / joakim.philipson@su.se-->
<!-- 2018-03-27: v0.3 Updated with enlarged filext2mimetypeMap, changed creation of @MIMETYPE by means of 
    tokenize (to account for filenames with inherent '.'), now functioning removal of HTML-tags from 
    dc:description and more accurate mets:dmdSec. Also changed default hardcoded value of 
    ext:CONTENTTYPESPECIFICATION to current FGS-CSPackage specification, awaiting dedicated FGS-CommonSpec. 
    for research data / research material./ joakim.philipson@su.se-->

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:mets="http://www.loc.gov/METS/"
    xmlns:ext="ExtensionMETS" xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:dcterms="http://purl.org/dc/terms/" xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:OAI-PMH="http://www.openarchives.org/OAI/2.0/"
    xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:local="local-functions"
    exclude-result-prefixes="xsl xs">
    <xsl:output indent="no"/>


    <xsl:param name="file_info_data" as="document-node()"/>
    <xsl:param name="deliveryFeedType" as="xs:string"/>
    <xsl:variable name="OAI_FEED_TYPE" select="xs:string('oai')"/>

    <xsl:variable name="filext2mimetypeMap">
        <map>
            <entry filext="aac" mimetype="audio/aac"/>
            <entry filext="alnfaa" mimetype="text/plain" source="personalCommunication"
                date="20190701"/>
            <entry filext="aspx" mimetype="text/plain" source="datatypes.net" date="20191003"/>
            <entry filext="bdf" mimetype="application/octet-stream" source="JHOVE 1.18.1"
                date="20200326"/>
            <entry filext="bib" mimetype="application/x-bibtex" source="https://datatypes.net/"
                date="20200325"/>
            <entry filext="bst" mimetype="application/x-bibtex" source="https://datatypes.net/"
                date="20200325"/>
            <entry filext="cbf" mimetype="application/octet-stream"
                source="BaseX9.1/fetch:content-type" date="20190922"/>
            <entry filext="cpg" mimetype="text/plain" source="JHOVE 1.18.1"/>
            <entry filext="css" mimetype="text/css" source="https://datatypes.net/" date="20180712"/>
            <entry filext="csv" mimetype="text/csv" source="https://datatypes.net/" date="20180712"/>
            <entry filext="codeml" mimetype="text/plain" source="JHOVE 1.18.1" date="20191203"/>
            <entry filext="dat" mimetype="application/octet-stream" source="https://datatypes.net/"
                date="20180712"/>
            <entry filext="dbf" mimetype="application/octet-stream" source="JHOVE 1.18.1"/>
            <entry filext="dmp" mimetype="application/vnd.tcpdump.pcap" source="PRONOM"
                sourcedate="20200326"/>
            <entry filext="doc" mimetype="application/msword" source="https://datatypes.net/"
                date="20180712"/>
            <entry filext="docx" mimetype="application/vnd.openxmlformats"
                source="https://datatypes.net/" date="20180712"/>
            <entry filext="dta" mimetype="application/octet-stream" source="JHOVE 1.18.1"
                date="20200110"/>
            <entry filext="fif" mimetype="application/octet-stream" source="JHOVE 1.18.1"
                date="20200326"/>
            <entry filext="fits" mimetype="application/octet-stream" source="https://datatypes.net/"
                date="20191003"/>
            <entry filext="gif" mimetype="image/gif" source="https://datatypes.net/" date="20180712"/>
            <entry filext="htm" mimetype="text/html" source="https://datatypes.net/" date="20180712"/>
            <entry filext="html" mimetype="text/html" source="https://datatypes.net/"
                date="20180712"/>
            <entry filext="ipynb" mimetype="application/octet-stream"
                source="https://datatypes.net/" date="20200331"/>
            <entry filext="jar" mimetype="application/java-archive" source="https://datatypes.net/"
                date="20180712"/>
            <entry filext="jasp" mimetype="application/octet-stream" source="JHOVE 1.18.1"/>
            <entry filext="jpeg" mimetype="image/jpeg" source="https://datatypes.net/"
                date="20180712"/>
            <entry filext="jpg" mimetype="image/jpeg" source="https://datatypes.net/"
                date="20180712"/>
            <entry filext="js" mimetype="text/javascript" source="https://datatypes.net/"
                date="20180712"/>
            <entry filext="json" mimetype="text/plain" source="JHOVE 1.18.1"/>
            <entry filext="m" mimetype="application/matlab-m" source="https://datatypes.net/"
                date="20180712"/>
            <entry filext="mat" mimetype="application/matlab-mat" source="https://datatypes.net/"
                date="20190118"/>
            <!-- Please note that same file extension '.mat' is also used for Microsoft Access Table, with mime-type: application/vnd.ms-access! -->
            <entry filext="m4v" mimetype="video/x-m4v" source="https://datatypes.net/"
                date="20180712"/>
            <entry filext="mb" mimetype="text/plain" source="JHOVE 1.18.1" date="20200109"/>
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
            <entry filext="qpj" mimetype="application/octet-stream" source="https://datatypes.net/"
                date="20200331"/>
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
            <entry filext="Rmd" mimetype="text/x-gfm"
                source="https://www.digipres.org/formats/sources/githublinguist/formats/#313"
                date="20190319"/>
            <entry filext="sav" mimetype="application/octet-stream" source="JHOVE 1.18.1"
                date="20191216"/>
            <entry filext="sbn" mimetype="application/octet-stream" source="JHOVE 1.18.1"/>
            <entry filext="sbx" mimetype="application/octet-stream" source="JHOVE 1.18.1"/>
            <entry filext="sfrm" mimetype="application/octet-stream" source="https://datatypes.net/"
                date="20190922"/>
            <entry filext="sh" mimetype="text/plain" source="https://datatypes.net/" date="20191110"/>
            <entry filext="shp" mimetype="application/octet-stream" source="JHOVE 1.18.1"/>
            <entry filext="shx" mimetype="application/octet-stream" source="JHOVE 1.18.1"/>
            <entry filext="sps" mimetype="text/plain" source="JHOVE 1.18.1" date="20191216"/>
            <entry filext="spv" mimetype="application/octet-stream" source="JHOVE 1.18.1"
                date="20191216"/>
            <entry filext="srt" mimetype="text/plain" source="https://datatypes.net/"
                date="20180712"/>
            <entry filext="sty" mimetype="application/x-latex" source="https://datatypes.net/"
                date="20200325"/>
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
            <entry filext="tsv" mimetype="text/tab-separated-values" source="fetch:content-type"
                date="20190710"/>
            <entry filext="txt" mimetype="text/plain" source="https://datatypes.net/"
                date="20180816"/>
            <entry filext="vcf" mimetype="application/octet-stream" source="https://datatypes.net/"
                date="20200331"/>
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
            <entry filext="xsl" mimetype="text/xml" source="JHOVE 1.18.1"/>
            <entry filext="xq" mimetype="text/plain" source="JHOVE 1.18.1"/>
            <entry filext="xquery" mimetype="text/plain" source="JHOVE 1.18.1"/>
            <entry filext="zip" mimetype="application/x-zip-compressed"
                source="https://datatypes.net/" date="20180724"/>
        </map>
    </xsl:variable>

    <xsl:template match="/">

        <mets xmlns="http://www.loc.gov/METS/" xmlns:xlink="http://www.w3.org/1999/xlink"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:ext="ExtensionMETS"
            xsi:schemaLocation="http://www.loc.gov/METS/ http://xml.ra.se/e-arkiv/METS/CSPackageMETS.xsd ExtensionMETS http://xml.ra.se/e-arkiv/METS/CSPackageExtensionMETS.xsd"
            OBJID="{//dc:identifier}" LABEL="{//dc:title}" TYPE="Single records"
            PROFILE="http://xml.ra.se/e-arkiv/METS/CommonSpecificationSwedenPackageProfile.xml"
            ext:CONTENTTYPESPECIFICATION="https://riksarkivet.se/Media/pdf-filer/doi-t/FGS_Paketstruktur_RAFGS1V1_2.pdf">

            <xsl:call-template name="createMetsHeader">
                <xsl:with-param name="sipMetsHeader" select="//mets:mets/mets:metsHdr"/>
            </xsl:call-template>

            <xsl:call-template name="createDmdSec"/>

            <xsl:call-template name="createFileSec"/>

            <xsl:call-template name="createStructMap"/>

        </mets>
    </xsl:template>


    <xsl:function name="local:removeHtmlTags" as="xs:string">
        <xsl:param name="element"/>
        <xsl:value-of
            select="normalize-space(replace($element, '&lt;[^\s][^&lt;]*>|&amp;nbsp;',' '))"/>
    </xsl:function>

    <xsl:template name="createMetsHeader">
        <xsl:param name="sipMetsHeader" required="yes" as="element(mets:metsHdr)"/>
        <mets:metsHdr CREATEDATE="{current-dateTime()}"
            RECORDSTATUS="{($sipMetsHeader/@RECORDSTATUS,'NEW')[1]}" ext:OAISSTATUS="SIP">


            <mets:agent ROLE="ARCHIVIST" TYPE="ORGANIZATION">
                <mets:name>
                    <xsl:value-of
                        select="concat('LOCAL, ', $file_info_data/file_info/@archivalInst)"/>
                </mets:name>
                <mets:note>ORG:2021003062</mets:note>
                <xsl:choose>
                    <xsl:when test="string-length($file_info_data/file_info/@localInstnr) &gt; 0">
                        <mets:note>
                            <xsl:value-of
                                select="concat('InstNr:', $file_info_data/file_info/@localInstnr)"/>
                        </mets:note>
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>

            </mets:agent>

            <mets:agent ROLE="CREATOR" TYPE="ORGANIZATION">
                <mets:name>LOCAL</mets:name>
                <mets:note>ORG:localOrganisationNr</mets:note>
            </mets:agent>
            <mets:agent ROLE="OTHER" OTHERROLE="PRODUCER" TYPE="ORGANIZATION">
                <mets:name>LocalProducerDeptName</mets:name>
                <mets:note>ORG:localOrganisationNr(may be same as above)</mets:note>
            </mets:agent>

            <!-- 2019-07-02: amended mets:note to include both main transform (XSLT) file with version no and extractFigsFileInfo.xq file with version no. -->
            <mets:agent ROLE="ARCHIVIST" TYPE="OTHER" OTHERTYPE="SOFTWARE">
                <mets:name>oai-pmh-harvestTransformer_from_local.figshare.com</mets:name>
                <mets:note>
                    <xsl:value-of
                        select="concat('figMETS2fgs.xsl v0.9993', ' extractFigsFileInfo.xq ', $file_info_data/file_info/@SW-Agent_eFFIxq)"
                    />
                </mets:note>
            </mets:agent>

            <!-- 2020-03-10 Added Funder information. 
                  2020-04-21/27 Revision to handle multiple funders, addition of possible (Dimensions) Grant_url, removed unused variables and code correction for Funder_title.
             -->

            <xsl:for-each select="$file_info_data/file_info/funding__list/_">
                <mets:agent ROLE="OTHER" TYPE="ORGANIZATION">

                    <xsl:choose>
                        <xsl:when
                            test="
                                exists(for $n in (./funder__name)
                                return
                                    $n[string-length($n) &gt; 0])">
                            <mets:name>
                                <xsl:value-of select="concat('Funder_name:', ./funder__name/text())"
                                />
                            </mets:name>

                        </xsl:when>

                        <xsl:when
                            test="
                                exists(for $t in (./title)
                                return
                                    $t[string-length($t) &gt; 0])">

                            <mets:name>
                                <xsl:value-of select="concat('Funder_title:', ./title/text())"/>
                            </mets:name>
                        </xsl:when>
                        <xsl:otherwise/>
                    </xsl:choose>

                    <xsl:choose>
                        <xsl:when
                            test="
                                exists(for $n in (./funder__name)
                                return
                                    $n[string-length($n) &gt; 0])">
                            <mets:note>
                                <xsl:value-of select="concat('Funder_title:', ./title/text())"/>
                            </mets:note>

                        </xsl:when>


                        <xsl:otherwise/>
                    </xsl:choose>

                    <xsl:choose>
                        <xsl:when
                            test="
                                exists(for $u in (./url)
                                return
                                    $u[string-length($u) &gt; 0])">
                            <mets:note>
                                <xsl:value-of select="concat('Grant_url: ', ./url/text())"/>
                            </mets:note>

                        </xsl:when>


                        <xsl:otherwise/>
                    </xsl:choose>
                    <xsl:choose>
                        <xsl:when
                            test="
                                exists(for $g in (./grant__code)
                                return
                                    $g[string-length($g) &gt; 0])">
                            <mets:note>
                                <xsl:value-of select="concat('Grant_code:', ./grant__code/text())"/>
                            </mets:note>

                        </xsl:when>


                        <xsl:otherwise/>
                    </xsl:choose>

                    <xsl:choose>
                        <xsl:when
                            test="
                                exists(for $i in (./id)
                                return
                                    $i[string-length($i) &gt; 0])">
                            <mets:note>
                                <xsl:value-of
                                    select="concat('Funder_id:', replace(./id/text(), ' ', ''))"/>
                            </mets:note>

                        </xsl:when>


                        <xsl:otherwise/>
                    </xsl:choose>

                </mets:agent>
            </xsl:for-each>


            <mets:agent ROLE="EDITOR" TYPE="INDIVIDUAL">
                <mets:name>
                    <xsl:value-of select="$file_info_data/file_info/@prefLOCALauthorNameInv"/>
                </mets:name>
                <mets:note>
                    <!-- Revision 2019-05-21 v0.9: -->
                    <xsl:choose>
                        <xsl:when test="$file_info_data/file_info[@ALERT = 'ID-check!']">
                            <xsl:value-of select="'ID-check!'"/>
                        </xsl:when>
                        <xsl:when
                            test="string-length($file_info_data/file_info/@prefLOCALauthORCiD) &gt; 4">
                            <xsl:value-of
                                select="concat('ORCID:', substring-after($file_info_data/file_info/@prefLOCALauthORCiD, 'orcid.org/'))"
                            />
                        </xsl:when>
                        <xsl:when test="string-length($file_info_data/file_info/@localID) &gt; 1">
                            <xsl:value-of
                                select="concat('localID:', $file_info_data/file_info/@localID)"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="'No prefLOCALauthorID found!'"/>
                        </xsl:otherwise>
                    </xsl:choose>
                    <!-- End revision. -->
                </mets:note>
            </mets:agent>
            <xsl:copy-of
                select="$sipMetsHeader/mets:altRecordID[@TYPE = ('DELIVERYTYPE', 'DELIVERYSPECIFICATION')]"
                copy-namespaces="no"/>
            <xsl:variable name="incomingSubmissionAgreement"
                select="$sipMetsHeader/mets:altRecordID[@TYPE = 'SUBMISSIONAGREEMENT']"/>
            <mets:altRecordID TYPE="SUBMISSIONAGREEMENT"
                >https://local.figshare.com</mets:altRecordID>
            <mets:metsDocumentID>sip.xml</mets:metsDocumentID>

        </mets:metsHdr>
    </xsl:template>


    <xsl:template name="createDmdSec">

        <mets:dmdSec ID="{//mets:dmdSec/@ID}">
            <mets:mdWrap MDTYPE="DC">
                <mets:xmlData>
                    <!-- <xsl:copy-of select="//dc:record"/> -->
                    <dc:record
                        xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/oai_dc/ http://www.openarchives.org/OAI/2.0/oai_dc.xsd">
                        <xsl:copy-of select="//dc:title" copy-namespaces="no"/>
                        <xsl:copy-of select="//dc:creator" copy-namespaces="no"/>
                        <xsl:copy-of select="//dc:contributor" copy-namespaces="no"/>
                        <xsl:copy-of select="//dc:identifier" copy-namespaces="no"/>
                        <!-- 2020-04-01 v0.9991: dc:date added. -->
                        <xsl:copy-of select="//dc:date" copy-namespaces="no"/>
                        <xsl:copy-of select="//dc:type" copy-namespaces="no"/>
                        <xsl:copy-of select="//dc:relation" copy-namespaces="no"/>
                        <xsl:copy-of select="//dc:rights" copy-namespaces="no"/>
                        <dc:description>
                            <xsl:value-of select="local:removeHtmlTags(//dc:description)"/>
                        </dc:description>
                        <xsl:copy-of select="//dc:subject" copy-namespaces="no"/>
                        <xsl:copy-of select="//dcterms:hasVersion" copy-namespaces="no"/>
                        <xsl:copy-of select="//dcterms:hasPart" copy-namespaces="no"/>
                        <xsl:for-each select="$file_info_data/file_info/references/_">
                            <dcterms:references>
                                <xsl:value-of select="."/>
                            </dcterms:references>
                        </xsl:for-each>
                        <xsl:choose>
                            <xsl:when
                                test="string-length($file_info_data/file_info/custom__fields/_[name = 'Associated Publication']/value) &gt; 0">
                                <dcterms:isReferencedBy>
                                    <xsl:value-of
                                        select="$file_info_data/file_info/custom__fields/_[name = 'Associated Publication']/value"
                                    />
                                </dcterms:isReferencedBy>
                            </xsl:when>
                            <xsl:otherwise/>
                        </xsl:choose>
                        <xsl:choose>
                            <xsl:when
                                test="string-length($file_info_data/file_info/custom__fields/_[contains(name, 'DMP')]/value) &gt; 0">
                                <dcterms:relation>
                                    <xsl:value-of
                                        select="$file_info_data/file_info/custom__fields/_[contains(name, 'DMP')]/concat('DMP:', replace(value, ' ', ''))"
                                    />
                                </dcterms:relation>
                            </xsl:when>
                            <xsl:otherwise/>
                        </xsl:choose>
                    </dc:record>
                </mets:xmlData>
            </mets:mdWrap>
        </mets:dmdSec>
    </xsl:template>

    <xsl:template name="createFileSec">

        <mets:fileSec>
            <xsl:variable name="linkOnly">
                <xsl:value-of select="($file_info_data/file_info/files/_/is__link__only)"/>
            </xsl:variable>
            <xsl:variable name="fileXternalID">
                <xsl:value-of
                    select="concat('fileXternal-article-', substring-after(//OAI-PMH:record/OAI-PMH:header/OAI-PMH:identifier, '/'))"
                />
            </xsl:variable>
            <mets:fileGrp
                ID="{if ($linkOnly = 'true') then ('linkOnly') else (if(//mets:fileGrp/@ID) then (//mets:fileGrp/@ID) else $fileXternalID)}">
                <xsl:choose>
                    <xsl:when test="string-length($file_info_data/file_info/files/_[1]) &gt; 1">
                        <xsl:for-each select="$file_info_data/file_info/files/_">
                            <mets:file>
                                <!-- <xsl:attribute name="ID" select="if (is__link__only = 'true') 
                         then ('file-0') else
                                    concat('file-', id)"/>. 
                                Possibly also make further replacements:
                                replace(name, 'å', 'a'), replace(name, 'ä', 'a'), replace(name, 'ö', 'o')-->
                                <xsl:variable name="replaceSpace" select="replace(name, ' ', '_')"/>
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
                                <xsl:attribute name="ID" select="concat('file-', id)"/>
                                <xsl:attribute name="CREATED" select="ancestor::file_info/@pubDate"/>
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
                                            if (is__link__only = 'false' and supplied__md5 = computed__md5) then
                                                (supplied__md5)
                                            else
                                                concat('recomputed_md5:', _/computed__5)"/>

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
                                            for $i in (tokenize(name, '\.')[last()])
                                            return
                                                (if ($filext2mimetypeMap//entry[@filext = $i]/@mimetype) then
                                                    $filext2mimetypeMap//entry[@filext = $i]/@mimetype
                                                else
                                                    'application/unknown')"/>
                                <!-- alternative older solution, does not work for filenames with inherent '.':s: <xsl:attribute name="MIMETYPE" select="for $i in (substring-after(name,'.')) return $filext2mimetypeMap//entry[@filext = $i]/@mimetype"/> -->
                                <mets:FLocat xmlns:xlink="http://www.w3.org/1999/xlink"
                                    LOCTYPE="URL" xlink:href="{download__url}"/>

                            </mets:file>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:when test="string-length($file_info_data/file_info/files) = 0">
                        <mets:file>
                            <xsl:attribute name="ID" select="'file-0'"/>
                            <xsl:attribute name="CREATED"
                                select="$file_info_data/file_info/@pubDate"/>
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
                            <mets:FLocat xmlns:xlink="http://www.w3.org/1999/xlink" LOCTYPE="URL"
                                xlink:href="{$file_info_data/file_info/references/_[1]}"/>

                        </mets:file>
                    </xsl:when>
                </xsl:choose>





            </mets:fileGrp>
        </mets:fileSec>
    </xsl:template>

    <xsl:template name="createStructMap">
        <mets:structMap TYPE="physical">
            <mets:div LABEL="files">

                <xsl:for-each select="$file_info_data/file_info/files/_">
                    <mets:div
                        LABEL="{substring-before(for $i in (tokenize(name,'\.')[last()]) return $filext2mimetypeMap//entry[@filext = $i]/@mimetype,'/')}">


                        <mets:fptr FILEID="{concat('file-',id)}"/>
                        <!-- FILEID="{if (is__link__only = 'true') then ('file-0') else concat('file-',id)}"/> -->
                    </mets:div>
                </xsl:for-each>
            </mets:div>
        </mets:structMap>

    </xsl:template>

    <xsl:template match="dc:identifier">
        <mets:mets>
            <xsl:copy-of select="@*"/>
            <xsl:value-of select="."/>
        </mets:mets>
    </xsl:template>

</xsl:stylesheet>
