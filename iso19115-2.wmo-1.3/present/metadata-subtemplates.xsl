<xsl:stylesheet version="2.0" xmlns:xsl ="http://www.w3.org/1999/XSL/Transform"
  xmlns:gmi="http://www.isotc211.org/2005/gmi"
  xmlns:gmd="http://www.isotc211.org/2005/gmd"
  xmlns:gco="http://www.isotc211.org/2005/gco"
	xmlns:geonet="http://www.fao.org/geonetwork"
  exclude-result-prefixes="mcp gmd gco geonet">
  
  <!-- Subtemplate mode - overrides for iso19139 are placed in here
	     -->
  <xsl:template name="iso19115-2.wmo-1.3-subtemplate">
		<xsl:variable name="19115-2.wmo-1.3Elements">
			<xsl:apply-templates mode="iso19115-2.wmo-1.3-subtemplate" select="."/>
		</xsl:variable>

		<xsl:choose>
			<xsl:when test="normalize-space(geonet:info/title)!=''">
				<title><xsl:value-of select="geonet:info/title"/></title>
			</xsl:when>
			<xsl:when test="count($19115-2.wmo-1.3Elements/*)>0">
				<xsl:copy-of select="$19115-2.wmo-1.3Elements"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates mode="iso19139-subtemplate" select="."/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

  <xsl:template mode="iso19115-2.wmo-1.3-subtemplate" match="*"/>
  
</xsl:stylesheet>
