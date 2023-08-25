<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:mcrxml="xalan://org.mycore.common.xml.MCRXMLFunctions"
  xmlns:mods="http://www.loc.gov/mods/v3" 
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:math="http://exslt.org/math"
  xmlns:mcrdataurl="xalan://org.mycore.datamodel.common.MCRDataURL">
  
  <xsl:include href="copynodes.xsl" />
    
  <xsl:template match="mods:mods/mods:name/mods:nameIdentifier[starts-with(.,'(DE-601)')]">
  </xsl:template>
  
  <xsl:template match="mods:mods/mods:name/mods:nameIdentifier[starts-with(.,'(DE-588)')]">
    <xsl:variable name="gnd" select="substring-after(.,'(DE-588)')"/>
    <xsl:if test="not(../mods:nameIdentifier[@type='gnd'][text()=$gnd])">
      <mods:nameIdentifier type="gnd">
        <xsl:value-of select="$gnd" />
      </mods:nameIdentifier>
    </xsl:if>
  </xsl:template>
    
</xsl:stylesheet>