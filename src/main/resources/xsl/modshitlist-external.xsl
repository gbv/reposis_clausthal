<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xalan"
  xmlns:i18n="xalan://org.mycore.services.i18n.MCRTranslation" xmlns:mcrmods="xalan://org.mycore.mods.MCRMODSClassificationSupport"
  xmlns:acl="xalan://org.mycore.access.MCRAccessManager" xmlns:mcr="http://www.mycore.org/" xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:mods="http://www.loc.gov/mods/v3" exclude-result-prefixes="xlink xalan mcr i18n acl mods mcrmods" version="1.0">

  <!--Template for result list hit: see results.xsl -->
  <xsl:template match="mcr:hit[contains(@id,'_mods_')]" priority="2">
    <xsl:param name="mcrobj" />
    <xsl:param name="mcrobjlink" />
    <xsl:variable select="100" name="DESCRIPTION_LENGTH" />
    <xsl:variable select="@host" name="host" />
    <xsl:variable name="obj_id">
      <xsl:value-of select="@id" />
    </xsl:variable>

    <xsl:variable name="mods-type">
      <xsl:choose>
        <xsl:when test="$mcrobj/metadata/def.modsContainer/modsContainer/mods:mods/mods:genre[@type='kindof']">
          <xsl:value-of select="substring-after($mcrobj/metadata/def.modsContainer/modsContainer/mods:mods/mods:genre[@type='kindof']/@valueURI,'#')" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates mode="mods-type" select="$mcrobj" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <div class="hit_symbol floatbox">
      <img src="{$WebApplicationBaseURL}templates/master/{$template}/IMAGES/icons_liste/icon_{$mods-type}.png" alt="{$mods-type}" />
    </div>
    <h3>
      <xsl:call-template name="objectLink">
        <xsl:with-param select="$mcrobj" name="mcrobj" />
      </xsl:call-template>
    </h3>
    <div class="hitListDetails">
      <div class="author">
    <!-- Author -->
        <xsl:for-each select="$mcrobj/metadata/def.modsContainer/modsContainer/mods:mods/mods:name[mods:role/mods:roleTerm/text()='aut']">
          <xsl:if test="position()!=1">
            <xsl:value-of select="'; '" />
          </xsl:if>
          <xsl:apply-templates select="." mode="printName" />
        </xsl:for-each>
      </div>
    <!-- Source -->
      <xsl:if test="$mcrobj/structure/parents">
        <div class="source">
          <xsl:text>aus: </xsl:text>
            <xsl:call-template name="objectLink">
              <xsl:with-param select="$mcrobj/structure/parents/parent/@xlink:href" name="obj_id" />
            </xsl:call-template>
        </div>
      </xsl:if>
    </div>

  <!-- hit info -->
    <div class="hitListInfo">
      <xsl:variable name="basketStyle">
        <xsl:choose>
          <xsl:when test="$mcrobj/metadata/def.modsContainer/modsContainer/mods:mods//mods:originInfo/mods:dateIssued">
            <xsl:text>basket bborder</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>basket</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="basketType" select="'objects'" />
      <div class="{$basketStyle}">
        <a class="addToBasket"
           href="{$ServletsBaseURL}MCRBasketServlet{$HttpSession}?type={$basketType}&amp;action=add&amp;id={$mcrobj/@ID}&amp;uri=mcrobject:{$mcrobj/@ID}&amp;redirect=referer">
            <xsl:value-of select="i18n:translate('basket.add')" />
        </a>
      </div>
      <xsl:if test="$mcrobj/metadata/def.modsContainer/modsContainer/mods:mods//mods:originInfo/mods:dateIssued">
        <div class="published">
          <xsl:variable name="date">
            <xsl:value-of select="$mcrobj/metadata/def.modsContainer/modsContainer/mods:mods//mods:originInfo/mods:dateIssued" />
          </xsl:variable>
          <xsl:value-of select="concat(i18n:translate('component.mods.metaData.dictionary.dateIssued'),': ',$date)" />
        </div>
      </xsl:if>
    </div>
  </xsl:template>


  <!--Template for title in metadata view: see mycoreobject.xsl -->
  <xsl:template priority="2" mode="fulltitle" match="/mycoreobject[contains(@ID,'_mods_')]">
    <xsl:value-of select="./metadata/def.modsContainer/modsContainer/mods:mods/mods:titleInfo/mods:title[1]" />
  </xsl:template>

  <!--Template for printlatestobjects: see mycoreobject.xsl, results.xsl, MyCoReLayout.xsl -->
  <xsl:template priority="2" mode="latestObjects" match="mcr:hit[contains(@id,'_mods_')]">
    <xsl:param name="mcrobj" />
    <div class="hit_item">
      <h3>
        <xsl:call-template name="objectLink">
          <xsl:with-param select="$mcrobj" name="mcrobj" />
        </xsl:call-template>
      </h3>

      <xsl:if test="$mcrobj/metadata/def.modsContainer/modsContainer/mods:mods//mods:originInfo/mods:dateIssued">
        <div class="created">
          <xsl:variable name="date">
            <xsl:call-template name="formatISODate">
              <xsl:with-param select="$mcrobj/metadata/def.modsContainer/modsContainer/mods:mods//mods:originInfo/mods:dateIssued"
                name="date" />
            </xsl:call-template>
          </xsl:variable>
        <!-- xsl:value-of select="i18n:translate('results.lastChanged',$date)" / -->
          <xsl:value-of select="$date" />
        </div>
      </xsl:if>

    <!-- Authors -->
      <div class="author">
        <xsl:for-each
          select="$mcrobj/metadata/def.modsContainer/modsContainer/mods:mods/mods:name[mods:role/mods:roleTerm/text()='aut' and position() &lt; 4]">
          <xsl:if test="position()!=1">
            <xsl:value-of select="'; '" />
          </xsl:if>
          <xsl:choose>
            <xsl:when test="mods:displayForm">
              <xsl:value-of select="mods:displayForm" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="mods:namePart[@type='given']" />
              <xsl:text> </xsl:text>
              <xsl:value-of select="mods:namePart[@type='family']" />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
      </div>
    </div>
  </xsl:template>


</xsl:stylesheet>