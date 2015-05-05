<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:gmi="http://www.isotc211.org/2005/gmi"
	xmlns:gmd="http://www.isotc211.org/2005/gmd"
	xmlns:gco="http://www.isotc211.org/2005/gco"
	xmlns:gmx="http://www.isotc211.org/2005/gmx"
	xmlns:srv="http://www.isotc211.org/2005/srv"
	xmlns:gml="http://www.opengis.net/gml"
  exclude-result-prefixes="xs"
  version="2.0">
  
  <!-- Redirect to iso19139 default layout first then do ISO19115-2 specific stuff
	     at present, this is nothing extra TODO: FIX -->
  <xsl:template name="metadata-fop-iso19115-2">
    <xsl:param name="schema"/>

    <xsl:call-template name="metadata-fop-iso19139">
      <xsl:with-param name="schema" select="'iso19139'"/>
    </xsl:call-template>

  </xsl:template>
  
</xsl:stylesheet>
