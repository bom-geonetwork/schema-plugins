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

	<!-- ==================================================================== -->
	<!-- Callbacks from metadata-iso19139.xsl to add wmo specific content -->
	<!-- ==================================================================== -->

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

	<!-- ==================================================================== -->
	<!-- codelists -->
	<!-- ==================================================================== -->

	<xsl:template mode="iso19115-2.wmo-1.3" match="gmd:*[*/@codeList]|srv:*[*/@codeList]">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>

		<xsl:call-template name="iso19115-2.wmo1-3Codelist">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:call-template>
	</xsl:template>


	<!-- ==================================================================== -->

	<xsl:template name="iso19115-2.wmo1-3Codelist">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>

		<xsl:apply-templates mode="simpleElement" select=".">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
			<xsl:with-param name="text">
				<xsl:apply-templates mode="iso19115-2.wmo-1.3GetAttributeText" select="*/@codeListValue">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>

	<!-- ==================================================================== -->

	<xsl:template mode="iso19115-2.wmo-1.3GetAttributeText" match="@*">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>

		<xsl:variable name="name"     select="local-name(..)"/>
		<xsl:variable name="qname"    select="name(..)"/>
		<xsl:variable name="value"    select="../@codeListValue"/>

		<xsl:choose>
			<xsl:when test="$qname='gmd:LanguageCode'">
				<xsl:apply-templates mode="iso19139" select="..">
					<xsl:with-param name="edit" select="$edit"/>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<!--
					Get codelists from profile, iso19115-2 and iso19139.
				-->

				<xsl:variable name="codelistCore">
					<xsl:copy-of select="/root/gui/schemas/*[name()=$schema]/codelists/codelist[@name = $qname]/*" />
					<xsl:copy-of select="/root/gui/schemas/iso19115-2/codelists/codelist[@name = $qname]/*" />
					<xsl:copy-of select="/root/gui/schemas/iso19139/codelists/codelist[@name = $qname]/*" />
				</xsl:variable>

				<xsl:variable name="codelist" select="exslt:node-set($codelistCore)" />
				<xsl:variable name="isXLinked" select="count(ancestor-or-self::node()[@xlink:href]) > 0" />

				<xsl:choose>
					<xsl:when test="$edit=true()">
						<!-- codelist in edit mode -->
						<select class="md" name="_{../geonet:element/@ref}_{name(.)}" id="_{../geonet:element/@ref}_{name(.)}" size="1">
							<!-- Check element is mandatory or not -->
							<xsl:if test="../../geonet:element/@min='1' and $edit">
								<xsl:attribute name="onchange">validateNonEmpty(this);</xsl:attribute>
							</xsl:if>
							<xsl:if test="$isXLinked">
								<xsl:attribute name="disabled">disabled</xsl:attribute>
							</xsl:if>
							<option name=""/>
							<xsl:for-each select="$codelist/entry[not(@hideInEditMode)]">
								<xsl:sort select="label"/>
								<option>
									<xsl:if test="code=$value">
										<xsl:attribute name="selected"/>
									</xsl:if>
									<xsl:attribute name="value"><xsl:value-of select="code"/></xsl:attribute>
									<xsl:value-of select="label"/>
								</option>
							</xsl:for-each>
						</select>
					</xsl:when>
					<xsl:otherwise>
						<!-- codelist in view mode -->
						<xsl:if test="normalize-space($value)!=''">
							<b><xsl:value-of select="$codelist/entry[code = $value]/label"/></b>
							<xsl:value-of select="concat(': ',$codelist/entry[code = $value]/description)"/>
						</xsl:if>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
		<!--
		<xsl:call-template name="getAttributeText">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:call-template>
		-->
	</xsl:template>

	<!-- ==================================================================== -->

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
