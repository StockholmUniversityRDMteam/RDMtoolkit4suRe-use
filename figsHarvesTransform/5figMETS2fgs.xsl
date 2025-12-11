<?xml version="1.0" encoding="UTF-8"?>
<!--20250618: *Current v1.4 Reinstated IsReferencedBy for selected curated items, where relation @IsSupplemenTo
    tis known to hold, as  dcterms:IsReferencedBy is not to contain literals.                             
    20250225: v1.3 Removed "dcterms:isReferencedBy" as proposed change to *dcterms:references* proved only to produce duplicate field values.                
    20241009: v1.2 Adjusted structMap again with new level <mets:div LABEL="data"> in accordance with extractFigsFileInfo.xq v1.2 and dryad7DataCite2FGS.xsl v0.32
    20240704: v1.1 Adjusted structMap template for "linkOnly" - metadata only records.
    20240219: v1.0 As for figDataCite2FGS.xsl addition of parameter doc filext2mimetypeMapMAIN.xml (via dir-mvOrigMDfigDataCite.sh) allows for removal of inherent variable "filext2mimetypeMap". 
               Adjustments of mets/@OBJID, mets/@TYPE, mets/@PROFILE, mets/@csip:CONTENTINFORMATIONTYPE="MIXED", note/@csip:NOTETYPE="IDENTIFICATIONCODE" ... in accordance with https://www.riksarkivet.se/Media/pdf-filer/doi-t/Riksarkivets_tillampning_av_E-ARK_CSIP_och_SIP_V1.0.pdf
    20230210-0823: v0.9999 Added file_info/@resourceDOI as first choice for dcterms:isReferencedBy.
    20230823: Added file_info/@isSupplementTo as first choice for dcterms:isReferencedBy and made file_info/@resourceDOI second choice.
    20220315-1115: v0.9998 Created structMap for multiple manualFiles added to file_info parameter, and fileIDs from manualMD5. Still lacking automated solution for downloadURLs in  metsFLocat/@xlink:href, now from dcterms:references, 
               not synched with actual file. Added mimetypes for .omv from DROID, .kml and .kmz from datatypes.net.
    20210701-0803: v0.9997 Moved function local:removeHtmlTags before first template, and added '|&#xA;' to strings replaced by ' '.
              Added mimetypes for '.eeg', '.vhdr', '.vmrk'; '.inp'
    20210601: v0.9996 Prel. change of mets/@TYPE from hardcoded "Single records" to conditional 
    {if (//dc:type='Dataset' or //dc:type='Figure' or //dc:type='Software' or //dc:type='Workflow') then 'Unstructured' else 'Publication'} 
    as partial mapping of itemTypes to vcCONTENTTYPE in https://riksarkivet.se/Media/pdf-filer/doi-t/FGS_Paketstruktur_Tillagg_RAFGS1V1_2A20171025.pdf 
    20210218-0426: v0.9995 Added file format info and mimetype for variants of netCDF /.cdf (20210426), + .ams and .jr6 (SND2021-44 geo magnetism case), + .dng (RA-guide on photo) and .jrn (su.figshare)  
    20201203-1204: v0.9995 Added / changed mimetypes and file format info for file extensions for .dat and .irr, after manual test + DROID and JHOVE ...
    20200514-1015: v0.9994 Minor adjustment reflecting changes in method to get @archivalInst from extractFigsFileInfo.xq v0.9994 and resulting file_info.xml (2020-10-15 joakim.philipson@su.se)
                    Added mimetypes and file format info for file extensions
                    '.annot', '.brf','.fig','.gii','.graphml','.label','.md','.mgh', '.mgz', '.otf', '.RDS', '.rst', '.seaview', '.srjs','.stats', '.surf', '.trigs', '.tsvs', '.ttls' .
    20200424-0506: v0.9993 Replacement of 'Swedish' characters å,ä, ö + addition of possible (Dimensions) Grant_url, removed unused variables and code correction for Funder_title.
                   Added mimetypes for '.gz', '.dm3' and '.pyc' to $filext2mimetypeMap, for '.gz' and '.dm3' also added @PUID from PRONOM.
    2020-04-21: v0.9992 Revision to handle presence of multiple funders in file_info.xml 
    2020-04-01: v0.9991 dc:date added to dmdSec, and order of dc-elements changed.
    2020-03-30/31: v0.999 Changed handling of filenames in replace(name, '%20', '_') to replace(name, ' ', '_') to sync with eFFi.xq v0.999. (Also added mimetypes for file extensions .ipynb, .mxd, .prn, .pth, .qpj, .r, .raw and .vcf).   
    2020-03-25/26: v0.9981 Added/changed mimetype="application/x-bibtex" for file extensions .bib and .bst, mimetype="application/x-latex" for .sty and .tex, all used within LaTex files. Further added/changed mimetypes for .bdf, .dmp and .fif! 
    2020-03-18: v0.998 Adjusted conditions for older items of only metadata, with data file(s) deposited externally to Figshare, downloaded manually ($manualFileName, $manualFileSize, $manualMD5 and FLocat/@href from dcterms:references.   
    2020-03-17: v0.997 Added/updated mimetype="text/x-rsrc", source and date for file-extensions .R, .Rda, .RData from digipres.org; not ideal, since different fileformat identification tools (Datatypes.net, DROID, JHOVE, PRONOM) give other results, 
    and files should not be opened simply as text-files, but with RStudio or R.     
    2020-03-11: v0.996 Added references as dcterms:references, Associated Publication as dcterms:isReferencedBy, and DMP reference as dcterms:relation.  
    2020-03-10: v0.995 Added possible Funder information as agent.
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
    2019-07-02: v0.97 Amended <agent ROLE="ARCHIVIST" TYPE="OTHER" OTHERTYPE="SOFTWARE"> note to include both main transform (XSLT) file with version no and extractFigsFileInfo.xq file with version no. for metadata provenance. 
    2019-07-01: v0.96 Replaced @sukatInst with @archivalInst and @sukat1Instnr with @sukatInstnr in <agent ROLE="ARCHIVIST" TYPE="ORGANIZATION"> to align with updated extractFigsFileInfo.xq - v0.96. Also added new file extension .alnfaa to filext2mimetypeMap. -->
<!-- 2019-05-21: v0.9 Added new conditional <note>-element to agent for SU institutionNr if not empty in file_info. 
                      Removed second <agent ROLE="EDITOR" TYPE="INDIVIDUAL"><copy-of agent[2]/> 
                      Removed firstAuthorID <agent ROLE="EDITOR" TYPE="INDIVIDUAL"><note/> substantially for different cases 1) Alert: ID-check! (e.g. > 1 ORCIDs or sukatIDs found), 2) ORCID found, 3) sukatID found, 4) No firstSUauthorID found. -->
