<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:mods="http://www.loc.gov/mods/v3" xmlns:encoder="xalan://java.net.URLEncoder"
  xmlns:i18n="xalan://org.mycore.services.i18n.MCRTranslation" xmlns:str="http://exslt.org/strings" xmlns:xlink="http://www.w3.org/1999/xlink" exclude-result-prefixes="i18n mods str xlink">
  <xsl:template match="doc[@objectType='mods']" priority="10" mode="resultList">
    <!--
      Do not read MyCoRe object at this time
    -->

    <xsl:param name="currentPos" select="'1'" />

    <xsl:variable name="identifier" select="@id" />
    <xsl:variable name="objectlink" select="concat('mcrobject:',$identifier)" />
    <xsl:variable name="mcrobj" select="document($objectlink)" />
    <xsl:variable name="mods-type">
      <xsl:choose>
        <xsl:when test="str[@name='mods.kindOf']">
          <xsl:value-of select="str[@name='mods.kindOf']" />
        </xsl:when>
        <xsl:when test="str[@name='mods.type']">
          <xsl:value-of select="str[@name='mods.type']" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="'report'" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <!-- generate browsing url -->
    <xsl:variable name="params">
      <xsl:for-each select="/response/lst[@name='responseHeader']/lst[@name='params']/str">
        <xsl:choose>
          <xsl:when test="@name='start'">
          <!-- Skip start parameter -->
          </xsl:when>
          <xsl:when test="@name='rows' or @name='XSL.Style' or @name='fl'">
          <!-- origParameterName=parameterValue -->
            <xsl:value-of select="concat('orig', @name,'=', encoder:encode(., 'UTF-8'))" />
            <xsl:if test="not (position() = last())">
              <xsl:value-of select="'&amp;'" />
            </xsl:if>
          </xsl:when>
          <xsl:otherwise>
          <!-- parameterName=parameterValue -->
            <xsl:value-of select="concat(@name,'=', encoder:encode(., 'UTF-8'))" />
            <xsl:if test="not (position() = last())">
              <xsl:value-of select="'&amp;'" />
            </xsl:if>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="href" select="concat($proxyBaseURL,'?', $HttpSession,'&amp;', $params)" />
    <xsl:variable name="hitHref">
      <xsl:value-of select="concat($href, '&amp;start=',$currentPos, '&amp;fl=id&amp;rows=1&amp;XSL.Style=browse')" />
    </xsl:variable>

    <div class="hit_symbol floatbox">
      <img src="{$WebApplicationBaseURL}templates/master/{$template}/IMAGES/icons_liste/icon_{$mods-type}.png" alt="{$mods-type}" />
    </div>
    <h3>
      <a href="{$hitHref}">
        <xsl:choose>
          <xsl:when test="./str[@name='search_result_link_text']">
            <xsl:value-of select="./str[@name='search_result_link_text']" />
          </xsl:when>
          <xsl:when test="./str[@name='fileName']">
            <xsl:value-of select="./str[@name='fileName']" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$identifier" />
          </xsl:otherwise>
        </xsl:choose>
      </a>
    </h3>
    <div class="hitListDetails">

      <xsl:if test="./arr[@name='mods.author']">
        <div class="author">
    <!-- Author -->
          <xsl:for-each select="./arr[@name='mods.author']/str">
            <xsl:if test="position()!=1">
              <xsl:value-of select="'; '" />
            </xsl:if>
            <!-- TODO: Link auf Suche & GND ergänzen -->
            <xsl:value-of select="." />
          </xsl:for-each>
        </div>
      </xsl:if>
    <!-- Source -->
      <xsl:if test="./str[@name='parent']">
        <div class="source">
          <xsl:text>aus: </xsl:text>
          <xsl:choose>
            <xsl:when test="./str[@name='parentLinkText']">
              <xsl:variable name="linkTo" select="concat($WebApplicationBaseURL, 'receive/',./str[@name='parent'])" />
              <a href="{$linkTo}">
                <xsl:value-of select="./str[@name='parentLinkText']" />
              </a>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="objectLink">
                <xsl:with-param select="./str[@name='parent']" name="obj_id" />
              </xsl:call-template>
            </xsl:otherwise>
          </xsl:choose>
        </div>
      </xsl:if>
    </div>

  <!-- hit info -->
    <div class="hitListInfo">
      <xsl:variable name="scoreStyle">
        <xsl:choose>
          <xsl:when test="str[@name='mods.dateIssued']">
            <xsl:text>hit_info hborder</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>hit_info</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="basketType" select="'objects'" />
      <div class="hit_info hborder">
        <a class="addToBasket"
           href="{$ServletsBaseURL}MCRBasketServlet{$HttpSession}?type=objects&amp;action=add&amp;id={$identifier}&amp;uri=mcrobject:{$identifier}&amp;redirect=referer">
            <xsl:value-of select="i18n:translate('basket.add')" />
        </a>
      </div>
      <div class="{$scoreStyle}">
        <xsl:variable name="score">
          <xsl:value-of select="float[@name='score']" />
        </xsl:variable>
        <xsl:value-of select="concat(i18n:translate('results.score'),': ',format-number($score, '##,####', 'european'))" />
      </div>
      <xsl:if test="str[@name='mods.dateIssued']">
        <div class="hit_info">
          <xsl:variable name="date">
            <xsl:value-of select="str[@name='mods.dateIssued']" />
          </xsl:variable>
          <xsl:value-of select="concat(i18n:translate('component.mods.metaData.dictionary.dateIssued'),': ',$date)" />
        </div>
      </xsl:if>
    </div>
  </xsl:template>

</xsl:stylesheet>