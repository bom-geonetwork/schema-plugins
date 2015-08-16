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
			<sch:report test="not(.//*[name()=local-name()])">Failed at element <xsl:value-of select="name()"/></sch:report>
		</sch:rule>
	</sch:pattern>

	<sch:pattern>
		<sch:title>A WIS Discovery Metadata record may declare compliance with WCMP by appropriate metadataStandardName and metadataStandardVersion</sch:title>
		<sch:rule context="/*">
			<sch:report test="(string(gmd:metadataStandardName/*) != 'WMO Core Metadata Profile of ISO 19115 (WMO Core), 2003/Cor.1:2006 (ISO 19115), 2007 (ISO/TS 19139)') or (string(gmd:metadataStandardVersion/*) != '1.3')">A WIS Discovery Metadata record may declare compliance with WCMP by metadataStandardName = &quot;WMO Core Metadata Profile of ISO 19115 (WMO Core), 2003/Cor.1:2006 (ISO 19115), 2007 (ISO/TS 19139)&quot; (currently &quot;<value-of select="string(gmd:metadataStandardName/*)"/>&quot;) and metadataStandardVersion = &quot;1.3&quot; (currently &quot;<value-of select="string(gmd:metadataStandardVersion/*)"/>&quot;).</sch:report>
		</sch:rule>
	</sch:pattern>

	<sch:pattern>
		<sch:title>WMO Core Metadata Profile recommends the use of a URI structure for gmd:fileIdentifier attributes.</sch:title>
		<sch:rule context="/*">
			<sch:report test="starts-with(gmd:fileIdentifier/*/text(), 'urn:x-wmo:md:')">[&#167;8.1 &#182;5] WMO Core Metadata Profile recommends the use of a URI structure for gmd:fileIdentifier attributes.</sch:report>
		</sch:rule>
	</sch:pattern>

</sch:schema>
