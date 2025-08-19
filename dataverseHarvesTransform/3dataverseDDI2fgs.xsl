<?xml version="1.0" encoding="UTF-8"?>
<!--20250811/13: *Current v0.3 - Two new conditional variables, $metsFileName and metsFileSize,
    introduced to handle cases where Dataverse converts files to other fileformats (e.g. .csv to -> .tab), 
    but the METS should have originalFileName with fileextension and originalFileSize.
        Further replaced $file_info_data//files/dataFile with 
        <xsl:for-each select="if ($file_info_data//files/array/dataFile) then
         $file_info_data//files/array/dataFile else $file_info_data//files/dataFile">
         to accomodate single cases of array elements.
       (20250813): Fixed
       LABEL="{local:removeHtmlTags(//ddi:docDscr/ddi:citation/ddi:titlStmt/ddi:titl)}" and 
       value for prefSUauthor in METS agent @ROLE=EDITOR with addition of possible authorAffiliation
       values:   <name> <xsl:value-of select="$file_info_data/(//authorAffiliation[contains(value,'Stockholms
                        universitet') or contains(value,'Stockholm University')]/preceding::authorName/value)[1]"/>
                </name>
        NB! In this xslt-file, please always avoid linebreaks in the middle of values within ' '; DO
        NOT here use automatic Format and Indent (Ctrl+Shift+P)! 
    20250801: v0.2 Fixed dmdSec, fileSec and structMap to validate ok finally! NB!
    Institution/Department and InstNr are presently "hardcoded" as 'Stockholms Resilienscentrum' and
    '481' since most users of SU Dataverse come from that department, but should be checked via
    ORCiD in //mets:agent[@ROLE="EDITOR"]/note
    20250723-24: v0.1 This is the first attempt at a DataverseDDI2fgs transform, built on an adapted version
    of 5figMETS2fgs.xsl v1.4:
    - - - - 
    20250618: v1.4 Reinstated IsReferencedBy for selected curated items, where relation @IsSupplemenTo
    is known to hold, as  dcterms:IsReferencedBy is not to contain literals.                             
    20250225: v1.3 Removed "dcterms:isReferencedBy" as proposed change to *dcterms:references* proved only to produce duplicate field values.                
    20241009: v1.2 Adjusted structMap again with new level <mets:div LABEL="data"> in accordance with extractFigsFileInfo.xq v1.2 and dryad7DataCite2FGS.xsl v0.32
    20240704: v1.1 Adjusted structMap template for "linkOnly" - metadata only records.
    20240219: v1.0 As for figDataCite2FGS.xsl addition of parameter doc filext2mimetypeMapMAIN.xml (via dir-mvOrigMDfigDataCite.sh) allows for removal of inherent variable "filext2mimetypeMap". 
               Adjustments of mets/@OBJID, mets/@TYPE, mets/@PROFILE, mets/@csip:CONTENTINFORMATIONTYPE="MIXED", note/@csip:NOTETYPE="IDENTIFICATIONCODE" ... in accordance with https://www.riksarkivet.se/Media/pdf-filer/doi-t/Riksarkivets_tillampning_av_E-ARK_CSIP_och_SIP_V1.0.pdf
    20230210-0823: v0.9999 Added file_info/@resourceDOI as first choice for dcterms:isReferencedBy.
    20230823: Added file_info/@isSupplementTo as first choice for dcterms:isReferencedBy and made file_info/@resourceDOI second choice.
    20220315-1115: v0.9998 Created structMap for multiple manualFiles added to file_info parameter, and fileIDs from manualMD5. Still lacking automated solution for downloadURLs in  metsFLocat/@xlink:href, now from dcterms:references, 
               not synched with actual file. Added mimetypes for .omv from DROID, .kml and .kmz from datatypes.net.
               ... 
               for research data / research material./ joakim.philipson@su.se -->

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:mets="http://www.loc.gov/METS/"
    xmlns:ddi="ddi:codebook:2_5"
    xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:dcterms="http://purl.org/dc/terms/" xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:OAI-PMH="http://www.openarchives.org/OAI/2.0/"
    xmlns:csip="https://DILCIS.eu/XML/METS/CSIPExtensionMETS"
    xmlns:sip="https://DILCIS.eu/XML/METS/SIPExtensionMETS"
    xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:local="local-functions"
    exclude-result-prefixes="xsl xs">
    <xsl:output indent="yes"/>

    <xsl:param name="file_info_data" as="document-node()"/>
    <xsl:param name="filext2mimetypeMap" as="document-node()"/>
    

    <xsl:function name="local:removeHtmlTags" as="xs:string">
        <xsl:param name="element"/>
        <xsl:value-of
            select="normalize-space(replace($element, '&lt;[^\s][^&lt;]*>|&amp;nbsp;|&#xA;|&#34;',' '))"/>
    </xsl:function>

    <xsl:template match="/">

        <mets xmlns="http://www.loc.gov/METS/" 
            xmlns:csip="https://DILCIS.eu/XML/METS/CSIPExtensionMETS"
            xmlns:sip="https://DILCIS.eu/XML/METS/SIPExtensionMETS"
            xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://www.loc.gov/METS/ schemas/mets.xsd csip schemas/DILCISExtensionMETS.xsd sip schemas/DILCISExtensionSIPMETS.xsd"
            OBJID="{concat('IP-',substring-after((//ddi:IDNo)[1],'doi:'))}"
            LABEL="{local:removeHtmlTags(//ddi:docDscr/ddi:citation/ddi:titlStmt/ddi:titl)}"
            TYPE="{'Unstructured'}"
            PROFILE="https://earksip.dilcis.eu/profile/E-ARKSIP.xml" csip:CONTENTINFORMATIONTYPE="MIXED">
            
            <xsl:call-template name="createMetsHeader"/>
                
            <xsl:call-template name="createDmdSec"/>

            <xsl:call-template name="createFileSec"/>

            <xsl:call-template name="createStructMap"/>

        </mets>
    </xsl:template>


    <!-- <metsHdr CREATEDATE="{current-dateTime()}"
            RECORDSTATUS="{($sipMetsHeader/@RECORDSTATUS,'NEW')[1]}" ext:OAISSTATUS="SIP">  -->   
    <xsl:template name="createMetsHeader">
    
        <metsHdr xmlns="http://www.loc.gov/METS/" CREATEDATE="{current-dateTime()}" RECORDSTATUS="NEW" csip:OAISPACKAGETYPE="SIP"> 

            <agent ROLE="ARCHIVIST" TYPE="ORGANIZATION">
                <name>Stockholms universitet, Stockholms Resilienscentrum</name>
                <note>ORG:2021003062</note>
                <note>InstNr: 481</note>
             <!--   <xsl:choose>
                    <xsl:when test="string-length($file_info_data/file_info/@archivalInst) &gt; 0">                 
                        <note>
                            <xsl:value-of select="concat('InstNr:', $file_info_data/file_info/substring-before(@archivalInst, ' '))"/>
                        </note>
                   </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose> -->
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
                <name>SUB_DDI_harvestTransformer_for_Dataverse</name>
                <note>
                    <xsl:value-of select="concat('4dataverseDDI2fgs',' v0.3')"/>
                </note>
            </agent>

            <!-- 2025-08-01: No funder or grant info detected either in DDI _originalMD.xml or
                nativeMDfile_info.xml 

            <xsl:for-each select="$file_info_data">
                <agent ROLE="OTHER" TYPE="ORGANIZATION">
                    <xsl:choose>
                        <xsl:when test="
                                exists(for $n in (./funder__name)
                                return $n[string-length($n) &gt; 0])">
                            <name>
                                <xsl:value-of select="concat('Funder_name:', ./funder__name/text())"
                                />
                            </name>
                        </xsl:when>

                        <xsl:when test="exists(for $t in (./title) return $t[string-length($t) &gt; 0])">

                            <name>
                                <xsl:value-of select="concat('Funder_title:', ./title/text())"/>
                            </name>
                        </xsl:when>
                        <xsl:otherwise/>
                    </xsl:choose>

                    <xsl:choose>
                        <xsl:when test="exists(for $n in (./funder__name) return
                                    $n[string-length($n) &gt; 0])">
                            <note>
                                <xsl:value-of select="concat('Funder_title:', ./title/text())"/>
                            </note>
                        </xsl:when>
                        <xsl:otherwise/>
                    </xsl:choose>

                    <xsl:choose>
                        <xsl:when test="exists(for $u in (./url) return $u[string-length($u) &gt; 0])">
                            <note>
                                <xsl:value-of select="concat('Grant_url: ', ./url/text())"/>
                            </note>
                        </xsl:when>

                        <xsl:otherwise/>
                    </xsl:choose>
                    <xsl:choose>
                        <xsl:when test="exists(for $g in (./grant__code) return $g[string-length($g) &gt; 0])">
                            <note>
                                <xsl:value-of select="concat('Grant_code:', ./grant__code/text())"/>
                            </note>
                        </xsl:when>
                        <xsl:otherwise/>
                    </xsl:choose>

                    <xsl:choose>
                        <xsl:when test="exists(for $i in (./id) return $i[string-length($i) &gt; 0])">
                            <note>
                                <xsl:value-of select="concat('Funder_id:', replace(./id/text(), ' ', ''))"/>
                            </note>
                        </xsl:when>
                        <xsl:otherwise/>
                    </xsl:choose>
                </agent>
            </xsl:for-each> -->


            <agent ROLE="EDITOR" TYPE="INDIVIDUAL">
                <name>
                    <xsl:value-of select="$file_info_data/(//authorAffiliation[contains(value,'Stockholms
