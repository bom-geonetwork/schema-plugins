<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:gts="http://www.isotc211.org/2005/gts"
  xmlns:gco="http://www.isotc211.org/2005/gco" xmlns:gmx="http://www.isotc211.org/2005/gmx"
  xmlns:srv="http://www.isotc211.org/2005/srv" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:gml32="http://www.opengis.net/gml/3.2" xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:geonet="http://www.fao.org/geonetwork" xmlns:exslt="http://exslt.org/common"
  xmlns:gmi="http://www.isotc211.org/2005/gmi"
  xmlns:saxon="http://saxon.sf.net/" extension-element-prefixes="saxon"
  exclude-result-prefixes="gmi gmx xsi gmd gco gml32 gts srv xlink exslt geonet">

	<!-- TODO: Add support for gmi: elements -->

  <!-- View templates are available only in view mode and do not provide 
	     editing capabilities. -->
  <!-- ===================================================================== -->
  <xsl:template name="view-with-header-iso19115-2.wmo-1.3">
		<xsl:param name="tabs"/>

    <xsl:call-template name="md-content">
      <xsl:with-param name="title">
        <xsl:apply-templates mode="localised"
          select="gmd:identificationInfo/*/gmd:citation/*/gmd:title">
          <xsl:with-param name="langId" select="$langId"/>
        </xsl:apply-templates>
      </xsl:with-param>
      <xsl:with-param name="exportButton"/>
      <xsl:with-param name="abstract">
        <xsl:apply-templates mode="localised" select="gmd:identificationInfo/*/gmd:abstract">
          <xsl:with-param name="langId" select="$langId"/>
        </xsl:apply-templates>
      </xsl:with-param>
      <xsl:with-param name="logo">
        <img src="../../images/logos/{//geonet:info/source}.gif" alt="logo"/>
      </xsl:with-param>
      <xsl:with-param name="relatedResources">
        <xsl:apply-templates mode="relatedResources" select="gmd:distributionInfo"
        />
      </xsl:with-param>
      <xsl:with-param name="tabs" select="$tabs"/>
		</xsl:call-template>

	</xsl:template>

  <!-- View templates are available only in view mode and do not provide 
	     editing capabilities. -->
  <!-- ===================================================================== -->
  <xsl:template name="metadata-iso19115-2.wmo-1.3view-simple" match="metadata-iso19115-2.wmo-1.3view-simple">
		<xsl:call-template name="view-with-header-iso19115-2.wmo-1.3">
			<xsl:with-param name="tabs">

        <xsl:call-template name="complexElementSimpleGui">
          <xsl:with-param name="title"
            select="/root/gui/schemas/iso19139/strings/understandResource"/>
          <xsl:with-param name="content">
            <xsl:apply-templates mode="block"
              select="
                gmd:identificationInfo/*/gmd:citation/*/gmd:date[1]
                |gmd:identificationInfo/*/gmd:language
								|gmd:identificationInfo/*/gmd:citation/*/gmd:edition
                |gmd:identificationInfo/*/gmd:topicCategory
                |gmd:identificationInfo/*/gmd:descriptiveKeywords
                |gmd:identificationInfo/*/gmd:graphicOverview[1]
                "> </xsl:apply-templates>
          </xsl:with-param>
        </xsl:call-template>


        <xsl:call-template name="complexElementSimpleGui">
          <xsl:with-param name="title" select="/root/gui/schemas/iso19139/strings/contactInfo"/>
          <xsl:with-param name="content">
            <xsl:apply-templates mode="block"
              select="gmd:identificationInfo/*/gmd:pointOfContact"/>
            <xsl:apply-templates mode="block"
              select="gmd:contact"/>
          </xsl:with-param>
        </xsl:call-template>

        <xsl:call-template name="complexElementSimpleGui">
          <xsl:with-param name="title" select="/root/gui/schemas/iso19139/strings/techInfo"/>
          <xsl:with-param name="content">
            <xsl:apply-templates mode="block"
              select="
              gmd:identificationInfo/*/gmd:spatialResolution/gmd:MD_Resolution
              |gmd:identificationInfo/*/gmd:resourceMaintenance
              |gmd:identificationInfo/*/gmd:spatialRepresentationType
              |gmd:dataQualityInfo/gmd:DQ_DataQuality/gmd:lineage/gmd:LI_Lineage/gmd:statement
              "
            > </xsl:apply-templates>
          </xsl:with-param>
        </xsl:call-template>


        <span class="madeBy">
          <xsl:value-of select="/root/gui/strings/changeDate"/><xsl:value-of select="string(gmd:dateStamp)"/>
        </span>

      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

</xsl:stylesheet>
