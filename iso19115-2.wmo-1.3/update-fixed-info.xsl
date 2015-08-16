<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:gmi="http://www.isotc211.org/2005/gmi" xmlns:gco="http://www.isotc211.org/2005/gco"
    xmlns:gmd="http://www.isotc211.org/2005/gmd" version="2.0">
    <xsl:import href="../iso19139/update-fixed-info.xsl"/>


    <!-- Take priority over iso19139 -->
    <xsl:template match="/root" priority="2">
        <xsl:apply-templates select="gmi:MI_Metadata|gmd:MD_Metadata"/>
    </xsl:template>

		<!-- Note we assume siteId is the prefix plus internet domain name of the data-provider
				 organisation as per wmo 1.3 specification pg 8 eg. for au.gov.bom.www 
         urn:x-wmo:md:au.gov.bom.www:<uuid> -->
		<xsl:variable name="siteId" select="/root/env/config/site/siteId"/>

    <xsl:template match="gmi:MI_Metadata|gmd:MD_Metadata" priority="2">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>

						<xsl:variable name="fileId">
							<xsl:choose>
								<!-- no siteId defined -->
                <xsl:when test="not(ends-with($siteId, ':'))">
                    <xsl:message>INFO: siteId doesn't end with ':' so using plain uuid</xsl:message>
                    <xsl:value-of select="/root/env/uuid"/>
                </xsl:when>
                <!-- siteId defined, not ":" in code -->
                <!-- either first metadatacreation, or siteId just defined: prepend the siteId -->
                <xsl:when test="not(contains(/root/env/uuid, ':'))">
                    <xsl:message>INFO: creating fileIdentifier</xsl:message>
                    <xsl:value-of select="concat($siteId,/root/env/uuid)"/>
                </xsl:when>
                <!-- siteId defined, already present in code: OK, just copy it -->
                <xsl:when test="starts-with(/root/env/uuid, $siteId)">
                    <xsl:message>INFO: fileIdentifier OK</xsl:message>
                    <xsl:value-of select="/root/env/uuid"/>
                </xsl:when>
                <!-- siteId defined, different from the one in code -->
                <!-- probably not needed, but in case replace the siteId code -->
                <xsl:otherwise>
                    <xsl:message>ATTENTION: replacing part of fileIdentifier with siteId</xsl:message>
                    <xsl:value-of select="concat($siteId,substring-after(/root/env/uuid,':'))"/>
                </xsl:otherwise>	
							</xsl:choose>
						</xsl:variable>

            <gmd:fileIdentifier>
                <gco:CharacterString>
                    <xsl:value-of select="concat('urn:x-wmo:md:',$siteId,':',/root/env/uuid)"/>
                </gco:CharacterString>
            </gmd:fileIdentifier>

            <xsl:apply-templates select="gmd:language"/>
            <xsl:apply-templates select="gmd:characterSet"/>

						<!-- PARENT IDENTIFIER -->
            <xsl:if test="not(ends-with($siteId, ':'))">
                <xsl:message>ATTENTION: siteId is not defined correctly - wiping parentIdentifier</xsl:message>
                <gmd:parentIdentifier>
                    <gco:CharacterString></gco:CharacterString>
                </gmd:parentIdentifier>
            </xsl:if>
						<xsl:if test="ends-with($siteId, ':')">
            	<xsl:choose>
                <xsl:when test="/root/env/parentUuid!=''">
									<xsl:if test="starts-with(/root/env/parentUuid, $siteId)">
										<xsl:message>INFO: parentId OK</xsl:message>
                    <gmd:parentIdentifier>
                        <gco:CharacterString>
                            <xsl:value-of select="/root/env/parentUuid"/>
                        </gco:CharacterString>
                    </gmd:parentIdentifier>
									</xsl:if>
									<xsl:if test="not(starts-with(/root/env/parentUuid, $siteId))">
										<xsl:message>ATTENTION: parentId doesn't contain siteId. Wiping parentId</xsl:message>
                     <gmd:parentIdentifier>
                       <gco:CharacterString></gco:CharacterString>
                     </gmd:parentIdentifier>
                  </xsl:if>
                </xsl:when>
                <xsl:when test="gmd:parentIdentifier and starts-with(gmd:parentIdentifier/gco:CharacterString, $siteId)">
                    <xsl:copy-of select="gmd:parentIdentifier"/>
                </xsl:when>
								<xsl:otherwise>
									<xsl:message>ATTENTION: parentId doesn't contain siteId. Wiping parentId env[<xsl:value-of select="/root/env/parentUuid"/>] md[<xsl:value-of select="gmd:parentIdentifier/gco:CharacterString"/>]</xsl:message>
                  <gmd:parentIdentifier>
                    <gco:CharacterString></gco:CharacterString>
                  </gmd:parentIdentifier>
								</xsl:otherwise>
            	</xsl:choose>
						</xsl:if>
            <xsl:apply-templates
                select="node()[not(self::gmd:language) and not(self::gmd:characterSet)]"/>
        </xsl:copy>
    </xsl:template>

		<!-- ================================================================= -->
		<!-- Do not process any elements produced by previous template  -->

		<xsl:template match="gmi:MI_Metadata/gmd:fileIdentifier|gmi:MI_Metadata/gmd:parentIdentifier|gmd:MD_Metadata/gmd:fileIdentifier|gmd:MD_Metadata/gmd:parentIdentifier" priority="10"/>

		<!-- ================================================================= -->

		<!-- Set metadataStandardName and metadataStandardVersion as per wmo 1.3 Specification pg 7. -->
		<xsl:template match="gmd:metadataStandardName" priority="20">
			<xsl:copy>
				<gco:CharacterString>WMO Core Metadata Profile of ISO19115 (WMO Core), 2003/Cor.1:2006 (ISO 19115), 2007 (ISO/TS 19139)</gco:CharacterString>
			</xsl:copy>
		</xsl:template>

		<xsl:template match="gmd:metadataStandardVersion" priority="20">
			<xsl:copy>
				<gco:CharacterString>1.3</gco:CharacterString>
			</xsl:copy>
		</xsl:template>

</xsl:stylesheet>
