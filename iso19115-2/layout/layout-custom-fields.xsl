<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:gts="http://www.isotc211.org/2005/gts"
  xmlns:gco="http://www.isotc211.org/2005/gco" xmlns:gmx="http://www.isotc211.org/2005/gmx"
  xmlns:srv="http://www.isotc211.org/2005/srv" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:gml32="http://www.opengis.net/gml/3.2" xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:gn="http://www.fao.org/geonetwork"
  xmlns:gn-fn-core="http://geonetwork-opensource.org/xsl/functions/core"
  xmlns:gn-fn-metadata="http://geonetwork-opensource.org/xsl/functions/metadata"
  xmlns:gn-fn-iso19139="http://geonetwork-opensource.org/xsl/functions/profiles/iso19139"
  xmlns:exslt="http://exslt.org/common" exclude-result-prefixes="#all">

  <!-- Duration
      
       xsd:duration elements use the following format:
       
       Format: PnYnMnDTnHnMnS
       
       *  P indicates the period (required)
       * nY indicates the number of years
       * nM indicates the number of months
       * nD indicates the number of days
       * T indicates the start of a time section (required if you are going to specify hours, minutes, or seconds)
       * nH indicates the number of hours
       * nM indicates the number of minutes
       * nS indicates the number of seconds
       
       A custom directive is created.
  -->
  <xsl:template mode="mode-iso19139" match="gts:TM_PeriodDuration|gml32:duration" priority="2000">

    <xsl:variable name="xpath" select="gn-fn-metadata:getXPath(.)"/>
    <xsl:variable name="isoType" select="if (../@gco:isoType) then ../@gco:isoType else ''"/>

    <xsl:call-template name="render-element">
      <xsl:with-param name="label"
        select="gn-fn-metadata:getLabel($schema, name(), $labels, name(..), $isoType, $xpath)/label"/>
      <xsl:with-param name="value" select="."/>
      <xsl:with-param name="cls" select="local-name()"/>
      <xsl:with-param name="xpath" select="$xpath"/>
      <xsl:with-param name="directive" select="'gn-field-duration'"/>
      <xsl:with-param name="editInfo" select="gn:element"/>
    </xsl:call-template>

  </xsl:template>

  <!-- ===================================================================== -->
  <!-- gml32:TimePeriod (format = %Y-%m-%dThh:mm:ss) -->
  <!-- ===================================================================== -->

  <xsl:template mode="mode-iso19139" match="gml32:beginPosition|gml32:endPosition|gml32:timePosition" priority="2000">
		<xsl:param name="schema" select="$schema" required="no"/>
		<xsl:param name="labels" select="$labels" required="no"/>

    <xsl:variable name="xpath" select="gn-fn-metadata:getXPath(.)"/>
    <xsl:variable name="value" select="normalize-space(text())"/>


		<xsl:variable name="labelConfig" select="gn-fn-metadata:getLabel($schema, name(), $labels)"/>

		<div data-gn-date-picker="{.}"
				 data-tag-name=""
				 data-label="{$labelConfig/label}"
				 data-element-name="{name()}"
				 data-element-ref="{concat('_',gn:element/@ref)}"
				 data-namespaces='{{ "gco": "http://www.isotc211.org/2005/gco", "gml": "http://www.opengis.net/gml/3.2"}}'>
		</div>

		<!--
    <xsl:variable name="attributes">
      <xsl:if test="$isEditing">
        <!- - Create form for all existing attribute (not in gn namespace)
        and all non existing attributes not already present. - ->
        <xsl:apply-templates mode="render-for-field-for-attribute"
          select="             @*|           gn:attribute[not(@name = parent::node()/@*/name())]">
          <xsl:with-param name="ref" select="gn:element/@ref"/>
          <xsl:with-param name="insertRef" select="gn:element/@ref"/>
        </xsl:apply-templates>
      </xsl:if>
    </xsl:variable>


    <xsl:call-template name="render-element">
      <xsl:with-param name="label"
        select="gn-fn-metadata:getLabel($schema, name(), $labels, name(..), '', $xpath)/label"/>
      <xsl:with-param name="name" select="gn:element/@ref"/>
      <xsl:with-param name="value" select="text()"/>
      <xsl:with-param name="cls" select="local-name()"/>
      <xsl:with-param name="xpath" select="$xpath"/>
      <!- - 
          Default field type is Date.
          
          TODO : Add the capability to edit those elements as:
           * xs:time
           * xs:dateTime
           * xs:anyURI
           * xs:decimal
           * gml32:CalDate
          See http://trac.osgeo.org/geonetwork/ticket/661
        - ->
      <xsl:with-param name="type"
        select="if (string-length($value) = 10 or $value = '') then 'date' else 'datetime'"/>
      <xsl:with-param name="editInfo" select="gn:element"/>
      <xsl:with-param name="attributesSnippet" select="$attributes"/>
    </xsl:call-template>
		-->
  </xsl:template>
  
</xsl:stylesheet>