universitet') or contains(value,'Stockholm University')]/preceding::authorName/value)[1]"/>
                </name>
                <note>
                    <!-- Revision 2025-08-01: -->
                    <xsl:choose>
                      <!--  <xsl:when test="$file_info_data/file_info[@ALERT = 'ID-check!']">
                            <xsl:value-of select="'ID-check!'"/>
                        </xsl:when> -->
                        <xsl:when
                            test="string-length($file_info_data/(//authorAffiliation[contains(value,'Stockholms
universitet') or contains(value,'Stockholm University')]/preceding::authorName/value/following::authorIdentifier/value)[1]) &gt; 4">
                            <xsl:value-of select="concat('ORCID:',
                                $file_info_data/(//authorAffiliation[contains(value,'Stockholms universitet')
                                or contains(value,'Stockholm University')]/preceding::authorName/value/following::authorIdentifier/value)[1])"/>
                        </xsl:when>
                        <!-- @sukatID -->
                        <xsl:otherwise>
                            <xsl:value-of select="'No prefSUauthorID found!'"/>
                        </xsl:otherwise>
                    </xsl:choose>
                    <!-- End revision. -->
                </note>
            </agent>
            <altRecordID TYPE="SUBMISSIONAGREEMENT">https://https://dataverse.harvard.edu/dataverse/StockholmUniversityLibrary</altRecordID>
            <metsDocumentID>METS.xml</metsDocumentID>
        </metsHdr>
    </xsl:template>


    <xsl:template name="createDmdSec">

        <mets:dmdSec ID="{concat('dmd-',$file_info_data/JSON/id)}">
            <mets:mdWrap MDTYPE="DDI">
                <mets:xmlData>
                     <xsl:copy-of select="ddi:codeBook"/>
                    <!-- <dc:record
                        xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/oai_dc/ http://www.openarchives.org/OAI/2.0/oai_dc.xsd">
                        <xsl:copy-of select="//dc:title" copy-namespaces="no"/>
                        <xsl:copy-of select="//dc:creator" copy-namespaces="no"/>
                        <xsl:copy-of select="//dc:contributor" copy-namespaces="no"/>
                        <xsl:copy-of select="//dc:identifier" copy-namespaces="no"/>
                         2020-04-01 v0.9991: dc:date added.
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
                         2024-10-30 Proved to not hold for item 27117831.v1, thus removed
                             until further notice. 
                             2025-06-18 Reinstated for selected curated items, where relation is
                             known to hold:   
                             <xsl:when
                                test="$file_info_data/file_info/@relationType='IsSupplementTo'">
                                <dcterms:isReferencedBy>
                                    <xsl:value-of
                                        select="$file_info_data/file_info/@resourceDOI"
                                    />
                                </dcterms:isReferencedBy>
                            </xsl:when>  
                         20250225: Removed "dcterms:isReferencedBy" below as proposed change to
                         *dcterms:references* proved to just duplicate field values from above <xsl:for-each select="$file_info_data/file_info/references/_">
                          
                            <xsl:when
                                test="string-length($file_info_data/file_info/@resourceDOI) &gt; 0">
                                <dcterms:references>
                                    <xsl:value-of
                                        select="$file_info_data/file_info/@resourceDOI"
                                    />
                                </dcterms:references>
                            </xsl:when>
                            
                            2025-06-18 Removing this again, as dcterms:isReferencedBy should not contain
                                literals:
                              <xsl:when
                                test="string-length($file_info_data/file_info/custom__fields/_[name = 'Associated Publication']/value) &gt; 0">
                                <dcterms:isReferencedBy>
                                    <xsl:value-of
                                        select="local:removeHtmlTags($file_info_data/file_info/custom__fields/_[name = 'Associated Publication']/value)"
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
                    </dc:record> -->
                </mets:xmlData>
            </mets:mdWrap>
        </mets:dmdSec>
    </xsl:template>

    <xsl:template name="createFileSec">

        <mets:fileSec>
          <!--  
            <xsl:variable name="linkOnly">
                <xsl:value-of select="($file_info_data/file_info/files/_/is__link__only)"/>
            </xsl:variable>
            <xsl:variable name="fileXternalID">
                <xsl:value-of select="concat('fileXternal-article-', substring-after(//OAI-PMH:record/OAI-PMH:header/OAI-PMH:identifier, '/'))"/>
            </xsl:variable>
           
            <xsl:variable name="manualFileID">
                <xsl:value-of
                select="for $i in ($file_info_data/files/_/id) return concat('file-',$i)"/></xsl:variable> 
            <mets:fileGrp
                ID="{if ($linkOnly = 'true') then ('linkOnly') else (if(//fileGrp/@ID) then (//fileGrp/@ID) else $fileXternalID)}">
            -->    
            <mets:fileGrp
                    ID="{concat('datasetVersion-',$file_info_data/JSON/datasetVersion/id)}">
                    
                <xsl:choose>
                    <xsl:when
                        test="string-length($file_info_data//JSON/datasetVersion/files[1]/dataFile/filename)
                        &gt; 3
                        or
                        string-length($file_info_data//JSON/datasetVersion/files[1]/array/dataFile/filename)
                        &gt; 3">
                        <xsl:for-each select="if ($file_info_data//files/array/dataFile) then
                            $file_info_data//files/array/dataFile else $file_info_data//files/dataFile">
                            <mets:file>
                                <xsl:variable name="metsFileName" select="for $f in . return if
                                    (exists($f/originalFileName)) then originalFileName else
                                    $f/filename"/>
                                <xsl:variable name="replaceSpace" select="replace($metsFileName, ' ', '_')"/>
                                <xsl:variable name="replace-å" select="
                                        for $i in $replaceSpace
                                        return
                                            replace($i, 'å', 'a')"/>
                                <xsl:variable name="replace-ä" select="
                                        for $j in $replace-å
                                        return
                                            replace($j, 'ä', 'a')"/>
                                <xsl:variable name="replace-ö" select="
                                        for $k in $replace-ä
                                        return
                                            replace($k, 'ö', 'o')"/>
                                <xsl:variable name="metsFileSize" select="for $s in . return if
                                    (exists($s/originalFileSize)) then originalFileSize else
                                    $s/filesize"/>
                                <xsl:attribute name="ID" select="concat('file-', id)"/>
                                <xsl:attribute name="CREATED" select="concat(creationDate,'T01:01:01')"/>
                                <xsl:attribute name="OWNERID" select="$replace-ö"/>
                                <xsl:attribute name="SIZE" select="$metsFileSize"/>
                                <xsl:attribute name="CHECKSUMTYPE" select="'MD5'"/>


                                <xsl:attribute name="CHECKSUM" select="md5"/>
                                <xsl:attribute name="MIMETYPE" select="for $i in
                                    (tokenize($metsFileName, '\.')[last()])
                                    return
                                    (if ($filext2mimetypeMap//entry[@filext = $i]/@mimetype) then
                                    $filext2mimetypeMap//entry[@filext = $i]/@mimetype
                                    else
                                    'application/unknown')"/>
                            <!--    <xsl:attribute name="MIMETYPE" select="
                                        if (is__link__only = 'true') then
                                            for $f in (tokenize(ancestor::file_info/manualFiles/manualFileName, '\.')[last()])
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
                                                    'application/unknown')"/>  -->
                                <!-- alternative older solution, does not work for filenames with inherent '.':s: <xsl:attribute name="MIMETYPE" select="for $i in (substring-after(name,'.')) return $filext2mimetypeMap//entry[@filext = $i]/@mimetype"/> -->
                                <mets:FLocat xmlns:xlink="http://www.w3.org/1999/xlink"
                                    LOCTYPE="URL"
                                    xlink:href="{concat('https://dataverse.harvard.edu/api/access/datafile/',
                                    id)}"/>

                            </mets:file>
                        </xsl:for-each>
                    </xsl:when>
                <!--   <xsl:when
                        test="$linkOnly = 'true'">
                        <xsl:for-each select="$file_info_data/file_info/manualFiles">
                        <mets:file>
                            <xsl:attribute name="ID" select="$manualFileID"/>
                            <xsl:attribute name="CREATED"
                                select="$file_info_data/file_info/@pubDate"/>
                            <xsl:attribute name="OWNERID" select="manualFileName"/>
                            <xsl:attribute name="SIZE"
                                select="manualFileSize"/>
                            <xsl:attribute name="CHECKSUMTYPE" select="'MD5'"/>
                            <xsl:attribute name="CHECKSUM"
                                select="manualMD5"/>
                             <xsl:attribute name="MIMETYPE" select="
                                    for $f in (tokenize(manualFileName, '\.')[last()])
                                    return
                                        (if ($filext2mimetypeMap//entry[@filext = $f]/@mimetype) then
                                            $filext2mimetypeMap//entry[@filext = $f]/@mimetype
                                        else
                                            'application/unknown')"/>
                            <mets:FLocat xmlns:xlink="http://www.w3.org/1999/xlink" LOCTYPE="URL"
                                xlink:href="{$file_info_data/file_info/references/_}"/>
                        </mets:file>
                       </xsl:for-each>
                    </xsl:when>  -->
                </xsl:choose>
            </mets:fileGrp>
        </mets:fileSec>
    </xsl:template>

    <xsl:template name="createStructMap">
        <xsl:variable name="linkOnly">
            <xsl:value-of select="($file_info_data//files/is__link__only)"/>            
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$linkOnly = 'true'">
                <mets:structMap TYPE="logical">
                    <mets:div LABEL="linkOnly">
                        <xsl:for-each select="if ($file_info_data//files/array/dataFile) then
                            $file_info_data//files/array/dataFile else $file_info_data//files/dataFile">
                            <xsl:variable name="metsFileName" select="for $f in . return if
                                (exists($f/originalFileName)) then originalFileName else
                                $f/filename"/>
                            <mets:div
                                LABEL="{substring-before(for $i in (tokenize($metsFileName,'\.')[last()]) return $filext2mimetypeMap//entry[@filext = $i]/@mimetype,'/')}">
                               
                                <mets:fptr FILEID="{concat('file-',id)}"/>
                            </mets:div>
                        </xsl:for-each>
                    </mets:div>
                 </mets:structMap>
            </xsl:when>  
            
            <xsl:otherwise>
             <mets:structMap TYPE="physical">
             <mets:div LABEL="data">   
               <mets:div LABEL="files">  
                   <xsl:for-each select="if ($file_info_data//files/array/dataFile) then
                       $file_info_data//files/array/dataFile else $file_info_data//files/dataFile">
                        <xsl:variable name="metsFileName" select="for $f in . return if
                            (exists($f/originalFileName)) then originalFileName else
                            $f/filename"/>
                    <mets:div
                        LABEL="{substring-before(for $i in (tokenize($metsFileName,'\.')[last()]) return $filext2mimetypeMap//entry[@filext = $i]/@mimetype,'/')}">
                        <mets:fptr FILEID="{concat('file-',id)}"/>
                    </mets:div>
                </xsl:for-each>
                </mets:div>
              </mets:div>  
             </mets:structMap>   
            </xsl:otherwise>
        </xsl:choose> 
    </xsl:template>

    <xsl:template match="ddi:codebook">
        <mets>
            <xsl:copy-of select="@*"/>
            <xsl:value-of select="."/>
        </mets>
    </xsl:template>

</xsl:stylesheet>