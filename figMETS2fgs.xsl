<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:mets="http://www.loc.gov/METS/"
                xmlns:ext="ExtensionMETS"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:dcterms="http://purl.org/dc/terms/"
                xmlns:xlink="http://www.w3.org/1999/xlink"<?xml version="1.0" encoding="UTF-8"?>
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
            <entry filext="bib" mimetype="text/plain" source="JHOVE 1.18.1"/>
            <entry filext="cpg" mimetype="text/plain" source="JHOVE 1.18.1"/>
            <entry filext="css" mimetype="text/css" source="https://datatypes.net/ 20180712"/>
            <entry filext="csv" mimetype="text/csv" source="https://datatypes.net/ 20180712"/>
            <entry filext="dat" mimetype="application/octet-stream"
                source="https://datatypes.net/ 20180712"/>
            <entry filext="dbf" mimetype="application/octet-stream" source="JHOVE 1.18.1"/>
            <entry filext="doc" mimetype="application/msword"
                source="https://datatypes.net/ 20180712"/>
            <entry filext="docx" mimetype="application/vnd.openxmlformats"
                source="https://datatypes.net/ 20180712"/>
            <entry filext="gif" mimetype="image/gif" source="https://datatypes.net/ 20180712"/>
            <entry filext="htm" mimetype="text/html" source="https://datatypes.net/ 20180712"/>
            <entry filext="html" mimetype="text/html" source="https://datatypes.net/ 20180712"/>
            <entry filext="jar" mimetype="application/java-archive"
                source="https://datatypes.net/ 20180712"/>
            <entry filext="jasp" mimetype="application/octet-stream" source="JHOVE 1.18.1"/>
            <entry filext="jpeg" mimetype="image/jpeg" source="https://datatypes.net/ 20180712"/>
            <entry filext="jpg" mimetype="image/jpeg" source="https://datatypes.net/ 20180712"/>
            <entry filext="js" mimetype="text/javascript" source="https://datatypes.net/ 20180712"/>
            <entry filext="json" mimetype="text/plain" source="JHOVE 1.18.1"/>
            <entry filext="m" mimetype="application/matlab-m"
                source="https://datatypes.net/ 20180712"/>
            <entry filext="mat" mimetype="application/matlab-mat"
                source="https://datatypes.net/ 20190118"/>
            <!-- Please note that same file extension is also used for Microsoft Access Table, with mime-type: application/vnd.ms-access! -->
            <entry filext="m4v" mimetype="video/x-m4v" source="https://datatypes.net/ 20180712"/>
            <entry filext="mp3" mimetype="audio/mpeg" source="https://datatypes.net/ 20180712"/>
            <entry filext="mp4" mimetype="video/mp4" source="https://datatypes.net/ 20180712"/>
            <entry filext="mpeg" mimetype="video/mpeg" source="https://datatypes.net/ 20180712"/>
            <entry filext="mpg" mimetype="video/mpeg" source="https://datatypes.net/ 20180712"/>
            <entry filext="nc" mimetype="application/octet-stream" source="JHOVE 1.18.1"/>
            <entry filext="ncml" mimetype="text/xml" source="JHOVE 1.18.1"/>
            <entry filext="nex" mimetype="text/plain"/>
            <entry filext="nexml" mimetype="text/xml" source="JHOVE 1.18.1"/>
            <entry filext="nhx" mimetype="text/plain"/>
            <entry filext="odp" mimetype="application/vnd.oasis.opendocument.presentation"
                source="https://datatypes.net/ - 20180712"/>
            <entry filext="ods" mimetype="application/vnd.oasis.opendocument.spreadsheet"
                source="https://datatypes.net/ - 20180712"/>
            <entry filext="odt" mimetype="application/vnd.oasis.opendocument.text"
                source="https://datatypes.net/ - 20180712"/>
            <entry filext="pdf" mimetype="application/pdf" source="JHOVE 1.18.1"/>
            <entry filext="ph" mimetype="application/octet-stream"
                source="https://datatypes.net/ - 20180712"/>
            <entry filext="phy" mimetype="application/octet-stream"
                source="https://datatypes.net/ - 20180712"/>
            <entry filext="PhyloXML" mimetype="application/xml"/>
            <entry filext="png" mimetype="image/png" source="JHOVE 1.18.1"/>
            <entry filext="ppt" mimetype="application/vnd.ms-powerpoint"/>
            <entry filext="pptx" mimetype="application/vnd.ms-powerpoint"/>
            <entry filext="prj" mimetype="text/plain" source="JHOVE 1.18.1"/>
            <entry filext="py" mimetype="text/x-python" source="https://datatypes.net/"
                source2="BaseXQ:fetch:content-type()" date="20180207"/>
            <entry filext="R" mimetype="text/x-rsrc"/>
            <entry filext="RData" mimetype="text/x-rsrc"/>
            <entry filext="Rmd" mimetype="text/x-gfm"
                source="https://www.digipres.org/formats/sources/githublinguist/formats/#313"
                update="2019-03-19"/>
            <entry filext="sbn" mimetype="application/octet-stream" source="JHOVE 1.18.1"/>
            <entry filext="sbx" mimetype="application/octet-stream" source="JHOVE 1.18.1"/>
            <entry filext="shp" mimetype="application/octet-stream" source="JHOVE 1.18.1"/>
            <entry filext="shx" mimetype="application/octet-stream" source="JHOVE 1.18.1"/>
            <entry filext="srt" mimetype="text/plain" source="https://datatypes.net/ 20180712"/>
            <entry filext="svg" mimetype="image/svg+xml" source="https://datatypes.net/ 20180816"/>
            <entry filext="tif" mimetype="image/tiff" source="https://datatypes.net/ 20180816"/>
            <entry filext="tiff" mimetype="image/tiff" source="https://datatypes.net/ 20180816"/>
            <entry filext="tree" mimetype="application/octet-stream"
                source="https://datatypes.net/ 20180712"/>
            <entry filext="txt" mimetype="text/plain" source="https://datatypes.net/ 20180816"/>
            <entry filext="war" mimetype="application/java-archive"
                source="https://datatypes.net/ 20180719"/>
            <entry filext="wav" mimetype="audio/x-wav" source="https://datatypes.net/ 20180816"/>
            <entry filext="xls" mimetype="application/vnd.ms-excel"
                source="https://datatypes.net/ 20180816"/>
            <entry filext="xlsx" mimetype="application/vnd.openxmlformats "
                source="https://datatypes.net/ 20180816"/>
            <entry filext="xml" mimetype="text/xml" source="JHOVE 1.18.1"/>
            <entry filext="xsd" mimetype="text/xml" source="JHOVE 1.18.1"/>
            <entry filext="xsl" mimetype="text/xml" source="JHOVE 1.18.1"/>
            <entry filext="xq" mimetype="text/plain" source="JHOVE 1.18.1"/>
            <entry filext="xquery" mimetype="text/plain" source="JHOVE 1.18.1"/>
            <entry filext="zip" mimetype="application/x-zip-compressed"
                source="https://datatypes.net/ 20180724"/>
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

            <!--  <mets:agent ROLE="ARCHIVIST" TYPE="ORGANIZATION">
                <mets:name>Stockholms universitet</mets:name>
                <mets:note>ORG:2021003062</mets:note>
            </mets:agent>  2018-09-05 changed to: -->

            <mets:agent ROLE="ARCHIVIST" TYPE="ORGANIZATION">
                <mets:name>
                    <xsl:value-of
                        select="concat('Stockholms universitet, ', $file_info_data/file_info/@sukatInst1)"
                    />
                </mets:name>
                <mets:note>ORG:2021003062</mets:note>
            </mets:agent>

            <mets:agent ROLE="CREATOR" TYPE="ORGANIZATION">
                <mets:name>Stockholms universitet</mets:name>
                <mets:note>ORG:2021003062</mets:note>
            </mets:agent>
            <mets:agent ROLE="OTHER" OTHERROLE="PRODUCER" TYPE="ORGANIZATION">
                <mets:name>Stockholms universitetsbibiliotek</mets:name>
                <mets:note>ORG:2021003062</mets:note>
            </mets:agent>

            <!-- 2018-09-05: added mets:note with main transform (XSLT) file and version no.: -->
            <mets:agent ROLE="ARCHIVIST" TYPE="OTHER" OTHERTYPE="SOFTWARE">
                <mets:name>SUB_oai-pmh-harvestor_from_su.figshare.com</mets:name>
                <mets:note>file:///figMETS2fgs.xsl v0.6</mets:note>
            </mets:agent>
            <!-- 2018-09-12 added mets:agent with mets:note ORCID / sukatID of first author:  -->
            <xsl:variable name="firstAuthorID">
                <xsl:value-of
                    select="
                        if ($file_info_data/file_info/@ALERT = 'ID-check!') then
                            ()
                        else
                            if (exists($file_info_data/file_info/@firstAuthORCiD)) then
                                ($file_info_data/file_info/@firstAuthORCiD)
                            else
                                ($file_info_data/file_info/@sukatID)"
                />
            </xsl:variable>
            <mets:agent ROLE="EDITOR" TYPE="INDIVIDUAL">
                <mets:name>
                    <xsl:value-of select="$file_info_data/file_info/@firstAuthorNameInv"/>
                </mets:name>
                <mets:note>
                    <xsl:value-of select="$firstAuthorID"/>
                </mets:note>
            </mets:agent>
            <xsl:copy-of select="//mets:agent[2]" copy-namespaces="no"/>
            <xsl:copy-of
                select="$sipMetsHeader/mets:altRecordID[@TYPE = ('DELIVERYTYPE', 'DELIVERYSPECIFICATION')]"
                copy-namespaces="no"/>
            <xsl:variable name="incomingSubmissionAgreement"
                select="$sipMetsHeader/mets:altRecordID[@TYPE = 'SUBMISSIONAGREEMENT']"/>
            <mets:altRecordID TYPE="SUBMISSIONAGREEMENT">https://su.figshare.com</mets:altRecordID>
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
                        <xsl:copy-of select="//dc:subject" copy-namespaces="no"/>
                        <xsl:copy-of select="//dc:type" copy-namespaces="no"/>
                        <xsl:copy-of select="//dc:relation" copy-namespaces="no"/>
                        <xsl:copy-of select="//dc:rights" copy-namespaces="no"/>
                        <dc:description>
                            <xsl:value-of select="local:removeHtmlTags(//dc:description)"/>
                        </dc:description>
                        <xsl:copy-of select="//dcterms:hasVersion" copy-namespaces="no"/>
                        <xsl:copy-of select="//dcterms:hasPart" copy-namespaces="no"/>
                    </dc:record>
                </mets:xmlData>
            </mets:mdWrap>
        </mets:dmdSec>
    </xsl:template>

    <xsl:template name="createFileSec">

        <mets:fileSec>
            <xsl:variable name="linkOnly">
                <xsl:value-of select="$file_info_data/file_info/files/_/is__link__only"/>
            </xsl:variable>
            <xsl:variable name="filembargID">
                <xsl:value-of
                    select="concat('filembargo-article-', substring-after(//OAI-PMH:record/OAI-PMH:header/OAI-PMH:identifier, '/'))"
                />
            </xsl:variable>
            <mets:fileGrp
                ID="{if ($linkOnly = 'true') then ('linkOnly') else (if(//mets:fileGrp/@ID) then //mets:fileGrp/@ID else $filembargID) }">

                <xsl:for-each select="$file_info_data/file_info/files/_">
                    <mets:file>
                        <xsl:attribute name="ID"
                            select="
                                if (isLinkOnly = 'true') then
                                    ('file-0')
                                else
                                    concat('file-', id)"/>
                        <xsl:attribute name="CREATED" select="ancestor::file_info/@pubDate"/>
                        <xsl:attribute name="OWNERID" select="name"/>
                        <xsl:attribute name="SIZE" select="size"/>
                        <xsl:if test="isLinkOnly = 'false'">
                            <xsl:attribute name="CHECKSUMTYPE" select="'MD5'"/>
                            <xsl:attribute name="CHECKSUM"
                                select="
                                    if (supplied__md5 = computed__md5) then
                                        (supplied__md5)
                                    else
                                        concat('recomputed_md5', computed__5)"
                            />
                        </xsl:if>
                        <xsl:attribute name="MIMETYPE"
                            select="
                                for $i in (tokenize(name, '\.')[last()])
                                return
                                    (if ($filext2mimetypeMap//entry[@filext = $i]/@mimetype) then
                                        $filext2mimetypeMap//entry[@filext = $i]/@mimetype
                                    else
                                        'application/unknown')"/>
                        <!-- alternative older solution, does not work for filenames with inherent '.':s: <xsl:attribute name="MIMETYPE" select="for $i in (substring-after(name,'.')) return $filext2mimetypeMap//entry[@filext = $i]/@mimetype"/> -->
                        <mets:FLocat xmlns:xlink="http://www.w3.org/1999/xlink" LOCTYPE="URL"
                            xlink:href="{download__url}"/>

                    </mets:file>
                </xsl:for-each>
            </mets:fileGrp>
        </mets:fileSec>
    </xsl:template>

    <xsl:template name="createStructMap">
        <mets:structMap TYPE="physical">
            <mets:div LABEL="files">

                <xsl:for-each select="$file_info_data/file_info/files/_">
                    <mets:div
                        LABEL="{substring-before(for $i in (tokenize(name,'\.')[last()]) return $filext2mimetypeMap//entry[@filext = $i]/@mimetype,'/')}">


                        <mets:fptr
                            FILEID="{if (isLinkOnly = 'true') then ('file-0') else concat('file-',id)}"/>

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

                xmlns:oai="http://www.openarchives.org/OAI/2.0/"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"                
                xmlns:sh="shared.xsl"
                xmlns:local="local-functions"
                exclude-result-prefixes="xsl xs">

    
    <xsl:import href="shared.xsl"/>
    <xsl:output indent="no"/>


    <xsl:param name="file_info_data" as="document-node()"/>
    <xsl:param name="deliveryFeedType" as="xs:string" />
    <xsl:variable name="OAI_FEED_TYPE" select="xs:string('oai')"/>
      
    <xsl:variable name="filext2mimetypeMap">
        <map>
            <entry filext="doc" mimetype="application/msword"/>
            <entry filext="docx" mimetype="application/msword"/>
            <entry filext="pdf" mimetype="application/pdf"/>
            <entry filext="png" mimetype="image/png"/>
            <entry filext="R" mimetype="text/x-rsrc"/>
            <entry filext="RData" mimetype="text/x-rsrc"/>           
            <entry filext="txt" mimetype="text/plain"/>
            <entry filext="xlsx" mimetype="application/vnd.ms-excel"/>
            <entry filext="xml" mimetype="application/xml"/>
        </map>
    </xsl:variable>
    
    <xsl:template match="/">
    
       <mets xmlns="http://www.loc.gov/METS/" xmlns:xlink="http://www.w3.org/1999/xlink"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
            xmlns:ext="ExtensionMETS" 
            xsi:schemaLocation="http://www.loc.gov/METS/ http://xml.ra.se/e-arkiv/METS/CSPackageMETS.xsd ExtensionMETS http://xml.ra.se/e-arkiv/METS/CSPackageExtensionMETS.xsd"
            OBJID="{//dc:identifier}"
            LABEL="{//dc:title}"
            TYPE="Single records"
            PROFILE="http://xml.ra.se/e-arkiv/METS/CommonSpecificationSwedenPackageProfile.xml"
            ext:CONTENTTYPESPECIFICATION="http://www.ra.se/deliveryspecification/fgs-forskningsinfo.pdf">

            <xsl:call-template name="createMetsHeader">
                <xsl:with-param name="sipMetsHeader" select="//mets:mets/mets:metsHdr"/>
                
            </xsl:call-template>
            <xsl:call-template name="createDmdSecPrimary">
            <xsl:with-param name="sipMetsHeader" select="//mets:mets/mets:metsHdr"/>
       
            </xsl:call-template>
 
                       
          <xsl:call-template name="createFileSec"/>
   
                
              
           
            <xsl:call-template name="createStructMap"/>
                
        </mets>
    </xsl:template>

    
    <xsl:template match="//dc:description">
       <xsl:value-of select="local:removeHtmlTags(node())"/>
    </xsl:template>
    
    <xsl:function name="local:removeHtmlTags" as="xs:string">
        <xsl:param name="element"/>
        <xsl:value-of select="normalize-space(replace($element, '&lt;[^\s][^&lt;]*>|&amp;nbsp;',' '))"/>
    </xsl:function>

    <xsl:template name="createMetsHeader">
        <xsl:param name="sipMetsHeader" required="yes" as="element(mets:metsHdr)"/>
        <mets:metsHdr CREATEDATE="{current-dateTime()}" RECORDSTATUS="{($sipMetsHeader/@RECORDSTATUS,'NEW')[1]}" ext:OAISSTATUS="SIP">
            <mets:agent ROLE="ARCHIVIST" TYPE="ORGANIZATION">
                <mets:name>Stockholms universitet</mets:name>
                <mets:note>ORG:202100306</mets:note>
            </mets:agent>
            <mets:agent ROLE="CREATOR" TYPE="ORGANIZATION">
                <mets:name>Stockholms universitetsbibliotek</mets:name>
                <mets:note>ORG:202100306</mets:note>
            </mets:agent>
            <mets:agent ROLE="ARCHIVIST" TYPE="OTHER" OTHERTYPE="SOFTWARE">
                <mets:name>SUB_oai-pmh-harvestor_from_su.figshare.com</mets:name>
            </mets:agent>
            <xsl:copy-of select="//mets:agent"/>  
            <xsl:copy-of select="$sipMetsHeader/mets:altRecordID[@TYPE = ('DELIVERYTYPE','DELIVERYSPECIFICATION')]"/>
            <xsl:variable name="incomingSubmissionAgreement" select="$sipMetsHeader/mets:altRecordID[@TYPE = 'SUBMISSIONAGREEMENT']"/>
            <mets:altRecordID TYPE="SUBMISSIONAGREEMENT">https://su.figshare.com</mets:altRecordID>     
       </mets:metsHdr>
    </xsl:template>


    <xsl:template name="createDmdSecPrimary">
        <xsl:param name="sipDmdSec" select="//mets:dmdSec"/>
        <xsl:param name="sipMetsHeader" as="element(mets:metsHdr)"/>

        
        <xsl:variable name="dcRecord">
            <xsl:apply-templates select="$sipDmdSec/mets:mdWrap/mets:xmlData/dc:record"/>
        </xsl:variable>
        
        <xsl:variable name="orgIdAsNote" select="$sipMetsHeader/mets:agent[@ROLE='ARCHIVIST' and @TYPE='ORGANIZATION']/mets:note"/>
        
 
        <mets:dmdSec ID="{//mets:dmdSec/@ID}">
            <mets:mdWrap LABEL="Primary" MDTYPE="DC">
                <mets:xmlData>
                    
               
                        <xsl:copy-of select="//dc:record"/>
                       
                    
                </mets:xmlData>
            </mets:mdWrap>
        </mets:dmdSec>
    </xsl:template>
    
    <xsl:template name="createFileSec">
         
      <mets:fileSec>
          <xsl:variable name="linkOnly"><xsl:value-of select="$file_info_data/file_info/files/_/isLinkOnly"/></xsl:variable>
          <mets:fileGrp ID="{if ($linkOnly = 'true') then ('linkOnly') else //mets:fileGrp/@ID}">
           
           <xsl:for-each select="$file_info_data/file_info/files/_">     
               <mets:file> 
                <xsl:attribute name="ID" select="if (isLinkOnly = 'true') then ('file-0') else concat('file-',substring-after(downloadUrl,'files/'))"/>
                <xsl:attribute name="CREATED" select="ancestor::file_info/@pubDate"/>
                <xsl:attribute name="OWNERID" select="name"/> 
                <xsl:attribute name="SIZE" select="size"/>
              <xsl:if test="isLinkOnly = 'false'">     
                <xsl:attribute name="CHECKSUMTYPE" select="'MD5'"/>
                <xsl:attribute name="CHECKSUM" select="md5"/>
              </xsl:if>    
                <xsl:attribute name="MIMETYPE" select="for $i in (substring-after(name,'.')) return $filext2mimetypeMap//entry[@filext = $i]/@mimetype"/> 
                <mets:FLocat xmlns:xlink="http://www.w3.org/1999/xlink" LOCTYPE="URL" xlink:href="{downloadUrl}"/>
                  
         </mets:file>
           </xsl:for-each> 
      </mets:fileGrp>          
     </mets:fileSec>
    </xsl:template>

    <xsl:template name="createStructMap">
     <mets:structMap TYPE="physical">
       <mets:div LABEL="files">
           <xsl:variable name="mimeBase" select="for $i in (substring-after(name,'.')) return $filext2mimetypeMap//entry[@filext = $i]/@mimetype"/>    
           
           <xsl:for-each select="$file_info_data/file_info/files/_">      
               <mets:div LABEL="{substring-before(for $i in (substring-after(name,'.')) return $filext2mimetypeMap//entry[@filext = $i]/@mimetype,'/')}">
                  
                       
                   <mets:fptr FILEID="{if (isLinkOnly = 'true') then ('file-0') else concat('file-',substring-after(downloadUrl,'files/'))}"/>
                      
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
