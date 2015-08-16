<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:gts="http://www.isotc211.org/2005/gts"
  xmlns:gco="http://www.isotc211.org/2005/gco" xmlns:gmx="http://www.isotc211.org/2005/gmx"
  xmlns:srv="http://www.isotc211.org/2005/srv" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:gml32="http://www.opengis.net/gml/3.2" xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:gn="http://www.fao.org/geonetwork"     xmlns:gmi="http://www.isotc211.org/2005/gmi"
  xmlns:gn-fn-core="http://geonetwork-opensource.org/xsl/functions/core" 
  xmlns:gn-fn-metadata="http://geonetwork-opensource.org/xsl/functions/metadata"
  xmlns:gn-fn-iso19139="http://geonetwork-opensource.org/xsl/functions/profiles/iso19139"
  xmlns:exslt="http://exslt.org/common" exclude-result-prefixes="#all">

	<xsl:import href="../../iso19139/layout/layout.xsl"/>
  <xsl:include href="utility-tpl.xsl"/>
  <xsl:include href="layout-custom-fields.xsl"/>

	<xsl:variable name="iso19115-2.wmo-1.3schema" select="/root/gui/schemas/iso19115-2.wmo-1.3"/>
	<xsl:variable name="iso19115-2.wmo-1.3labels" select="$iso19115-2.wmo-1.3schema/labels"/>
	<xsl:variable name="iso19115-2.wmo-1.3codelists" select="$iso19115-2.wmo-1.3schema/codelists"/>
	<xsl:variable name="iso19115-2.wmo-1.3strings" select="$iso19115-2.wmo-1.3schema/strings"/>

 	<!-- Template to retrieve codelist values combining with iso19115-2 and iso19139 to find
	     all codelists that belong to each of these schemas -->

	<xsl:template name="iso19115-2.wmo-1.3getCodelistValues">
		<xsl:param name="schema" select="$schema"/>

		<xsl:variable name="wmoCodelists" select="gn-fn-metadata:getCodeListValues($schema, name(*[@codeListValue]), $iso19115-2.wmo-1.3codelists, .)"/>
		<xsl:variable name="iso19115-2Codelists" select="gn-fn-metadata:getCodeListValues('iso19115-2', name(*[@codeListValue]), $iso19115-2codelists, .)"/>
		<xsl:variable name="iso19139Codelists" select="gn-fn-metadata:getCodeListValues('iso19139', name(*[@codeListValue]), $iso19139codelists, .)"/>

		<codelist>
			<xsl:copy-of select="$wmoCodelists/entry|$iso19115-2Codelists/entry|$iso19139Codelists/entry"/>
		</codelist>
  </xsl:template>

  <!-- Match codelist values. Grab from iso19115-2.wmo-1.3 first because some 
	     19115-2 codelists are extended in 19115-2.wmo-1.3 - combine with any codelists 
			 in iso19115-2 and then iso19139 codelists
  
  eg. 
  <gmd:CI_RoleCode codeList="./resources/codeList.xml#CI_RoleCode" codeListValue="pointOfContact">
    <geonet:element ref="42" parent="41" uuid="gmd:CI_RoleCode_e75c8ec6-b994-4e98-b7c8-ecb48bda3725" min="1" max="1"/>
    <geonet:attribute name="codeList"/>
    <geonet:attribute name="codeListValue"/>
    <geonet:attribute name="codeSpace" add="true"/>
  
  -->
  <xsl:template mode="mode-iso19139" priority="40000" match="*[*/@codeList and $schema='iso19115-2.wmo-1.3']">
    <xsl:param name="schema" select="$schema" required="no"/>
    <xsl:param name="labels" select="$labels" required="no"/>

    <xsl:variable name="xpath" select="gn-fn-metadata:getXPath(.)"/>
    <xsl:variable name="isoType" select="if (../@gco:isoType) then ../@gco:isoType else ''"/>
    <xsl:variable name="elementName" select="name()"/>

		<!-- check this schema first, then fall back to iso19115-2 and finally iso19139 -->
		<xsl:variable name="listOfValues" as="node()">
			<xsl:call-template name="iso19115-2.wmo-1.3getCodelistValues">
				<xsl:with-param name="schema" select="$schema"/>
			</xsl:call-template>
		</xsl:variable>

    <xsl:call-template name="render-element">
      <xsl:with-param name="label"
        select="gn-fn-metadata:getLabel($schema, name(), $labels, name(..), $isoType, $xpath)/label"/>
      <xsl:with-param name="value" select="*/@codeListValue"/>
      <xsl:with-param name="cls" select="local-name()"/>
      <xsl:with-param name="xpath" select="$xpath"/>
      <xsl:with-param name="type" select="gn-fn-iso19139:getCodeListType(name())"/>
      <xsl:with-param name="name"
        select="if ($isEditing) then concat(*/gn:element/@ref, '_codeListValue') else ''"/>
      <xsl:with-param name="editInfo" select="*/gn:element"/>
      <xsl:with-param name="parentEditInfo" select="gn:element"/>
      <xsl:with-param name="listOfValues" select="$listOfValues"/>
      <xsl:with-param name="isFirst" select="count(preceding-sibling::*[name() = $elementName]) = 0"/>
    </xsl:call-template>

  </xsl:template>
  
  <!-- 
    Take care of enumerations.
    
    In the metadocument an enumeration provide the list of possible values:
  <gmd:topicCategory>
    <gmd:MD_TopicCategoryCode>
    <geonet:element ref="69" parent="68" uuid="gmd:MD_TopicCategoryCode_0073afa8-bc8f-4c52-94f3-28d3aa686772" min="1" max="1">
      <geonet:text value="farming"/>
      <geonet:text value="biota"/>
      <geonet:text value="boundaries"/
  -->
  <xsl:template mode="mode-iso19139" priority="40000" match="*[gn:element/gn:text and $schema='iso19115-2.wmo-1.3']">
    <xsl:param name="schema" select="$schema" required="no"/>
    <xsl:param name="labels" select="$labels" required="no"/>

		<!-- check this schema first, then fall back to iso19115-2 and finally iso19139 -->
		<xsl:variable name="listOfValues" as="node()">
			<xsl:call-template name="iso19115-2.wmo-1.3getCodelistValues">
				<xsl:with-param name="schema" select="$schema"/>
			</xsl:call-template>
		</xsl:variable>

    <xsl:call-template name="render-element">
      <xsl:with-param name="label"
        select="gn-fn-metadata:getLabel($schema, name(..), $labels, name(../..), '', '')/label"/>
      <xsl:with-param name="value" select="text()"/>
      <xsl:with-param name="cls" select="local-name()"/>
      <xsl:with-param name="type" select="gn-fn-iso19139:getCodeListType(name())"/>
      <xsl:with-param name="name" select="gn:element/@ref"/>
      <xsl:with-param name="editInfo" select="*/gn:element"/>
      <xsl:with-param name="listOfValues" select="$listOfValues"/>
    </xsl:call-template>
  </xsl:template>

</xsl:stylesheet>
