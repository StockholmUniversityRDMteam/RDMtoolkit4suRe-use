<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:mets="http://www.loc.gov/METS/"
                xmlns:ext="ExtensionMETS"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:dcterms="http://purl.org/dc/terms/"
                xmlns:xlink="http://www.w3.org/1999/xlink"
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