<!-- 2019-03-19: v0.8 Added new variable $firstAuthorID, to accomodate ORCiDs or other personID, if no @ALERT="ID-check!" in param doc file_info.xml. 
                      Added mime-type for file extension '.Rmd' to filext2mimetypeMap, with @source and @date. -->
<!-- 2019-01-18: v0.7 Added mime-type for file extension '.mat' to filext2mimetypeMap, with comment about alternative use. -->
<!-- 2018-09-05: v0.6 Added and changed AGENT values; 2018-09-12 added agent with note ORCID / sukatID of first author.  --> 
<!-- 2018-07-24: v0.5 Added  missing last digit in default for agent[@ROLE="ARCHIVIST" TYPE="ORGANIZATION"]/note = "ORG:2021003062". -->
<!-- 2018-07-17: v0.4 Updated with enlarged filext2mimetypeMap for some shapefiles and some 
    opendocument fileformats (.odp, .ods, .odt), including 'source' of mimetype attribution for provenance
    + added default @MIMETYPE = 'application/unknown' for file-extensions that are not (yet) found in the 
    filext2mimetypeMap. Also added default fileGrp/@ID = 'filembargo-article-(no.)' for cases of 
    embargoed file access. Removed automatic namespace inclusion from 'copy-of' elements in dmdSec 
    by means of @copy-namespaces="no". / joakim.philipson@su.se-->
