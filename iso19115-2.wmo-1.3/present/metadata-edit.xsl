<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl ="http://www.w3.org/1999/XSL/Transform"
	xmlns:gmd="http://www.isotc211.org/2005/gmd"
	xmlns:gmi="http://www.isotc211.org/2005/gmi"
	xmlns:gco="http://www.isotc211.org/2005/gco"
	xmlns:gmx="http://www.isotc211.org/2005/gmx"
	xmlns:srv="http://www.isotc211.org/2005/srv"
	xmlns:gml="http://www.opengis.net/gml/3.2"
	xmlns:xlink="http://www.w3.org/1999/xlink"
	xmlns:exslt="http://exslt.org/common"
	xmlns:geonet="http://www.fao.org/geonetwork"
	exclude-result-prefixes="gmx gmd gco gml srv xlink exslt geonet">

	<xsl:import href="metadata-view.xsl"/>

	<!-- main template - the way into processing iso19115-2 -->
  <xsl:template match="metadata-iso19115-2" name="metadata-iso19115-2.wmo-1.3">
    <xsl:param name="schema"/>
    <xsl:param name="edit" select="false()"/>
    <xsl:param name="embedded"/>


		<!-- process in 19115-2.wmo-1.3 mode -->
		<xsl:variable name="iso19115-2.wmo-1.3Elements">
    	<xsl:apply-templates mode="iso19115-2.wmo-1.3" select="." >
     		<xsl:with-param name="schema" select="$schema"/>
     		<xsl:with-param name="edit"   select="$edit"/>
     		<xsl:with-param name="embedded" select="$embedded" />
    	</xsl:apply-templates>
		</xsl:variable>

		<!-- process in 19115-2 mode -->
		<xsl:variable name="iso19115-2Elements">
    	<xsl:apply-templates mode="iso19115-2" select="." >
     		<xsl:with-param name="schema" select="$schema"/>
     		<xsl:with-param name="edit"   select="$edit"/>
     		<xsl:with-param name="embedded" select="$embedded" />
    	</xsl:apply-templates>
		</xsl:variable>

		<xsl:choose>

			<!-- if we got a match in profile mode then show it -->
			<xsl:when test="count($iso19115-2.wmo-1.3Elements/*)>0">
				<xsl:copy-of select="$iso19115-2.wmo-1.3Elements"/>
			</xsl:when>

			<!-- if we got a match in 19115-2 mode then show it -->
			<xsl:when test="count($iso19115-2Elements/*)>0">
				<xsl:copy-of select="$iso19115-2Elements"/>
			</xsl:when>

			<!-- otherwise process in base iso19139 mode -->
			<xsl:otherwise>	
    		<xsl:apply-templates mode="iso19139" select="." >
     			<xsl:with-param name="schema" select="$schema"/>
     			<xsl:with-param name="edit"   select="$edit"/>
     			<xsl:with-param name="embedded" select="$embedded" />
    		</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>
  </xsl:template>

	<!-- CompleteTab template - iso19115-2.wmo-1.3 has its own set of tabs -->
	<xsl:template name="iso19115-2.wmo-1.3CompleteTab">
		<xsl:param name="tabLink"/>
		<xsl:param name="schema"/>

		<xsl:call-template name="iso19139CompleteTab">
      <xsl:with-param name="tabLink" select="$tabLink"/>
      <xsl:with-param name="schema" select="$schema"/>
    </xsl:call-template>

	</xsl:template>

	<!-- ================================================================== -->
	<!-- Callbacks from metadata-iso19139.xsl to add wmo specific content   -->
	<!-- ================================================================== -->

	<xsl:template name="iso19115-2.wmo-1.3-brief">
		<!-- TODO: Add support for wmo specific stuff -->
	</xsl:template>

	<!-- ==================================================================== -->
  <!-- === iso19115-2 brief formatting === -->
  <!-- ==================================================================== -->

	<xsl:template name="iso19115-2.wmo-1.3Brief">
		<metadata>
				<!-- call iso19139 brief -->
	 			<xsl:call-template name="iso19139-brief"/>
				<!-- now brief elements for 19115-2 specific elements -->
				<xsl:call-template name="iso19115-2-brief"/>
		</metadata>
	</xsl:template>

	<!-- match everything else and do nothing - leave that to iso19115-2 and iso19139 mode -->
	<xsl:template mode="iso19115-2.wmo-1.3" match="*|@*"/> 

	<!-- ==================================================================== -->
  <!-- === Javascript used by functions in this presentation XSLT -->
  <!-- ==================================================================== -->

	<!-- Javascript used by functions in this XSLT -->
	<xsl:template name="iso19115-2.wmo-1.3-javascript">
		<script type="text/javascript">
		</script>
	</xsl:template>
</xsl:stylesheet>
