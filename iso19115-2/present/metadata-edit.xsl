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
  <xsl:template match="metadata-iso19115-2" name="metadata-iso19115-2">
    <xsl:param name="schema"/>
    <xsl:param name="edit" select="false()"/>
    <xsl:param name="embedded"/>


		<!-- process in profile mode first -->
		<xsl:variable name="iso19115-2Elements">
    	<xsl:apply-templates mode="iso19115-2" select="." >
     		<xsl:with-param name="schema" select="$schema"/>
     		<xsl:with-param name="edit"   select="$edit"/>
     		<xsl:with-param name="embedded" select="$embedded" />
    	</xsl:apply-templates>
		</xsl:variable>

		<xsl:choose>

			<!-- if we got a match in profile mode then show it -->
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

	<!-- CompleteTab template - iso19115-2 has its own set of tabs -->
	<xsl:template name="iso19115-2CompleteTab">
		<xsl:param name="tabLink"/>
		<xsl:param name="schema"/>

		<xsl:call-template name="iso19139CompleteTab">
      <xsl:with-param name="tabLink" select="$tabLink"/>
      <xsl:with-param name="schema" select="$schema"/>
    </xsl:call-template>

	</xsl:template>

	<!-- ==================================================================== -->
	<!-- gmi gco: elements -->
	<!-- ==================================================================== -->

	<xsl:template mode="iso19139" match="gmi:*[gco:CharacterString|gco:Date|gco:DateTime|gco:Integer|gco:Decimal|gco:Boolean|gco:Real|gco:Measure|gco:Length|gco:Distance|gco:Angle|gco:Scale|gco:RecordType]">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>
		
		<xsl:call-template name="iso19139String">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template mode="iso19139" match="gmi:*[geonet:child/@prefix='gco']">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>
		
		<xsl:call-template name="iso19139String">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:call-template>
	</xsl:template>

	<!-- ================================================================= -->
	<!-- 19115-2 codelists -->
	<!-- ================================================================= -->

	<xsl:template mode="iso19115-2" match="*[*/@codeList and name(.)!='gmd:country' and name()!='gmd:language' and name()!='gmd:languageCode']">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>

		<xsl:call-template name="iso19139Codelist19115-2">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
		</xsl:call-template>
	</xsl:template>

	<!-- ================================================================= -->

	<xsl:template name="iso19139Codelist19115-2">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>
		
		<xsl:apply-templates mode="simpleElement" select=".">
			<xsl:with-param name="schema" select="$schema"/>
			<xsl:with-param name="edit"   select="$edit"/>
			<xsl:with-param name="text">
				<xsl:apply-templates mode="iso19139GetAttributeText19115-2" select="*/@codeListValue">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
			</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>
	
	<!-- ============================================================================= -->

	<xsl:template mode="iso19139GetAttributeText19115-2" match="@*">
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
					Get codelist from profil first and use use default one if not
					available.
				-->
				<xsl:variable name="codelistProfil">
					<xsl:choose>
						<xsl:when test="starts-with($schema,'iso19115-2.')">
							<xsl:copy-of
								select="/root/gui/schemas/*[name(.)=$schema]/codelists/codelist[@name = $qname]/*" />
						</xsl:when>
						<xsl:otherwise />
					</xsl:choose>
				</xsl:variable>

				<xsl:variable name="codelistCore">
					<xsl:choose>
						<xsl:when test="normalize-space($codelistProfil)!=''">
							<xsl:copy-of select="$codelistProfil" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:copy-of
								select="/root/gui/schemas/*[name(.)='iso19115-2']/codelists/codelist[@name = $qname]/*" />
						</xsl:otherwise>
					</xsl:choose>
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

	<!-- ================================================================== -->
	<!-- Callbacks from metadata-iso19139.xsl to add mcp specific content   -->
	<!-- ================================================================== -->