<!-- 2018-03-27: v0.3 Updated with enlarged filext2mimetypeMap, changed creation of @MIMETYPE by means of 
    tokenize (to account for filenames with inherent '.'), now functioning removal of HTML-tags from 
    dc:description and more accurate dmdSec. Also changed default hardcoded value of 
    ext:CONTENTTYPESPECIFICATION to current FGS-CSPackage specification, awaiting dedicated FGS-CommonSpec. 
    for research data / research material./ joakim.philipson@su.se -->

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:mets="http://www.loc.gov/METS/"
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
    
 <!-- Deprecated:  
    <xsl:param name="deliveryFeedType" as="xs:string"/>
    <xsl:variable name="OAI_FEED_TYPE" select="xs:string('oai')"/>
    <xsl:variable name="filext2mimetypeMap"> - 
    now from parameter doc filext2mimetypeMapMAIN.xml   
   -->

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
            OBJID="{concat('IP-',//dc:identifier)}" LABEL="{local:removeHtmlTags(//dc:title)}"
            TYPE="{if (//dc:type='Dataset' or //dc:type='Figure' or //dc:type='Software' or //dc:type='Workflow') then 'Unstructured' else 'Publication'}"
            PROFILE="https://earksip.dilcis.eu/profile/E-ARKSIP.xml" csip:CONTENTINFORMATIONTYPE="MIXED">
            <!--Deprecated: xmlns:ext="ExtensionMETS"
                xsi:schemaLocation="http://www.loc.gov/METS/ http://xml.ra.se/e-arkiv/METS/CSPackageMETS.xsd ExtensionMETS http://xml.ra.se/e-arkiv/METS/CSPackageExtensionMETS.xsd"
                ext:CONTENTTYPESPECIFICATION="https://riksarkivet.se/Media/pdf-filer/doi-t/FGS_Paketstruktur_RAFGS1V1_2.pdf" PROFILE="http://xml.ra.se/e-arkiv/METS/CommonSpecificationSwedenPackageProfile.xml" -->
            
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
                <name>
                    <xsl:value-of
                        select="concat('Stockholms universitet, ', $file_info_data/file_info/substring-after(@archivalInst, ' '))"
                    />
                </name>
                <note>ORG:2021003062</note>
                <xsl:choose>
                    <xsl:when test="string-length($file_info_data/file_info/@archivalInst) &gt; 0">
                        <note>
                            <xsl:value-of
                                select="concat('InstNr:', $file_info_data/file_info/substring-before(@archivalInst, ' '))"
                            />
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
                <name>SUB_oai-pmhMETS_harvestTransformer_from_su.figshare.com</name>
                <note>
                    <xsl:value-of
                        select="concat('5figMETS2fgs.xsl v1.4', ', 2et4extractFigsFileInfo.xq ', $file_info_data/file_info/@SW-Agent_2et4extractFigsFileInfo.xq)"
                    />
                </note>
            </agent>

            <!-- 2020-03-10 Added Funder information. 
                  2020-04-21/27 Revision to handle multiple funders, addition of possible (Dimensions) Grant_url, removed unused variables and code correction for Funder_title.
             -->

            <xsl:for-each select="$file_info_data/file_info/funding__list/_">
                <agent ROLE="OTHER" TYPE="ORGANIZATION">

                    <xsl:choose>
                        <xsl:when test="
                                exists(for $n in (./funder__name)
                                return
                                    $n[string-length($n) &gt; 0])">
                            <name>
                                <xsl:value-of select="concat('Funder_name:', ./funder__name/text())"
                                />
                            </name>

                        </xsl:when>

                        <xsl:when test="
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
                        <xsl:when test="
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
                        <xsl:when test="
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
                        <xsl:when test="
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
                        <xsl:when test="
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
                    <xsl:value-of select="$file_info_data/file_info/@prefSUauthorNameInv"/>
                </name>
                <note>
                    <!-- Revision 2019-05-21 v0.9: -->
                    <xsl:choose>
                        <xsl:when test="$file_info_data/file_info[@ALERT = 'ID-check!']">
                            <xsl:value-of select="'ID-check!'"/>
                        </xsl:when>
                        <xsl:when
                            test="string-length($file_info_data/file_info/@prefSUauthORCiD) &gt; 4">
                            <xsl:value-of
                                select="concat('ORCID:', substring-after($file_info_data/file_info/@prefSUauthORCiD, 'orcid.org/'))"
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
            <altRecordID TYPE="SUBMISSIONAGREEMENT">https://su.figshare.com</altRecordID>
            <metsDocumentID>METS.xml</metsDocumentID>

        </metsHdr>
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
                         <!--   2024-10-30 Proved to not hold for item 27117831.v1, thus removed
                             until further notice. 
                             2025-06-18 Reinstated for selected curated items, where relation is
                             known to hold:  -->  
                             <xsl:when
                                test="$file_info_data/file_info/@relationType='IsSupplementTo'">
                                <dcterms:isReferencedBy>
                                    <xsl:value-of
                                        select="$file_info_data/file_info/@resourceDOI"
                                    />
                                </dcterms:isReferencedBy>
                            </xsl:when>  
                       <!-- 20250225: Removed "dcterms:isReferencedBy" below as proposed change to
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
                            </xsl:when>  -->
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
           
            <xsl:variable name="manualFileID"><xsl:value-of
                select="for $i in ($file_info_data/files/_/id) return concat('file-',$i)"/></xsl:variable> 
            <mets:fileGrp
                ID="{if ($linkOnly = 'true') then ('linkOnly') else (if(//fileGrp/@ID) then (//fileGrp/@ID) else $fileXternalID)}">
                <xsl:choose>
                    <xsl:when test="string-length($file_info_data/file_info/files/_[1]) &gt; 1">
                        <xsl:for-each select="$file_info_data/file_info/files/_">
                            <mets:file>                 
                                <xsl:variable name="replaceSpace" select="replace(name, ' ', '_')"/>
                                <xsl:variable name="replace-å" select="for $i in $replaceSpace return replace($i, 'å', 'a')"/>
                                <xsl:variable name="replace-ä" select="for $j in $replace-å return replace($j, 'ä', 'a')"/>
                                <xsl:variable name="replace-ö" select="for $k in $replace-ä return replace($k, 'ö', 'o')"/>
                                <xsl:attribute name="ID" select="concat('file-', id)"/>
                                <xsl:attribute name="CREATED" select="ancestor::file_info/@pubDate"/>
                                <xsl:attribute name="OWNERID" select="if (is__link__only = 'true')
                                    then ancestor::file_info/manualFiles/manualFileName else $replace-ö"/>
                                <xsl:attribute name="SIZE" select="
                                        if (is__link__only = 'true')
                                        then
                                            ancestor::file_info/manualFiles/manualFileSize
                                        else
                                            size"/>
                                <xsl:attribute name="CHECKSUMTYPE" select="'MD5'"/>


                                <xsl:attribute name="CHECKSUM" select="
                                        if (is__link__only = 'true') then
                                            ancestor::file_info/manualFiles/manualMD5
                                        else
                                            if (is__link__only = 'false' and supplied__md5 = computed__md5) then
                                                (supplied__md5)
                                            else
                                                concat('recomputed_md5:', _/computed__5)"/>

                                <xsl:attribute name="MIMETYPE" select="
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
                                                    'application/unknown')"/>
                                <!-- alternative older solution, does not work for filenames with inherent '.':s: <xsl:attribute name="MIMETYPE" select="for $i in (substring-after(name,'.')) return $filext2mimetypeMap//entry[@filext = $i]/@mimetype"/> -->
                                <mets:FLocat xmlns:xlink="http://www.w3.org/1999/xlink"
                                    LOCTYPE="URL" xlink:href="{download__url}"/>

                            </mets:file>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:when
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
                    </xsl:when>
                </xsl:choose>
            </mets:fileGrp>
        </mets:fileSec>
    </xsl:template>

    <xsl:template name="createStructMap">
        <xsl:variable name="linkOnly">
            <xsl:value-of select="($file_info_data/file_info/files/_/is__link__only)"/>            
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$linkOnly = 'true'">
                <mets:structMap TYPE="logical">
                    <mets:div LABEL="linkOnly">
                        <xsl:for-each select="$file_info_data/file_info/files/_">
                            <mets:div
                                LABEL="{substring-before(for $i in (tokenize(name,'\.')[last()]) return $filext2mimetypeMap//entry[@filext = $i]/@mimetype,'/')}">
                                
                                
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
                <xsl:for-each select="$file_info_data/file_info/files/_">
                    <mets:div
                        LABEL="{substring-before(for $i in (tokenize(name,'\.')[last()]) return $filext2mimetypeMap//entry[@filext = $i]/@mimetype,'/')}">
                        <mets:fptr FILEID="{concat('file-',id)}"/>
                    </mets:div>
                </xsl:for-each>
                </mets:div>
              </mets:div>  
             </mets:structMap>   
            </xsl:otherwise>
        </xsl:choose> 
    </xsl:template>

    <xsl:template match="dc:identifier">
        <mets>
            <xsl:copy-of select="@*"/>
            <xsl:value-of select="."/>
        </mets>
    </xsl:template>

</xsl:stylesheet>