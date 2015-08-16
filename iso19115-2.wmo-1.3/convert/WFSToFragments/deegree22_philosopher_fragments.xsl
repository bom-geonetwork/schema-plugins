<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
		xmlns:app="http://www.deegree.org/app"
		xmlns:gco="http://www.isotc211.org/2005/gco"
		xmlns:gmd="http://www.isotc211.org/2005/gmd"
		xmlns:gml32="http://www.opengis.net/gml/3.2"
		xmlns:wfs="http://www.opengis.net/wfs"
		xmlns:xlink="http://www.w3.org/1999/xlink"
		xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"		
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" />

	<!-- 
			 This xslt should transform output from the WFS philosophers database
	     that you should install with deegree into fragments that can be linked 
			 into the template 'deegree fragments test template' by the WFS fragment 
			 harvester in GeoNetwork. 
	 -->

	<xsl:template match="wfs:FeatureCollection">
		<records>
			<xsl:if test="boolean( ./@timeStamp )">
				<xsl:attribute name="timeStamp">
					<xsl:value-of select="./@timeStamp"></xsl:value-of>
				</xsl:attribute>
			</xsl:if>
			<xsl:if test="boolean( ./@lockId )">
				<xsl:attribute name="lockId">
					<xsl:value-of select="./@lockId"></xsl:value-of>
				</xsl:attribute>
			</xsl:if>

			<xsl:apply-templates select="gml32:featureMember"/>
		</records>
	</xsl:template>

	<xsl:template match="*[@xlink:href]" priority="20">
		<xsl:variable name="linkid" select="substring-after(@xlink:href,'#')"/>
		<xsl:apply-templates select="//*[@gml32:id=$linkid]"/>
	</xsl:template>

	<xsl:template match="gml32:featureMember">
		<xsl:apply-templates select="app:Philosopher"/>
	</xsl:template>

	<xsl:template match="app:Philosopher">
		<record>

			<!-- boundingBox -->

			<fragment id="boundingbox" uuid="{@gml32:id}_boundingbox" title="{concat(app:name,':',app:id)}">
				<gmd:EX_Extent>
					<gmd:geographicElement>
						<gmd:EX_GeographicBoundingBox>
							<gmd:westBoundLongitude>
								<gco:Decimal><xsl:value-of select="substring-before(gml32:boundedBy/gml32:Envelope/gml32:pos[1],' ')"/></gco:Decimal>
							</gmd:westBoundLongitude>
							<gmd:eastBoundLongitude>
								<gco:Decimal><xsl:value-of select="substring-after(gml32:boundedBy/gml32:Envelope/gml32:pos[1],' ')"/></gco:Decimal>
							</gmd:eastBoundLongitude>
							<gmd:southBoundLatitude>
								<gco:Decimal><xsl:value-of select="substring-before(gml32:boundedBy/gml32:Envelope/gml32:pos[2],' ')"/></gco:Decimal>
							</gmd:southBoundLatitude>
							<gmd:northBoundLatitude>
								<gco:Decimal><xsl:value-of select="substring-after(gml32:boundedBy/gml32:Envelope/gml32:pos[2],' ')"/></gco:Decimal>
							</gmd:northBoundLatitude>
						</gmd:EX_GeographicBoundingBox>
					</gmd:geographicElement>
				</gmd:EX_Extent>	
			</fragment>

			<!-- pointOfContact -->

			<fragment id="contactinfo" uuid="{@gml32:id}_contactinfo" title="{concat(app:name,':',app:id,':contactinfo')}">
				<gmd:CI_ResponsibleParty>
   				<gmd:individualName>
     				<gco:CharacterString>Dr Charlie Brown</gco:CharacterString>
   				</gmd:individualName>
   				<gmd:organisationName>
     				<gco:CharacterString>Silicon Graphics R4400 64bit Systems and Philosophy Management Section</gco:CharacterString>
   				</gmd:organisationName>
    			<gmd:positionName>
       			<gco:CharacterString>Part-time Chief Philosopher</gco:CharacterString>
    			</gmd:positionName>
    			<gmd:role>
       			<gmd:CI_RoleCode codeList="http://www.isotc211.org/2005/resources/Codelist/gmxCodelists.xml#CI_RoleCode" codeListValue="pointOfContact"/>
    			</gmd:role> 	
				</gmd:CI_ResponsibleParty>
			</fragment>

			<!-- keywords -->

			<fragment id="keywords" uuid="{@gml32:id}_keywords" title="{concat(app:name,':',app:id,':keywords')}">
				<gmd:descriptiveKeywords>
					<gmd:MD_Keywords>
						<xsl:for-each select="app:subject">
							<gmd:keyword>
								<gco:CharacterString><xsl:value-of select="."/></gco:CharacterString>
							</gmd:keyword>
						</xsl:for-each>
						<gmd:keyword>
							<gco:CharacterString>Philosophy</gco:CharacterString>
						</gmd:keyword>
						<gmd:type>
							<gmd:MD_KeywordTypeCode codeList="http://www.isotc211.org/2005/resources/Codelist/gmxCodelists.xml#MD_KeywordTypeCode" codeListValue="theme"/>
						</gmd:type>
					</gmd:MD_Keywords>
				</gmd:descriptiveKeywords>
			</fragment>

			<!-- citation -->

			<fragment id="citation" uuid="{@gml32:id}_citation" title="{concat(app:name,':',app:id,':citation')}">
				<gmd:CI_Citation>
					<gmd:title>
						<gco:CharacterString>Information about the Philosopher <xsl:value-of select="app:name"/></gco:CharacterString>
					</gmd:title>
					<gmd:date>
						<gmd:CI_Date>
							<gmd:date>
								<gco:Date>
									<xsl:choose>
										<xsl:when test="boolean(//wfs:FeatureCollection/@timeStamp)">
											<xsl:value-of select="//wfs:FeatureCollection/@timeStamp"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:text>2009-05-24</xsl:text>
										</xsl:otherwise>
									</xsl:choose>
								</gco:Date>
							</gmd:date>
							<gmd:dateType>
								<gmd:CI_DateTypeCode codeList="http://www.isotc211.org/2005/resources/Codelist/gmxCodelists.xml#CI_DateTypeCode" codeListValue="publication"/>
							</gmd:dateType>
						</gmd:CI_Date>
					</gmd:date>
					<!-- xlink to contactinfo fragment defined above -->
					<gmd:citedResponsibleParty xlink:href="#{@gml32:id}_contactinfo"/>
				</gmd:CI_Citation>
			</fragment>

			<!-- abstract -->

			<fragment id="abstract" uuid="{@gml32:id}_abstract" title="{concat(app:name,':',app:id,':abstract')}">
				<gmd:abstract>
					<gco:CharacterString>
						Metadata about the Philosopher <xsl:value-of select="app:name"/>
						&#160;
						Sex: <xsl:value-of select="app:sex"/>
						&#160;
						<xsl:for-each select="app:isAuthorOf">
							Is the author of: <xsl:value-of select="app:Book/app:title"/>
							&#160;
						</xsl:for-each>
					</gco:CharacterString>
				</gmd:abstract>
			</fragment>

			<!-- temporal extent = lifespan -->

			<fragment id="tempextent" uuid="{@gml32:id}_tempextent" title="{concat(app:name,':',app:id,':tempextent')}">
				<gmd:temporalElement>
					<gmd:EX_TemporalExtent>
						<gmd:extent>
							<gml32:TimePeriod gml32:id="">
								<gml32:beginPosition><xsl:value-of select="app:dateOfBirth"/></gml32:beginPosition>
								<gml32:endPosition><xsl:value-of select="app:dateOfDeath"/></gml32:endPosition>
							</gml32:TimePeriod>
						</gmd:extent>
					</gmd:EX_TemporalExtent>
				</gmd:temporalElement>
			</fragment>

		</record>
	</xsl:template>


</xsl:stylesheet>
