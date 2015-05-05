<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:gmi="http://www.isotc211.org/2005/gmi" xmlns:gco="http://www.isotc211.org/2005/gco"
    xmlns:gmd="http://www.isotc211.org/2005/gmd" version="2.0">
    <xsl:import href="../iso19139/update-fixed-info.xsl"/>


    <!-- Take priority over iso19139 -->
    <xsl:template match="/root" priority="2">
        <xsl:apply-templates select="gmi:MI_Metadata"/>
    </xsl:template>

    <xsl:template match="gmi:MI_Metadata" priority="2">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>

            <gmd:fileIdentifier>
                <gco:CharacterString>
                    <xsl:value-of select="/root/env/uuid"/>
                </gco:CharacterString>
            </gmd:fileIdentifier>

            <xsl:apply-templates select="gmd:language"/>
            <xsl:apply-templates select="gmd:characterSet"/>

            <xsl:choose>
                <xsl:when test="/root/env/parentUuid!=''">
                    <gmd:parentIdentifier>
                        <gco:CharacterString>
                            <xsl:value-of select="/root/env/parentUuid"/>
                        </gco:CharacterString>
                    </gmd:parentIdentifier>
                </xsl:when>
                <xsl:when test="gmd:parentIdentifier">
                    <xsl:copy-of select="gmd:parentIdentifier"/>
                </xsl:when>
            </xsl:choose>
            <xsl:apply-templates
                select="node()[not(self::gmd:language) and not(self::gmd:characterSet)]"/>
        </xsl:copy>
    </xsl:template>

		<!-- ================================================================= -->
		<!-- Do not process any elements produced by previous template  -->

		<xsl:template match="gmi:MI_Metadata/gmd:fileIdentifier|gmi:MI_Metadata/gmd:parentIdentifier" priority="10"/>

		<!-- ================================================================= -->

		<!-- Only set metadataStandardName and metadataStandardVersion if not set. -->
		<xsl:template match="gmd:metadataStandardName[@gco:nilReason='missing' or gco:CharacterString='']" priority="20">
			<xsl:copy>
				<gco:CharacterString>ISO 19115-2:2008/19139</gco:CharacterString>
			</xsl:copy>
		</xsl:template>

		<xsl:template match="gmd:metadataStandardVersion[@gco:nilReason='missing' or gco:CharacterString='']" priority="20">
			<xsl:copy>
				<gco:CharacterString>1.0</gco:CharacterString>
			</xsl:copy>
		</xsl:template>

</xsl:stylesheet>
