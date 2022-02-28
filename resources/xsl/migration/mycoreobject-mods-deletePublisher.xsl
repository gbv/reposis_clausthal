<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:mcrxml="xalan://org.mycore.common.xml.MCRXMLFunctions"
  xmlns:mods="http://www.loc.gov/mods/v3" 
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:math="http://exslt.org/math"
  xmlns:mcrdataurl="xalan://org.mycore.datamodel.common.MCRDataURL">
  
  <xsl:include href="copynodes.xsl" />
    
  <xsl:template match="mods:mods/mods:originInfo[eventType='publication']/mods:place">
  </xsl:template>
  
  <xsl:template match="mods:mods/mods:originInfo[eventType='publication']/mods:publisher">
  </xsl:template>
    
</xsl:stylesheet>