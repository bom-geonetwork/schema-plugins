<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:gmd="http://www.isotc211.org/2005/gmd"
  xmlns:gmi="http://www.isotc211.org/2005/gmi"
  xmlns:gco="http://www.isotc211.org/2005/gco"
  xmlns:srv="http://www.isotc211.org/2005/srv"
  xmlns:gmx="http://www.isotc211.org/2005/gmx"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:gml32="http://www.opengis.net/gml/3.2"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:gn="http://www.fao.org/geonetwork"
  xmlns:gn-fn-core="http://geonetwork-opensource.org/xsl/functions/core"
  xmlns:gn-fn-iso19139="http://geonetwork-opensource.org/xsl/functions/profiles/iso19139"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="2.0">

  <xsl:include href="utility-tpl.xsl"/>
  
  <!-- ===================================================================== -->
  <!-- === iso19115-2.wmo-1.3 brief formatting === -->
  <!-- ===================================================================== -->

  <xsl:template name="iso19115-2.wmo-1.3Brief">
    <metadata>
      <xsl:call-template name="iso19115-2-brief"/>
    </metadata>
  </xsl:template>

</xsl:stylesheet>
