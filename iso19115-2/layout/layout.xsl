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

	<xsl:variable name="iso19115-2schema" select="/root/gui/schemas/iso19115-2"/>
	<xsl:variable name="iso19115-2labels" select="$iso19115-2schema/labels"/>
	<xsl:variable name="iso19115-2codelists" select="$iso19115-2schema/codelists"/>
	<xsl:variable name="iso19115-2strings" select="$iso19115-2schema/strings"/>

  <!-- Visit all XML tree recursively -->
  <xsl:template mode="mode-iso19139" match="gmi:*|gml32:*">
    <xsl:param name="schema" select="$schema" required="no"/>
    <xsl:param name="labels" select="$labels" required="no"/>

		<!--
		<xsl:message>VISITING; <xsl:value-of select="concat(name(),':::::',namespace-uri())"/></xsl:message>
		<xsl:for-each select="*">
			<xsl:message>CHILD; <xsl:value-of select="concat(name(),':::::',namespace-uri())"/></xsl:message>
		</xsl:for-each>
		-->

    <xsl:apply-templates mode="mode-iso19139" select="*|@*">
      <xsl:with-param name="schema" select="$schema"/>
      <xsl:with-param name="labels" select="$labels"/>
    </xsl:apply-templates>
  </xsl:template>

  <!-- Boxed element
    
      Details about the last line :
      * namespace-uri(.) != $gnUri: Only take into account profile's element 
      * and $isFlatMode = false(): In flat mode, don't box any
      * and gmd:*: Match all elements having gmd child elements
      * and not(gco:CharacterString): Don't take into account those having gco:CharacterString (eg. multilingual elements)
  -->
  <xsl:template mode="mode-iso19139" priority="20000"
    match="*[(name() = $editorConfig/editor/fieldsWithFieldset/name
     or @gco:isoType = $editorConfig/editor/fieldsWithFieldset/name) and
		namespace-uri()='http://www.isotc211.org/2005/gmi']|
      *[namespace-uri(.) != $gnUri and $isFlatMode = false() and gmi:* and not(gco:CharacterString) and not(gmd:URL)]">
    <xsl:param name="schema" select="$schema" required="no"/>
    <xsl:param name="labels" select="$labels" required="no"/>

    <xsl:variable name="xpath" select="gn-fn-metadata:getXPath(.)"/>
    <xsl:variable name="isoType" select="if (../@gco:isoType) then ../@gco:isoType else ''"/>

    <xsl:variable name="attributes">
      <!-- Create form for all existing attribute (not in gn namespace)
      and all non existing attributes not already present. -->
      <xsl:apply-templates mode="render-for-field-for-attribute"
        select="
        @*|
        gn:attribute[not(@name = parent::node()/@*/name())]">
        <xsl:with-param name="ref" select="gn:element/@ref"/>
        <xsl:with-param name="insertRef" select="gn:element/@ref"/>
      </xsl:apply-templates>
    </xsl:variable>
    
    <xsl:variable name="errors">
      <xsl:if test="$showValidationErrors">
        <xsl:call-template name="get-errors"/>
      </xsl:if>
    </xsl:variable>
    
    <xsl:call-template name="render-boxed-element">
      <xsl:with-param name="label"
        select="gn-fn-metadata:getLabel($schema, name(), $labels, name(..), $isoType, $xpath)/label"/>
      <xsl:with-param name="editInfo" select="gn:element"/>
      <xsl:with-param name="errors" select="$errors"/>
      <xsl:with-param name="cls" select="local-name()"/>
      <xsl:with-param name="xpath" select="$xpath"/>
      <xsl:with-param name="attributesSnippet" select="$attributes"/>
      <xsl:with-param name="subTreeSnippet">
        <!-- Process child of those element. Propagate schema
        and labels to all subchilds (eg. needed like iso19110 elements
        contains gmd:* child. -->
        <xsl:apply-templates mode="mode-iso19139" select="*">
          <xsl:with-param name="schema" select="$schema"/>
          <xsl:with-param name="labels" select="$labels"/>
        </xsl:apply-templates>
      </xsl:with-param>
    </xsl:call-template>

  </xsl:template>

	<!-- Template to retrieve codelist values falling back through iso19115-2 and iso19139 to find
	     codelists that may belong to those schemas -->

	<xsl:template name="iso19115-2getCodelistValues">
		<xsl:param name="schema" select="$schema"/>
		<xsl:variable name="iso19115-2List" as="node()" select="gn-fn-metadata:getCodeListValues($schema, name(*[@codeListValue]), $iso19115-2codelists, .)"/>
		<xsl:choose>
			<xsl:when test="count($iso19115-2List/*)=0"> <!-- do iso19139 -->
				<xsl:copy-of select="gn-fn-metadata:getCodeListValues('iso19139', name(*[@codeListValue]), $iso19139codelists, .)"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="$iso19115-2List"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

  <!-- Match codelist values. Must use iso19115-2 because some 
	     19139 codelists are extended in 19115-2 - if the codelist exists in
			 iso19115-2 then use that otherwise use iso19139 codelists
  
  eg. 
  <gmd:CI_RoleCode codeList="./resources/codeList.xml#CI_RoleCode" codeListValue="pointOfContact">
    <geonet:element ref="42" parent="41" uuid="gmd:CI_RoleCode_e75c8ec6-b994-4e98-b7c8-ecb48bda3725" min="1" max="1"/>
    <geonet:attribute name="codeList"/>
    <geonet:attribute name="codeListValue"/>
    <geonet:attribute name="codeSpace" add="true"/>
  
  -->
  <xsl:template mode="mode-iso19139" priority="200" match="*[*/@codeList and $schema='iso19115-2']">
    <xsl:param name="schema" select="$schema" required="no"/>
    <xsl:param name="labels" select="$labels" required="no"/>

    <xsl:variable name="xpath" select="gn-fn-metadata:getXPath(.)"/>
    <xsl:variable name="isoType" select="if (../@gco:isoType) then ../@gco:isoType else ''"/>
    <xsl:variable name="elementName" select="name()"/>

		<!-- check iso19115-2 first, then fall back to iso19139 -->
		<xsl:variable name="listOfValues" as="node()">
			<xsl:call-template name="iso19115-2getCodelistValues">
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
  <xsl:template mode="mode-iso19139" match="*[gn:element/gn:text and $schema='iso19115-2']">
    <xsl:param name="schema" select="$schema" required="no"/>
    <xsl:param name="labels" select="$labels" required="no"/>

		<!-- check iso19115-2 first, then fall back to iso19139 -->
		<xsl:variable name="listOfValues" as="node()">
			<xsl:call-template name="iso19115-2getCodelistValues">
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

  <xsl:template mode="mode-iso19139"
                priority="20000"
                match="*[gco:Date|gco:DateTime]">
    <xsl:param name="schema" select="$schema" required="no"/>
    <xsl:param name="labels" select="$labels" required="no"/>

    <xsl:variable name="labelConfig"
                  select="gn-fn-metadata:getLabel($schema, name(), $labels)"/>

    <div data-gn-date-picker="{gco:Date|gco:DateTime}"
         data-label="{$labelConfig/label}"
         data-element-name="{name(gco:Date|gco:DateTime)}"
         data-element-ref="{concat('_X', gn:element/@ref)}"
				 data-namespaces='{{ "gco": "http://www.isotc211.org/2005/gco", "gml": "http://www.opengis.net/gml/3.2"}}'>
    </div>
  </xsl:template>


</xsl:stylesheet>
