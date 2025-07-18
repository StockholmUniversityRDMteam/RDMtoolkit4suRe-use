<?xml version="1.0" encoding="UTF-8"?>
<!-- Schematron schema for FAIRness evaluation according to score from SUDMP2maDMP1-1.xsl and resulting transformed APIv0 DMP output (joakim.philipson@su.se). 
     2024-03-13/25 *Current version 0.5: Corrected rule id="dataset_id-rule" to include count(//dataset_id/identifier) instead of only count(//identifier), causing false alarm. Changed orcid-contact-id rule to report, similar to dataset-id rule for doi, avoiding false positives..
     2022-06-13 Version 0.4: Added rule id="dataset_id-rule" to ascertain distinct and unique dataset_id/identifiers within the dmp.
     2022-02-22 Version 0.3: Added rule id="orcid-contact-identifier" and "dataset1-identifier-rule" to check for consistency between <identifier> and <type>.
     2021-12-22 Version 0.2: Updated FAIR score count after to acknowledge all score-giving options. 
 --> 
<schema xmlns="http://purl.oclc.org/dsdl/schematron"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process" queryBinding="xslt2"
    defaultPhase="Initial">
    <ns prefix="mets" uri="http://www.loc.gov/METS/"/>
    <ns prefix="ext" uri="http://xml.ra.se/e-arkiv/METS/CSPackageExtensionMETS.xsd"/>
    <ns prefix="xsi" uri="http://www.w3.org/2001/XMLSchema-instance"/>
    <ns prefix="xlink" uri="http://www.w3.org/1999/xlink"/>
    <ns prefix="local" uri="local-functions"/>


    <phase id="Diagnosis">
        <active pattern="Diagnose"/>
    </phase>



    <phase id="Initial" fpi="SUDMP2maDMP1-1.xsl">
        <active pattern="FAIRscore"/>
    </phase>

    <phase id="Final" fpi="SUDMP2maDMP1-1.xsl">
        <!--   -->
        <active pattern="FAIRscore"/>
    </phase>

    <pattern id="Diagnose">
        <rule id="versionTest" context="/">
            <report test="//initialVersion = 'Archive Initial'">Use Final</report>

            <report
                test="//initialVersion ne 'Archive Initial' and //finalVersion ne 'Archive Final'"
                >Use Initial</report>

            <report
                test="//initialVersion ne 'Archive Initial' and //finalVersion = 'Archive Final'"
                >Check again! Use Final</report>

            <report test="//initialVersion = 'Archive Initial' and //finalVersion = 'Archive Final'"
                >Archive Final</report>
        </rule>
    </pattern>




    <pattern id="FAIRscore">
        <rule id="FAIR-values" context="/">
            <let name="FindableScore" value="count(//F-value)"/>
            <let name="AccessibleScore" value="count(//A-value)"/>
            <let name="InteroperableScore" value="count(//I-value)"/>
            <let name="ReusableScore" value="count(//R-value)"/>

            <let name="F-content" value="//F-value/preceding-sibling::Option"/>
            <let name="F-path"
                value="
                    distinct-values(for $f in $F-content
                    return
                        replace(replace(substring-after(substring-before(path($f), 'Option'), 'section'), '\[1\]/Q', '/'), '\{\}', ''))"/>
            <let name="F-valueSrc"
                value="
                    distinct-values(for $f in $F-content
                    return
                    concat(replace(replace(substring-after(substring-before(path($f),'Option'),'section'),'\[1\]/Q','/'),'\{\}',''),'answer: ',$f,'&#xA;'))"/>
             
            
            <let name="A-content" value="//A-value/preceding-sibling::Option"/>
            <let name="A-path"
                value="distinct-values(for $a in $A-content
                return
                replace(replace(substring-after(substring-before(path($a),'Option'),'section'),'\[1\]/Q','/'),'\{\}',''))"/>
            <let name="A-valueSrc" value="distinct-values(for $a in $A-content
                return
                concat(replace(replace(substring-after(substring-before(path($a),'Option'),'section'),'\[1\]/Q','/'),'\{\}',''),'answer: ',$a,'&#xA;'))"/>          
            
            <let name="I-content" value="//I-value/preceding-sibling::Option"/>
            <let name="I-path"
                value="distinct-values(for $i in $I-content
                return
                replace(replace(substring-after(substring-before(path($i),'Option'),'section'),'\[1\]/Q','/'),'\{\}',''))"/>
            <let name="I-valueSrc" value="distinct-values(for $i in $I-content
                return
                concat(replace(replace(substring-after(substring-before(path($i),'Option'),'section'),'\[1\]/Q','/'),'\{\}',''),'answer: ',$i,'&#xA;'))"/>          
     
            <let name="R-content" value="//R-value/preceding-sibling::Option"/>
            <let name="R-path" value="distinct-values(for $r in $R-content
                return
                replace(replace(substring-after(substring-before(path($r),'Option'),'section'),'\[1\]/Q','/'),'\{\}',''))"/>
            <let name="R-valueSrc" value="distinct-values(for $r in $R-content
                return
                concat(replace(replace(substring-after(substring-before(path($r),'Option'),'section'),'\[1\]/Q','/'),'\{\}',''),'answer: ',$r,'&#xA;'))"/>          
            
           
            <let name="totFAIRscore"
                value="count(//F-value) + count(//A-value) + count(//I-value) + count(//R-value)"/>


            <report test="$FindableScore">Your total Findable-score is <value-of
                    select="$FindableScore"/> out of ~34</report>
            <report test="$FindableScore">Your Findable-score comes from these sections and answers:
                    <value-of select="$F-valueSrc"/></report>

            <report test="$AccessibleScore">Your total Accessible-score is <value-of
                    select="$AccessibleScore"/> out of ~39</report>
            <report test="$AccessibleScore">Your Accessible-score comes from these sections and answers:
                <value-of select="$A-valueSrc"/></report>
            
            
            <report test="$InteroperableScore">Your total Interoperable-score is <value-of
                    select="$InteroperableScore"/> out of ~23</report>
            <report test="$InteroperableScore">Your Interoperable-score comes from these sections and answers:
                <value-of select="$I-valueSrc"/></report>
            
            <report test="$ReusableScore">Your total Reusable-score is <value-of
                    select="$ReusableScore"/> out of ~29</report>
            <report test="$ReusableScore">Your Reusable-score comes from these sections and answers:
                <value-of select="$R-valueSrc"/></report>


            <report test="$totFAIRscore &gt; 50">Great! Your total FAIR-score is over 50!</report>
            <report test="$totFAIRscore">Your total FAIR-score is <value-of select="$totFAIRscore"/>
                out of ~125</report>
        </rule>
        
        <rule id="dataset1-identifier-rule" context="dmp/dataset/array/dataset_id[1]">
         <let name="doi-pattern" value="'10.[0-9]{4,}/\S+$'"/>
            <report test="./type = 'doi' and not(matches(./identifier,$doi-pattern))">
                A DOI identifier must contain a string with '10.', followed by a minimum of 4 digits, a '/' and a suffix of any length and characters.
            </report> 
    
            <report test="./type = 'handle' and not(contains(./identifier,'handle'))">
                The url for an identifier of handle type normally contains 'handle'.
            </report> 
            
            <report test="./type = 'ark' and not(contains(./identifier,'ark'))">
                The url for an identifier of ark type normally contains 'ark'.
            </report> 
            
            <report test="./type = 'url' and not(contains(./identifier,'http'))">
                A url normally contains  'http' or 'https'. If not, please specify the 'other' type.
            </report>  
            
        </rule>
        
      
        <rule id="dataset_id-rule" context="dmp/dataset">
            <report
                test="count(distinct-values(//dataset_id/identifier)) &lt; count(//dataset_id/identifier)"
                >The dataset_id/identifiers must be distinct and unique within every dmp.</report>
        </rule>
               
        
        <rule id="orcid-contact-identifier" context="dmp/contact/contact_id">
            <let name="orcid-pattern" value="'\d{4}-\d{4}-\d{4}-\d{3}[\d|X]'"/>
            <report test="type = 'orcid' and not(matches(identifier, $orcid-pattern))">
                If your contact identifier is not an ORCiD ID, please change *type* entry! An ORCiD ID consists of 16 digits in groups of 4, separated by '-', where the last digit may sometimes be replaced by an 'X'  
            </report>
        </rule>
        
    </pattern>

</schema>