<!-- mcp extensions in gmd:MD_Metadata need to be added to brief template -->

	<xsl:template name="iso19115-2-brief">
		<!-- TODO: Add support for gmi: stuff -->
	</xsl:template>

	<!-- ==================================================================== -->
	<!-- gmi:MI_Metadata -->
	<!-- ==================================================================== -->

	<xsl:template mode="iso19115-2" match="gmi:MI_Metadata">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>
		<xsl:param name="embedded" select="false()"/>

		<xsl:variable name="dataset" select="gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue='dataset'  or gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue='dataObject'	or normalize-space(gmd:hierarchyLevel/gmd:MD_ScopeCode/@codeListValue)=''"/>

		<xsl:choose>
			<!-- simple tab -->
			<xsl:when test="$currTab='simple'">
        <xsl:call-template name="iso19139Simple">
          <xsl:with-param name="schema" select="$schema"/>
          <xsl:with-param name="edit"   select="$edit"/>
        </xsl:call-template>
			</xsl:when>

			<!-- metadata tab -->
			<xsl:when test="$currTab='metadata'">
				<xsl:call-template name="iso19115-2Metadata">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:call-template>
			</xsl:when>

			<!-- identification tab -->
			<xsl:when test="$currTab='identification'">
				<xsl:apply-templates mode="elementEP" select="gmd:identificationInfo|geonet:child[string(@name)='identificationInfo']">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
				
			</xsl:when>

			<!-- maintenance tab -->
			<xsl:when test="$currTab='maintenance'">
				<xsl:apply-templates mode="elementEP" select="gmd:metadataMaintenance|geonet:child[string(@name)='metadataMaintenance']">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
			</xsl:when>

			<!-- constraints tab -->
			<xsl:when test="$currTab='constraints'">
				<xsl:apply-templates mode="elementEP" select="gmd:metadataConstraints|geonet:child[string(@name)='metadataConstraints']">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
			</xsl:when>

			<!-- spatial tab -->
			<xsl:when test="$currTab='spatial'">
				<xsl:apply-templates mode="elementEP" select="gmd:spatialRepresentationInfo|geonet:child[string(@name)='spatialRepresentationInfo']">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
			</xsl:when>

			<!-- refSys tab -->
			<xsl:when test="$currTab='refSys'">
				<xsl:apply-templates mode="elementEP" select="gmd:referenceSystemInfo|geonet:child[string(@name)='referenceSystemInfo']">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
			</xsl:when>

			<!-- distribution tab -->
			<xsl:when test="$currTab='distribution'">
				<xsl:apply-templates mode="elementEP" select="gmd:distributionInfo|geonet:child[string(@name)='distributionInfo']">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
			</xsl:when>

			<!-- embedded distribution tab -->
			<xsl:when test="$currTab='distribution2'">
				<xsl:apply-templates mode="elementEP" select="gmd:distributionInfo/gmd:MD_Distribution/gmd:transferOptions/gmd:MD_DigitalTransferOptions">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
			</xsl:when>
			
			<!-- dataQuality tab -->
			<xsl:when test="$currTab='dataQuality'">
				<xsl:apply-templates mode="elementEP" select="gmd:dataQualityInfo|geonet:child[string(@name)='dataQualityInfo']">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
			</xsl:when>

			<!-- temporalExtent tab -->
			<xsl:when test="$currTab='temporalExtent'">
				<xsl:apply-templates mode="elementEP" select="gmd:identificationInfo/*/gmd:extent/*/gmd:temporalElement|gmd:identificationInfo/*/gmd:extent/*/geonet:child[string(@name)='temporalElement']">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
			</xsl:when>
			
			<!-- spatialExtent tab -->
			<xsl:when test="$currTab='spatialExtent'">
				<xsl:apply-templates mode="elementEP" select="gmd:identificationInfo/*/gmd:extent/*/gmd:geographicElement|gmd:identificationInfo/*/gmd:extent/*/geonet:child[string(@name)='geographicElement']">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
			</xsl:when>
			
			<!-- appSchInfo tab -->
			<xsl:when test="$currTab='appSchInfo'">
				<xsl:apply-templates mode="elementEP" select="gmd:applicationSchemaInfo|geonet:child[string(@name)='applicationSchemaInfo']">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
			</xsl:when>

			<!-- porCatInfo tab -->
			<xsl:when test="$currTab='porCatInfo'">
				<xsl:apply-templates mode="elementEP" select="gmd:portrayalCatalogueInfo|geonet:child[string(@name)='portrayalCatalogueInfo']">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
			</xsl:when>

			<!-- contentInfo tab -->
      <xsl:when test="$currTab='contentInfo'">
        <xsl:apply-templates mode="elementEP" select="gmd:contentInfo|geonet:child[string(@name)='contentInfo']">
          <xsl:with-param name="schema" select="$schema"/>
          <xsl:with-param name="edit"   select="$edit"/>
        </xsl:apply-templates>
      </xsl:when>

      <!-- extensionInfo tab -->
      <xsl:when test="$currTab='extensionInfo'">
        <xsl:apply-templates mode="elementEP" select="gmd:metadataExtensionInfo|geonet:child[string(@name)='metadataExtensionInfo']">
          <xsl:with-param name="schema" select="$schema"/>
          <xsl:with-param name="edit"   select="$edit"/>
        </xsl:apply-templates>
      </xsl:when>

			<!-- default - display everything - usually just tab="complete" -->
			<xsl:otherwise>
			
				<xsl:call-template name="iso19139Complete">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
					<xsl:with-param name="dataset" select="$dataset"/>
				</xsl:call-template>

				<!-- gmi:acquisitionInformation is the only element added gmi:MI_Metadata -->

				<xsl:apply-templates mode="elementEP" select="gmi:acquisitionInformation|geonet:child[string(@name)='acquisitionInformation']">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
				
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- ============================================================================= -->

  <xsl:template name="iso19115-2Metadata">
    <xsl:param name="schema"/>
    <xsl:param name="edit"/>
  	
  	<xsl:variable name="ref" select="concat('#_',geonet:element/@ref)"/>  	
  	<xsl:variable name="validationLink">
  		<xsl:call-template name="validationLink">
  			<xsl:with-param name="ref" select="$ref"/>
  		</xsl:call-template>  		
  	</xsl:variable>
  	
  	<xsl:call-template name="complexElementGui">
  		<xsl:with-param name="title" select="/root/gui/strings/metadata"/>
  		<xsl:with-param name="validationLink" select="$validationLink"/>
  		<xsl:with-param name="edit" select="true()"/>
  		<xsl:with-param name="content">
  	
			<!-- if the parent is root then display fields not in tabs -->
				<xsl:choose>
	    		<xsl:when test="name(..)='root'">
			    <xsl:apply-templates mode="elementEP" select="gmd:fileIdentifier|geonet:child[string(@name)='fileIdentifier']">
		      	<xsl:with-param name="schema" select="$schema"/>
		      	<xsl:with-param name="edit"   select="$edit"/>
		    	</xsl:apply-templates>
		
		    	<xsl:apply-templates mode="elementEP" select="gmd:language|geonet:child[string(@name)='language']">
		      	<xsl:with-param name="schema" select="$schema"/>
		      	<xsl:with-param name="edit"   select="$edit"/>
		    	</xsl:apply-templates>
		
		    	<xsl:apply-templates mode="elementEP" select="gmd:characterSet|geonet:child[string(@name)='characterSet']">
		      	<xsl:with-param name="schema" select="$schema"/>
		      	<xsl:with-param name="edit"   select="$edit"/>
		    	</xsl:apply-templates>
		
		    	<xsl:apply-templates mode="elementEP" select="gmd:parentIdentifier|geonet:child[string(@name)='parentIdentifier']">
		      	<xsl:with-param name="schema" select="$schema"/>
		      	<xsl:with-param name="edit"   select="$edit"/>
		    	</xsl:apply-templates>
		
		    	<xsl:apply-templates mode="elementEP" select="gmd:hierarchyLevel|geonet:child[string(@name)='hierarchyLevel']">
		      	<xsl:with-param name="schema" select="$schema"/>
		      	<xsl:with-param name="edit"   select="$edit"/>
		    	</xsl:apply-templates>
		
		    	<xsl:apply-templates mode="elementEP" select="gmd:hierarchyLevelName|geonet:child[string(@name)='hierarchyLevelName']">
		      	<xsl:with-param name="schema" select="$schema"/>
		      	<xsl:with-param name="edit"   select="$edit"/>
		    	</xsl:apply-templates>
		
		    	<xsl:apply-templates mode="elementEP" select="gmd:dateStamp|geonet:child[string(@name)='dateStamp']">
		      	<xsl:with-param name="schema" select="$schema"/>
		      	<xsl:with-param name="edit"   select="$edit"/>
		    	</xsl:apply-templates>
		
					<xsl:apply-templates mode="elementEP" select="gmd:metadataStandardName|geonet:child[string(@name)='metadataStandardName']">
		      	<xsl:with-param name="schema" select="$schema"/>
		      	<xsl:with-param name="edit"   select="$edit"/>
		    	</xsl:apply-templates>
		
		    	<xsl:apply-templates mode="elementEP" select="gmd:metadataStandardVersion|geonet:child[string(@name)='metadataStandardVersion']">
		      	<xsl:with-param name="schema" select="$schema"/>
		      	<xsl:with-param name="edit"   select="$edit"/>
		    	</xsl:apply-templates>
	
		    	<xsl:apply-templates mode="elementEP" select="gmd:contact|geonet:child[string(@name)='contact']">
		      	<xsl:with-param name="schema" select="$schema"/>
		      	<xsl:with-param name="edit"   select="$edit"/>
		    	</xsl:apply-templates>
		
		    	<xsl:apply-templates mode="elementEP" select="gmd:dataSetURI|geonet:child[string(@name)='dataSetURI']">
		      	<xsl:with-param name="schema" select="$schema"/>
		      	<xsl:with-param name="edit"   select="$edit"/>
		    	</xsl:apply-templates>
		
		    	<xsl:apply-templates mode="elementEP" select="gmd:locale|geonet:child[string(@name)='locale']">
		      	<xsl:with-param name="schema" select="$schema"/>
		      	<xsl:with-param name="edit"   select="$edit"/>
		    	</xsl:apply-templates>
		
		    	<xsl:apply-templates mode="elementEP" select="gmd:series|geonet:child[string(@name)='series']">
		      	<xsl:with-param name="schema" select="$schema"/>
		      	<xsl:with-param name="edit"   select="$edit"/>
		    	</xsl:apply-templates>
		
		    	<xsl:apply-templates mode="elementEP" select="gmd:describes|geonet:child[string(@name)='describes']">
		      	<xsl:with-param name="schema" select="$schema"/>
		      	<xsl:with-param name="edit"   select="$edit"/>
		    	</xsl:apply-templates>
		
		    	<xsl:apply-templates mode="elementEP" select="gmd:propertyType|geonet:child[string(@name)='propertyType']">
		      	<xsl:with-param name="schema" select="$schema"/>
		      	<xsl:with-param name="edit"   select="$edit"/>
		    	</xsl:apply-templates>
		
				<xsl:apply-templates mode="elementEP" select="gmd:featureType|geonet:child[string(@name)='featureType']">
		      	<xsl:with-param name="schema" select="$schema"/>
		      	<xsl:with-param name="edit"   select="$edit"/>
		    	</xsl:apply-templates>
		
		    	<xsl:apply-templates mode="elementEP" select="gmd:featureAttribute|geonet:child[string(@name)='featureAttribute']">
		      	<xsl:with-param name="schema" select="$schema"/>
		      	<xsl:with-param name="edit"   select="$edit"/>
		    	</xsl:apply-templates>

		    	<xsl:apply-templates mode="elementEP" select="gmi:acquisitionInformation|geonet:child[string(@name)='acquisitionInformation']">
		      	<xsl:with-param name="schema" select="$schema"/>
		      	<xsl:with-param name="edit"   select="false()"/>
		    	</xsl:apply-templates>
			</xsl:when>
			<!-- otherwise, display everything because we have embedded MD_Metadata -->
			<xsl:otherwise>
				<xsl:apply-templates mode="elementEP" select="*">
					<xsl:with-param name="schema" select="$schema"/>
					<xsl:with-param name="edit"   select="$edit"/>
				</xsl:apply-templates>
			</xsl:otherwise>
			</xsl:choose>

  		</xsl:with-param>
  		<xsl:with-param name="schema" select="$schema"/>
  	</xsl:call-template>
  	
  </xsl:template>

	<!-- ================================================================== -->
	<!-- 19115-2 Online Resource space reduced when only one resource available -->
	<!-- ================================================================== -->

	<xsl:template mode="iso19115-2" match="gmd:distributionInfo">
		<xsl:param name="schema"/>
		<xsl:param name="edit"/>
		<xsl:param name="dataset"/>
		<xsl:param name="tab"/>
		<xsl:param name="core"/>

		<xsl:for-each select=".">
			<xsl:call-template name="complexElementGuiWrapper">
				<xsl:with-param name="title" select="/root/gui/schemas/iso19115-2/strings/distributionOnlineInfo"/>
				<xsl:with-param name="tab" select="$tab"/>
				<xsl:with-param name="content">

				<xsl:choose>
					<xsl:when test="$edit=true() or count(*/gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine)>1"> <!-- TODO: include 'more than one resource' test in if statement ticket:159 -->
						<xsl:for-each select=".">
							<xsl:apply-templates mode="elementEP" select="*/gmd:distributionFormat|*/geonet:child[string(@name)='distributionFormat']">
								<xsl:with-param name="schema" select="$schema"/>
								<xsl:with-param name="edit"   select="$edit"/>
							</xsl:apply-templates>
 
							<xsl:apply-templates mode="elementEP" select="*/gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine|*/gmd:transferOptions/gmd:MD_DigitalTransferOptions/geonet:child[string(@name)='onLine']">
								<xsl:with-param name="schema" select="$schema"/>
								<xsl:with-param name="edit"   select="$edit"/>
							</xsl:apply-templates>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<xsl:for-each select=".">
							<xsl:apply-templates mode="elementEP" select="*/gmd:distributionFormat|*/geonet:child[string(@name)='distributionFormat']">
								<xsl:with-param name="schema" select="$schema"/>
								<xsl:with-param name="edit"   select="$edit"/>
							</xsl:apply-templates>

							<xsl:apply-templates mode="element" select="*/gmd:transferOptions/gmd:MD_DigitalTransferOptions/gmd:onLine|*/gmd:transferOptions/gmd:MD_DigitalTransferOptions/geonet:child[string(@name)='onLine']">
								<xsl:with-param name="schema" select="$schema"/>
								<xsl:with-param name="edit"   select="$edit"/>
								<xsl:with-param name="flat"   select="true()"/>
							</xsl:apply-templates>							
						</xsl:for-each>
					</xsl:otherwise>
				</xsl:choose>
				
				</xsl:with-param>
				<xsl:with-param name="schema" select="$schema"/>
				<xsl:with-param name="group" select="/root/gui/strings/distributionTab"/>
				<xsl:with-param name="edit" select="$edit"/>
				<xsl:with-param name="realname"   select="'gmd:distributionInfo'"/>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>

	<!-- ==================================================================== -->
  <!-- === iso19115-2 brief formatting === -->
  <!-- ==================================================================== -->

	<xsl:template name="iso19115-2Brief">
		<metadata>
				<!-- call iso19139 brief -->
	 			<xsl:call-template name="iso19139-brief"/>
				<!-- now brief elements for 19115-2 specific elements -->
				<xsl:call-template name="iso19115-2-brief"/>
		</metadata>
	</xsl:template>

	<!-- match everything else and do nothing - leave that to iso19139 mode -->
	<xsl:template mode="iso19115-2" match="*|@*"/> 

	<!-- ==================================================================== -->
  <!-- === Javascript used by functions in this presentation XSLT -->
  <!-- ==================================================================== -->

	<!-- Javascript used by functions in this XSLT -->
	<xsl:template name="iso19115-2-javascript">
		<script type="text/javascript">
		</script>
	</xsl:template>
</xsl:stylesheet>
