<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<!--
WMO Core Metadata Profile v1.3 schematron rules
-->

	<sch:title xmlns="http://www.w3.org/2001/XMLSchema">Requirements by WMO Core Metadata Profile v1.3</sch:title>
	<sch:ns prefix="gml32" uri="http://www.opengis.net/gml/3.2"/>
	<sch:ns prefix="gmd" uri="http://www.isotc211.org/2005/gmd"/>
	<sch:ns prefix="gmi" uri="http://www.isotc211.org/2005/gmi"/>
	<sch:ns prefix="srv" uri="http://www.isotc211.org/2005/srv"/>
	<sch:ns prefix="gco" uri="http://www.isotc211.org/2005/gco"/>
	<sch:ns prefix="geonet" uri="http://www.fao.org/geonetwork"/>
	<sch:ns prefix="xlink" uri="http://www.w3.org/1999/xlink"/>

	<!-- NOTE: No need to check namespaces (gml3.2), fileIdentifier cardinality as these are 
	     automatically enforced by GN -->
	<sch:pattern>
		<sch:title>6.2.1 Each WIS Discovery Metadata record shall name explicitly all namespaces used within the record; use of default namespaces is prohibited.</sch:title>
		<sch:rule context="*">
			<sch:assert test="not(.//*[name()=local-name()])">Failed at element <xsl:value-of select="name()"/></sch:assert>
		</sch:rule>
	</sch:pattern>

	<sch:pattern>
		<sch:title>A WIS Discovery Metadata record may declare compliance with WCMP by appropriate metadataStandardName and metadataStandardVersion</sch:title>
		<sch:rule context="/gmd:MD_Metadata|/gmi:MI_Metadata">
			<sch:assert test="gmd:metadataStandardName/gco:CharacterString != 'WMO Core Metadata Profile of ISO 19115 (WMO Core), 2003/Cor.1:2006 (ISO 19115), 2007 (ISO/TS 19139)' or gmd:metadataStandardVersion/gco:CharacterString != '1.3'">A WIS Discovery Metadata record may declare compliance with WCMP by metadataStandardName = &quot;WMO Core Metadata Profile of ISO 19115 (WMO Core), 2003/Cor.1:2006 (ISO 19115), 2007 (ISO/TS 19139)&quot; (currently &quot;<sch:value-of select="gmd:metadataStandardName/gco:CharacterString"/>&quot;) and metadataStandardVersion = &quot;1.3&quot; (currently &quot;<sch:value-of select="gmd:metadataStandardVersion/gco:CharacterString"/>&quot;).</sch:assert>
		</sch:rule>
	</sch:pattern>

	<sch:pattern>
		<sch:title>WMO Core Metadata Profile recommends the use of a URI structure for gmd:fileIdentifier attributes.</sch:title>
		<sch:rule context="/gmd:MD_Metadata|/gmi:MI_Metadata">
			<sch:assert test="starts-with(gmd:fileIdentifier/gco:CharacterString, 'urn:x-wmo:md:')">WMO Core Metadata Profile recommends the use of a URI structure for gmd:fileIdentifier attributes.</sch:assert>
		</sch:rule>
	</sch:pattern>

	<sch:pattern>
		<sch:title>Requirement 8.2.1: Each WIS Discovery Metadata record shall include at least one keyword from the WMO_CategoryCode code list.</sch:title>
		<sch:rule context="/*[name()='gmd:MD_Metadata' or name()='gmi:MI_Metadata']/gmd:identificationInfo/gmd:MD_DataIdentification">
			<sch:assert test="count(gmd:descriptiveKeywords/gmd:MD_Keywords[gmd:thesaurusName//gmd:title/gco:CharacterString='WMO_CategoryCode']/gmd:keyword)>0">Unable to find a WMO_CategoryCode keyword.</sch:assert>
		</sch:rule>
	</sch:pattern>

	<sch:pattern>
		<sch:title>Requirement 8.2.2: Keywords from WMO_CategoryCode code list shall be defined as keyword type "theme"</sch:title>
		<sch:rule context="/*[name()='gmd:MD_Metadata' or name()='gmi:MI_Metadata']/gmd:identificationInfo//gmd:descriptiveKeywords/gmd:MD_Keywords[gmd:thesaurusName//gmd:title/gco:CharacterString='WMO_CategoryCode']">
			<sch:let name="keywordType" value="gmd:type/gmd:MD_KeywordTypeCode/@codeListValue"/>
			<sch:assert test="gmd:type/gmd:MD_KeywordTypeCode/@codeListValue='theme'">keywordTypeCode <sch:value-of select="keywordType"/> is not valid, should be "theme".</sch:assert>
		</sch:rule>
	</sch:pattern>

	<sch:pattern>
		<sch:title>Requirement 8.2.3: All keywords sourced from a particular keyword thesaurus shall be grouped into a single instance of the MD_Keywords class.</sch:title>
		<sch:rule context="/*[name()='gmd:MD_Metadata' or name()='gmi:MI_Metadata']/gmd:identificationInfo/gmd:MD_DataIdentification[starts-with(gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:thesaurusName//gmd:title/gco:CharacterString,'WMO_')]">
			<sch:assert test="count(gmd:descriptiveKeywords/gmd:MD_Keywords[gmd:thesaurusName//gmd:title/gco:CharacterString='WMO_CategoryCode'])<=1">More than one WMO_CategoryCode keyword grouping found.</sch:assert>
			<sch:assert test="count(gmd:descriptiveKeywords/gmd:MD_Keywords[gmd:thesaurusName//gmd:title/gco:CharacterString='WMO_DistributionScopeCode'])<=1">More than one WMO_DistribitionScopeCode keyword grouping found.</sch:assert>
		</sch:rule>
	</sch:pattern>

	<sch:pattern>
		<sch:title>Requirement 8.2.4: Each WIS Discovery Metadata record describing geographic data shall include the description of at least one geographic bounding box defining the spatial extent of the data.</sch:title>
		<sch:rule context="/*[(name()='gmd:MD_Metadata' or name()='gmi:MI_Metadata') and ./gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue=('dataset','')]/gmd:identificationInfo/gmd:MD_DataIdentification">
			<sch:assert test="count(gmd:extent/gmd:EX_Extent/gmd:geographicElement/gmd:EX_GeographicBoundingBox)>0">No EX_GeographicBoundingBox elements found.</sch:assert>
		</sch:rule>
	</sch:pattern>

	<!-- For globally exchanged datasets via the WIS - context means they only apply if there is 
	     a WMO_DistributionScopeCode keyword set to GlobalExchange -->
	<sch:pattern>
		<sch:title>Requirement 9.1.1: A WIS Discovery Metadata record describing data for global exchange via the WIS shall indicate the scope of the distribution using the keyword "GlobalExchange" of type "dataCentre" from thesaurus WMO_DistributionScopeCode</sch:title>
		<sch:rule context="/*[name()='gmd:MD_Metadata' or name()='gmi:MI_Metadata']/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:descriptiveKeywords[gmd:MD_Keywords/gmd:keyword/*[(name()='gmx:Anchor' or name()='gco:CharacterString') and string()='GlobalExchange']]">
			<sch:assert test="gmd:MD_Keywords/gmd:thesaurusName//gmd:title/gco:CharacterString='WMO_DistributionScopeCode' and gmd:MD_Keywords/gmd:type/gmd:MD_KeywordTypeCode/@codeListValue='dataCentre'">WMO_DistributionScopeCode thesaurus title and/or MD_KeywordTypeCode not set to dataCentre.</sch:assert>
		</sch:rule>
	</sch:pattern>

	<sch:pattern>
		<sch:title>Requirement 9.2.1: A WIS Discovery Metadata record describing data for global exchange via the WIS shall have a gmd:MD_Metadata/gmd:fileIdentifier element beginning with 'urn:x-wmo:md:'</sch:title>
		<sch:rule context="/*[(name()='gmd:MD_Metadata' or name()='gmi:MI_Metadata') and ./gmd:identificationInfo/gmd:MD_DataIdentification/gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:keyword/*[(name()='gmx:Anchor' or name()='gco:CharacterString') and string()='GlobalExchange']]">
			<sch:assert test="starts-with(gmd:fileIdentifier/gco:CharacterString,'urn:x-wmo:md:')">fileIdentifier doesn't start with 'urn:x-wmo:md:'</sch:assert>
		</sch:rule>
	</sch:pattern>

	<sch:pattern>
		<sch:title>Requirement 9.3.1: A WIS Discovery Metadata record describing data for global exchange via the WIS shall indicate the WMO Data License as MD_LegalConstraint/otherConstraints using one and only one term from the WMO_DataLicenseCode code list.</sch:title>
		<sch:rule context="/*[name()='gmd:MD_Metadata' or name()='gmi:MI_Metadata']/gmd:identificationInfo/gmd:MD_DataIdentification[gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:keyword/*[(name()='gmx:Anchor' or name()='gco:CharacterString') and string()='GlobalExchange']]">
			<sch:let name="numberOfConstraints" value="count(gmd:resourceConstraints/gmd:MD_LegalConstraints/gmd:otherConstraints/gco:CharacterString[starts-with='WMO'])"/>
			<sch:assert test="$numberOfConstraints!=1">Condition not met. There are <sch:value-of select="$numberOfConstraints"/> from WMO_DataLicenseCode code list.</sch:assert>
		</sch:rule>
	</sch:pattern>

	<sch:pattern>
		<sch:title>Requirement 9.3.2: A WIS Discovery Metadata record describing data for global exchange via the WIS shall indicate the GTS Priority as MD_LegalConstraint/otherConstraints using one and only one term from the WMO_GTSProductCategoryCode code list.</sch:title>
		<sch:rule context="/*[name()='gmd:MD_Metadata' or name()='gmi:MI_Metadata']/gmd:identificationInfo/gmd:MD_DataIdentification[gmd:descriptiveKeywords/gmd:MD_Keywords/gmd:keyword/*[(name()='gmx:Anchor' or name()='gco:CharacterString') and string()='GlobalExchange']]">
			<sch:let name="numberOfConstraints" value="count(gmd:resourceConstraints/gmd:MD_LegalConstraints/gmd:otherConstraints/gco:CharacterString[starts-with='GTS'])"/>
			<sch:assert test="$numberOfConstraints!=1">Condition not met. There are <sch:value-of select="$numberOfConstraints"/> from GTSProductCategoryCode code list.</sch:assert>
		</sch:rule>
	</sch:pattern>

</sch:schema>
