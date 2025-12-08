<?xml version="1.0" encoding="UTF-8"?>
<!--2025-09-04: *Current version 0.42 - Changed from hardcoded CHECKSUMTYPE='MD5' to <xsl:attribute name="CHECKSUMTYPE" select="if ($linkOnly = 'true') 
    then 'MD5' else if (string-length(following-sibling::digest) &gt; 5) then
    upper-case(following-sibling::digestType) else 'MD5'"/> since METS.xml allows also for other types.
    2025-06-04/09: Version 0.41 - Changed resourceTypeGeneral by adding condition 
        "else if (contains(relationship,'supplement')) then 'Other' else ..."
    2024-12-10: Version 0.4 - Changed METS//@CHECKSUM creation to prioritize //digest from
        'file_info.xml' when present (mostly older items). Discovered that otherwise checksum creation fails when number
        of files > 3 (filesDownload unzip invoked MADIdryad6dataCheXpand.sh) and original file name whitespace is removed only
        *after* checksum creation. (Fix in 'dryad5extractFileInfo.xq' or in 'MADIdryad6dataCheXpand.sh' !) 
        Restored @SW-Agent_exDryadFIxq in <agent ROLE="ARCHIVIST" TYPE="OTHER" OTHERTYPE="SOFTWARE">. 
    2024-11-28: Version 0.33 - Further conditioned <creators> in dmdSec on existence of(//authors/array) or just (//authors">
    2024-09-09: Version 0.32 - conditioned <fundingReferences> on existence of (//funders/organization) or (//funders/array/organization"> to avoid empty <funderName/> (required) in METS.xml. 
                Updated <mets:div LABEL="{if (not($preMimeLabel)) then 'application' else substring-before($preMimeLabel,'/')}"> to avoid empty LABELs in structMap. Tokenized filextension to last . for filenames with multiple inline periods: ($filext2mimetypeMap/map/entry[@filext = tokenize($i, '\.')[last()]]/@mimetype).                      
    2024-09-02: Please NOTE! .txt files with Windows ANSI encoding cannot be opened directly in Oxygen (with UTF8 or Unicode) - e.g. //MADIDrop/dryadHarvesTransform/dryadPages20240725json2XMLoutputUA/dryadSUaffiliatesPage1UA/dryad.p2q4r/data/README_for_Spens_et_al_2016_DATASET.txt; use Anteckningar/Notepad! 
    2024-08-21/26/29: Version 0.31 - changed resourceTypeGeneral to better accord with DataCite-4.5 for items with 'primary_article' as relatedWorks//relationship: relationType="References" resourceTypeGeneral="{if (relationship='primary_article') then 'JournalArticle' else concat(upper-case(substring(relationship,1,1)),substring(relationship,2))}">
                   Explore possibility of adding PROV activities/version data e.g. as for "https://api.datacite.org/dois/10.5061/dryad.dbrv15f19/activities". Also included <fundingReferences/>. Further refined "local:removeHtmlTags" adjusted for Dryad html-encoding, but noting that some "tags" such as \u003csup\u003e-1\u003c/sup for power superscripts must be retained as carrying semantic weight. 
    2024-07-18/24/31-0802: Version 0.3 - extensive adaptation of dmdSec template to DataCite-4.5 descriptions with descriptionTypes also for Methods and TechnicalInfo + revision of local function "local:removeHtmlTags" adjusted for Dryad html-encoding. 
                   20240724: adaptation to new script "dryad6mv-dataCheXpand.sh" of fileSec and structMap to handle more than 20 files. Removed former parameter "file_infoM" as no longer needed. 
                   20240730/31-0802: adjustment in identification of element 'path' in checkSums.xml with 'path' in file_info.xml (failing e.g. when original filenames contain spaces),  replacing . with $replace-p (new variable to remove parentheses from filenames), comparing processed file-names on both sides of the =.
                                Extensive escape additions to function local:removeHtmlTags, especially for TechnicalInfo (usageNotes) tags.
                                Added dryad:relatedWorks -> datacite:relatedIdentifiers to dmdSec. (Next to handle: funders! (- presently inherited from figshare, not working here)
    2024-07-09: Version 0.2 - adjusted fileSec to records with only one datafile by adding '=' in fileGrp to <xsl:when test="($countFiles &gt;= 1) .../> 
    2024-03-10/13: First version 0.1; fixed fileSec and structMap! Changed top level mets:div LABEL in structMap from 'files' to <mets:div LABEL="data">. Set default 'application/unknown' for filext not (yet) added to filext2mimetypeMapMAIN.xml  
    Origin built on figDataCite2FGS.xsl: 
    #2024-02-05 Version 0.4 Changed datacite:resource/@xsi:schemaLocation (from //kernel-4.4) to new release (2024-01-22) http://schema.datacite.org/meta/kernel-4.5/metadata.xsd ; addition of parameter doc filext2mimetypeMapMAIN.xml (via dir-mvOrigMDfigDataCite.sh) allows for removal of inherent variable "filext2mimetypeMap"    
     2024-01-03 Version 0.3 Changed <xsl:copy-of select="//datacite:titles" copy-namespaces="no"/> to
     <titles><title><xsl:value-of select="local:removeHtmlTags(//datacite:title)"/></title></titles> AND csip:OTHERTYPE="{if (//datacite:resourceType/@resourceTypeGeneral='Text') then 'Publication' else 'Dataset'}" to just csip:OTHERTYPE="{//datacite:resourceType}"
     2024-01-02 Version 0.2 with adjustments of mets/@OBJID, mets/@TYPE, mets/@PROFILE, mets/@csip:CONTENTINFORMATIONTYPE="MIXED", note/@csip:NOTETYPE="IDENTIFICATIONCODE" ... in accordance with https://www.riksarkivet.se/Media/pdf-filer/doi-t/Riksarkivets_tillampning_av_E-ARK_CSIP_och_SIP_V1.0.pdf  
     2023-12-29 This is the FIRST version 0.1 of figDataCite2FGS building on both figMETS2fgs.xsl v0.9999 (fileSec and structMap sections) and (for dmdSec and most of rest) on zeno2fgs.xsl v0.9: 
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
    / joakim.philipson@su .se-->

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:mets="http://www.loc.gov/METS/"
    xmlns:OAI-PMH="http://www.openarchives.org/OAI/2.0/"
    xmlns:csip="https://DILCIS.eu/XML/METS/CSIPExtensionMETS"
    xmlns:sip="https://DILCIS.eu/XML/METS/SIPExtensionMETS"
    xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:datacite="http://datacite.org/schema/kernel-4" xmlns:local="local-functions"
    exclude-result-prefixes="xsl xs mets">
    <xsl:output indent="yes"/>

    <xsl:param name="checkSums" as="document-node()"/>
    <xsl:param name="file_info_data" as="document-node()"/>
    <xsl:param name="filext2mimetypeMap" as="document-node()"/>
    <!--  <xsl:param name="file_infoM" as="document-node()"/> -->

    <xsl:variable name="countFiles" select="$file_info_data/file_info/@FILENAMECOUNT"/>

    <xsl:function name="local:removeHtmlTags" as="xs:string">
        <xsl:param name="element"/>
        <xsl:value-of
            select="normalize-space(replace($element, '&lt;[^\s][^&lt;]*>|&amp;nbsp;|&#xA;|\\u003ch3|\\u003c/h3|\\u003cp|\\u003e|\\u003c/p|\\u003ci|\\u003c/i|\\u003cem|\\u003c/em|\\u003c/span|\\u003cspan|\\u003cstrong|\\u003c/strong|\\u003cul|\\u003c/ul|\\u003cli|\\u003c/li|\\u003ca|\\u003c/a|\\u003cdiv|\\u003c/div|\\u003ch4|\\u003c/h4|\\u003cbr|\\u003c/br|class=|&quot;o-metadata__file-usage-entry&quot;|&quot;o-heading__level3-file-title&quot;|&quot;o-metadata__file-description&quot;|&quot;o-metadata__file-name&quot;|id=&quot;cleantext&quot;|lang=&quot;.*&quot;|style=&quot;.*&quot;',' '))"
        />
    </xsl:function>

    <xsl:template match="/">

        <mets xmlns="http://www.loc.gov/METS/"
            xmlns:csip="https://DILCIS.eu/XML/METS/CSIPExtensionMETS"
            xmlns:sip="https://DILCIS.eu/XML/METS/SIPExtensionMETS"
            xmlns:xlink="http://www.w3.org/1999/xlink"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://www.loc.gov/METS/ schemas/mets.xsd csip schemas/DILCISExtensionMETS.xsd sip schemas/DILCISExtensionSIPMETS.xsd"
            OBJID="{concat('IP_',substring-after(//self/href,'dryad.'))}"
            LABEL="{local:removeHtmlTags(//title)}" TYPE="OTHER" csip:OTHERTYPE="dataset"
            PROFILE="https://earksip.dilcis.eu/profile/E-ARKSIP.xml"
            csip:CONTENTINFORMATIONTYPE="MIXED">

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
    <xsl:function name="local:replacePlusMinus">
        <xsl:param name="element"/>
        <xsl:value-of select="replace($element, '&amp;plusmn;', '±')"/>
    </xsl:function>
    <xsl:function name="local:replaceGthan">
        <xsl:param name="element"/>
        <xsl:value-of select="replace($element, '\\u0026gt;', '>')"/>
    </xsl:function>
    <xsl:function name="local:replaceComma">
        <xsl:param name="element"/>
        <xsl:value-of select="replace($element, ',', '')"/>
    </xsl:function>
    
    <xsl:template name="createMetsHeader">
        <metsHdr xmlns="http://www.loc.gov/METS/" CREATEDATE="{current-dateTime()}"
            RECORDSTATUS="NEW" csip:OAISPACKAGETYPE="SIP">

            <agent ROLE="ARCHIVIST" TYPE="ORGANIZATION">
                <name>
                    <xsl:value-of
                        select="concat('Stockholms universitet. ', $file_info_data/file_info/substring-after(@archivalInst, ' '))"
                    />
                </name>
                <note csip:NOTETYPE="IDENTIFICATIONCODE">ORG:2021003062</note>
                <xsl:choose>
                    <xsl:when test="string-length($file_info_data/file_info/@archivalInst) &gt; 0">
                        <note>
                            <xsl:value-of
                                select="concat('InstNr:', $file_info_data/file_info/substring-before(@archivalInst, ' '))"
                            />
                        </note>
                    </xsl:when>
                    <xsl:otherwise>
                        <note>'468 Zoologiska institutionen' or '473 Institutionen för ekologi,
                            miljö och botanik (DEEP)' or '485 Institutionen för miljövetenskap
                            (ACES)'</note>
                    </xsl:otherwise>
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
                <name>SUharvestTransformer_from_datadryad.org</name>
                <note>
                    <xsl:value-of
                        select="concat('dryadDataCite2FGS.xsl v0.41, dryad5extractFileInfo.xq ',$file_info_data/file_info/@SW-Agent_exDryadFIxq)"
                    />
                </note>
            </agent>
            <!--  The funding information metadata will be found in the dmdSec (DataCite 4.5) and need not be duplicated here:      
            <xsl:for-each select="//funders">
                <agent ROLE="OTHER" TYPE="ORGANIZATION">
                    <name>
                        <xsl:value-of select="organization"/>
                    </name>
                    <xsl:choose>
                        <xsl:when test="string-length(awardNumber) &gt; 1">
                            <note>
                                <xsl:value-of select="concat('Award number: ', awardNumber)"/>
                            </note>
                        </xsl:when>
                    </xsl:choose>    
                    <xsl:choose>
                        <xsl:when test="string-length(identifier) &gt; 1">
                            <note><xsl:value-of select="identifier"/>
                            </note>
                        </xsl:when>
                        <xsl:otherwise/>
                    </xsl:choose>
                </agent>
            </xsl:for-each> 
-->
            <agent ROLE="EDITOR" TYPE="INDIVIDUAL">
                <name>
                    <xsl:value-of select="$file_info_data/file_info/@prefSUauthorName"/>
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
                                select="concat('ORCID:', substring-after($file_info_data/file_info/@prefSUauthORCiD,'org/'))"
                            />
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

        <dmdSec xmlns="http://www.loc.gov/METS/"
            ID="{concat('dmd-',substring-after(//self/href,'dryad.'))}">
            <mdWrap MDTYPE="OTHER">
                <xmlData>
                    <resource xmlns="http://datacite.org/schema/kernel-4"
                        xsi:schemaLocation="http://datacite.org/schema/kernel-4 http://schema.datacite.org/meta/kernel-4.5/metadata.xsd">
                        <identifier identifierType="DOI">
                            <xsl:value-of select="$file_info_data/file_info/@DOI"/>
                        </identifier>
                        <creators>               
                            <xsl:for-each select="if (//authors/array) then
                                (//authors/array)
                                else
                                //authors">
                                <creator>
                                    <creatorName>
                                        <xsl:value-of select="concat(lastName, ', ', firstName)"/>
                                    </creatorName>
                                    <givenName>
                                        <xsl:value-of select="firstName"/>
                                    </givenName>
                                    <familyName>
                                        <xsl:value-of select="lastName"/>
                                    </familyName>
                                    <nameIdentifier nameIdentifierScheme="ORCID"
                                        schemeURI="http://orcid.org">
                                        <xsl:value-of select="orcid"/>
                                    </nameIdentifier>
                                    <affiliation affiliationIdentifier="{affiliationROR}"
                                        affiliationIdentifierScheme="ROR"
                                        schemeURI="https://ror.org">
                                        <xsl:value-of select="affiliation"/>
                                    </affiliation>
                                </creator>
                            </xsl:for-each>
                        </creators>
                        <!--   <xsl:copy-of select="//datacite:titles" copy-namespaces="no"/>  -->
                        <titles>
                            <title>
                                <xsl:value-of select="local:removeHtmlTags(//title)"/>
                            </title>
                        </titles>
                        <publisher>https://datadryad.org</publisher>
                        <publicationYear>
                            <xsl:value-of select="substring-before(//publicationDate, '-')"/>
                        </publicationYear>
                        <!-- <subjects/> -->
                        <dates>
                            <date dateType="Created">
                                <xsl:value-of select="//publicationDate"/>
                            </date>
                            <date dateType="Updated">
                                <xsl:value-of select="//lastModificationDate"/>
                            </date>
                        </dates>
                        <resourceType resourceTypeGeneral="Dataset">Dataset</resourceType>
                        <relatedIdentifiers>
                            <relatedIdentifier relatedIdentifierType="ISSN"
                                relationType="References" resourceTypeGeneral="Journal">
                                <xsl:value-of select="//relatedPublicationISSN"/>
                            </relatedIdentifier>
                            <xsl:for-each select="
                                    if (//relatedWorks/array) then
                                        (//relatedWorks/array)
                                    else
                                        //relatedWorks">
                                <relatedIdentifier relatedIdentifierType="{identifierType}"
                                    relationType="References"
                                    resourceTypeGeneral="{if (contains(relationship,'article')) then
                                    'JournalArticle' else if (contains(relationship,'supplement')) then
                                    'Other' else concat(upper-case(substring(relationship,1,1)),substring(relationship,2))}">
                                    <xsl:value-of select="identifier"/>
                                </relatedIdentifier>
                            </xsl:for-each>
                        </relatedIdentifiers>
                        <rightsList>
                            <rights xml:lang="en" schemeURI="https://spdx.org/licenses/"
                                rightsIdentifierScheme="SPDX" rightsIdentifier="CC0-1.0"
                                rightsURI="https://creativecommons.org/publicdomain/zero/1.0/">CC0
                                1.0 Universal (CC0 1.0) Public Domain Dedication</rights>
                        </rightsList>

                        <descriptions>
                            <description descriptionType="Abstract">
                                <xsl:value-of
                                    select="local:replacePlusMinus(local:replaceSuuml(local:replaceUuml(local:replaceSaring(local:replaceAuml(local:replaceSauml(local:replaceSouml(local:replaceOuml(local:replaceDash(local:replaceSpace(local:quoteReplace(local:removeHtmlTags(//abstract))))))))))))"
                                />
                            </description>
                            <description descriptionType="Methods">
                                <xsl:value-of
                                    select="local:replaceGthan(local:replacePlusMinus(local:replaceSuuml(local:replaceUuml(local:replaceSaring(local:replaceAuml(local:replaceSauml(local:replaceSouml(local:replaceOuml(local:replaceDash(local:replaceSpace(local:quoteReplace(local:removeHtmlTags(//methods)))))))))))))"
                                />
                            </description>
                            <description descriptionType="TechnicalInfo">
                                <xsl:value-of
                                    select="local:replacePlusMinus(local:replaceSuuml(local:replaceUuml(local:replaceSaring(local:replaceAuml(local:replaceSauml(local:replaceSouml(local:replaceOuml(local:replaceDash(local:replaceSpace(local:quoteReplace(local:removeHtmlTags(//usageNotes))))))))))))"
                                />
                            </description>
                            <!--    <xsl:for-each
                                select="//datacite:description[@descriptionType = 'Other']/text()">  
                                <description descriptionType="Other">
                                    <xsl:copy select="." copy-namespaces="no"/>
                                </description>
                            </xsl:for-each>  -->
                        </descriptions>
                      <xsl:choose>
                       <xsl:when test="exists(//funders/organization) or exists(//funders/array/organization)">  
                        <fundingReferences>
                            <xsl:for-each select="
                                    if (//funders/array) then
                                        (//funders/array)
                                    else
                                        //funders">
                                <fundingReference>
                                    <funderName>
                                        <xsl:value-of select="organization"/>
                                    </funderName>
                                    <xsl:choose>
                                        <xsl:when test="string-length(identifier) &gt; 1">
                                            <funderIdentifier
                                                funderIdentifierType="{upper-case(identifierType)}">
                                                <xsl:value-of select="identifier"/>
                                            </funderIdentifier>
                                        </xsl:when>
                                    </xsl:choose>
                                    <awardNumber>
                                        <xsl:value-of select="awardNumber"/>
                                    </awardNumber>
                                </fundingReference>
                            </xsl:for-each>
                        </fundingReferences>
                       </xsl:when>
                       <xsl:otherwise/>   
                      </xsl:choose>    
                    </resource>
                </xmlData>
            </mdWrap>
        </dmdSec>
    </xsl:template>


    <!-- 
        //stash_003afiles[1]/_[1]/path[1]
        //stash_003afiles[1]/_[1]/__links[1]/stash_003adownload[1]/href[1]
    -->
    <xsl:template name="createFileSec">
        <mets:fileSec>
            <xsl:variable name="linkOnly">
                <xsl:value-of select="$file_info_data/file_info/@FILENAMECOUNT &lt; 1"/>
            </xsl:variable>
            <xsl:variable name="fileGroupID">
                <xsl:value-of
                    select="concat('versionFiles-', substring-before(substring-after($file_info_data/file_info/distinct-values(//stash_003afiles/href), 'versions/'), '/files'))"
                />
            </xsl:variable>
            <xsl:variable name="manualFileID">
                <xsl:value-of select="
                        for $i in ($file_info_data/file_info/manualFiles)
                        return
                            ($i/manualMD5)"/>
            </xsl:variable>
            <xsl:variable name="countFiles" select="$file_info_data/file_info/@FILENAMECOUNT"/>
            <mets:fileGrp ID="{if ($linkOnly = 'true') then ('linkOnly') else $fileGroupID}">
                <xsl:choose>
                    <xsl:when test="($countFiles &gt; 0)">
                        <xsl:for-each select="$file_info_data/file_info//_/path">
                            <mets:file>
                                <xsl:variable name="replaceSpace" select="replace(., ' ', '_')"/>
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
                                <xsl:variable name="replace-p" select="
                                        for $p in $replace-ö
                                        return
                                            replace(replace(replace($p, '\(', '_'), '\)', ''),',','')"/>
                                <xsl:variable name="fileID"
                                    select="ancestor::_/__links/stash_003adownload/href"/>
                                <xsl:attribute name="ID"
                                    select="concat('file-', substring-before(substring-after($fileID, 'files/'), '/download'))"/>
                                <xsl:attribute name="CREATED"
                                    select="concat(ancestor::file_info/@pubDate, 'T01:01:01')"/>
                                <xsl:attribute name="OWNERID" select="
                                        if ($linkOnly = 'true') then
                                            ancestor::file_info/manualFiles/manualFileName
                                        else
                                            $replace-p"/>
                                <xsl:attribute name="SIZE" select="
                                        if ($linkOnly = 'true')
                                        then
                                            ancestor::file_info/manualFiles/manualFileSize
                                        else
                                            following-sibling::size"/>
                                <xsl:attribute name="CHECKSUMTYPE" select="
                                    if ($linkOnly = 'true')
                                    then
                                    'MD5'
                                    else if (string-length(following-sibling::digest) &gt; 5) then
                                    upper-case(following-sibling::digestType)
                                    else 'MD5'"/>

                                <xsl:attribute name="CHECKSUM"  select="
                                    if ($linkOnly = 'true')
                                    then
                                    ancestor::file_info/manualFiles/manualMD5
                                    else if (string-length(following-sibling::digest) &gt; 5) then following-sibling::digest
                                    else
                                            for $i in ($checkSums/files/file/path)
                                            return
                                                if (normalize-space($i) = $replace-p) then
                                                    ($checkSums/files/normalize-space($i/preceding-sibling::checksum))
                                                else
                                                    ()"/>

                                <xsl:attribute name="MIMETYPE" select="
                                        if ($linkOnly = 'true') then
                                            for $f in (tokenize(ancestor::file_info/manualFiles/manualFileName, '\.')[last()])
                                            return
                                                (if ($filext2mimetypeMap/map/entry[@filext = $f]/@mimetype) then
                                                    $filext2mimetypeMap/map/entry[@filext = $f]/@mimetype
                                                else
                                                    'application/unknown')
                                        else
                                            for $i in .
                                            return
                                                if (string-length($filext2mimetypeMap/map/entry[@filext = tokenize($i, '\.')[last()]]/@mimetype) &gt; 1) then
                                                    ($filext2mimetypeMap/map/entry[@filext = tokenize($i, '\.')[last()]]/@mimetype)
                                                else
                                                    'application/unknown'"/>

                                <mets:FLocat xmlns:xlink="http://www.w3.org/1999/xlink"
                                    LOCTYPE="URL"
                                    xlink:href="{concat('https://datadryad.org',$fileID)}"/>

                            </mets:file>
                        </xsl:for-each>
                    </xsl:when>
                </xsl:choose>
            </mets:fileGrp>
        </mets:fileSec>
    </xsl:template>

    <xsl:template name="createStructMap">
        <mets:structMap TYPE="physical">
            <mets:div LABEL="data">
                <xsl:choose>
                    <xsl:when test="$file_info_data/file_info/@FILENAMECOUNT &lt; 1">
                        <xsl:for-each select="$file_info_data/file_info/manualFiles">
                            <mets:div
                                LABEL="{substring-before(for $i in (tokenize(manualFileName,'\.')[last()]) return $filext2mimetypeMap/map/entry[@filext = $i]/@mimetype,'/')}">


                                <mets:fptr FILEID="{concat('file-',manualMD5)}"/>
                                <!-- FILEID="{if ($linkOnly = 'true') then ('file-0') else ()}"/> -->
                            </mets:div>
                        </xsl:for-each>
                    </xsl:when>
                  
                    <xsl:otherwise>
                        <xsl:for-each select="$file_info_data/file_info//_/path">
                            <xsl:variable name="fileID"
                                select="ancestor::_/__links/stash_003adownload/href"/>
                            <xsl:variable name="preMimeLabel" select="
                                    for $i in .
                                    return
                                        $filext2mimetypeMap/map/entry[@filext = substring-after($i, '.'[last()])]/@mimetype"/>
                            <mets:div LABEL="{if (not($preMimeLabel)) then 'application' else substring-before($preMimeLabel,'/')}">
                                <mets:fptr
                                    FILEID="{concat('file-',substring-before(substring-after($fileID,'files/'),'/download'))}"/>

                            </mets:div>
                        </xsl:for-each>
                    </xsl:otherwise>
                </xsl:choose>
            </mets:div>
        </mets:structMap>
    </xsl:template>

    <xsl:template match="datacite:identifier">
        <mets>
            <xsl:copy-of select="@*"/>
            <xsl:value-of select="."/>
        </mets>
    </xsl:template>

</xsl:stylesheet>
