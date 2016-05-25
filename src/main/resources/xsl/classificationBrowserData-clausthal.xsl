<?xml version="1.0" encoding="ISO-8859-1"?>

  <!--
    XSL to transform XML output from MCRClassificationBrowser servlet to
    HTML for client browser, which is loaded by AJAX. The browser sends
    data of all child categories of the requested node.
  -->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:i18n="xalan://org.mycore.services.i18n.MCRTranslation"
  xmlns:xalan="http://xml.apache.org/xalan" exclude-result-prefixes="xalan i18n">
  <xsl:param name="WebApplicationBaseURL" />
  <xsl:param name="ServletsBaseURL" />
  <xsl:param name="template" />

  <xsl:output method="xml" omit-xml-declaration="yes" />
  <xsl:decimal-format name="european" decimal-separator=',' grouping-separator='.' />

  <xsl:template match="/classificationBrowserData">
    <xsl:variable name="folder.closed" select="concat($WebApplicationBaseURL,'templates/master/',$template,'/IMAGES/folder_plus.gif')" />
    <xsl:variable name="folder.open" select="concat($WebApplicationBaseURL,'templates/master/',$template,'/IMAGES/folder_minus.gif')" />
    <xsl:variable name="folder.leaf" select="concat($WebApplicationBaseURL,'templates/master/',$template,'/IMAGES/folder_plain.gif')" />
    <xsl:variable name="maxLinks">
      <xsl:value-of select="category[not(@numLinks &lt; following-sibling::category/@numLinks)]/@numLinks" />
    </xsl:variable>
    <xsl:variable name="maxResults">
      <xsl:value-of select="category[not(@numResults &lt; following-sibling::category/@numResults)]/@numResults" />
    </xsl:variable>

    <ul class="cbList">
      <xsl:for-each select="category">
        <xsl:variable name="id" select="translate(concat(../@classification,'_',@id),'+/()[]','ABCDEF')" />
        <li class="floatbox">
          <div class="cbItem">
            <xsl:choose>
              <xsl:when test="@children = 'true'">
                <input id="cbButton_{$id}" type="image" value="+" src="{$folder.closed}" onclick="toogle('{@id}','{$folder.closed}','{$folder.open}');" />
              </xsl:when>
              <xsl:otherwise>
                <img src="{$folder.leaf}" id="cbButton_{$id}" />
              </xsl:otherwise>
            </xsl:choose>
          </div>
          <xsl:apply-templates select="@numResults" mode="formatCount">
            <xsl:with-param name="maxCount" select="$maxResults" />
          </xsl:apply-templates>
          <xsl:apply-templates select="@numLinks" mode="formatCount">
            <xsl:with-param name="maxCount" select="$maxLinks" />
          </xsl:apply-templates>
          <a onclick="return startSearch('{$ServletsBaseURL}SolrSelectProxy?','{@query}','{../@webpage}','{../@parameters}');" href="{$ServletsBaseURL}SolrSelectProxy?{@query}&amp;mask={../@webpage}&amp;{../@parameters}">
            <xsl:value-of select="label" />
          </a>
          <xsl:if test="uri">
            <xsl:text> </xsl:text>
            <a href="{uri}" class="cbURI">
              <xsl:value-of select="uri" />
            </a>
          </xsl:if>
          <xsl:if test="description">
            <p class="cbDescription">
              <xsl:value-of select="description" />
            </p>
          </xsl:if>
          <xsl:if test="@children = 'true'">
            <div id="cbChildren_{$id}" class="cbHidden" />
          </xsl:if>
        </li>
      </xsl:for-each>
    </ul>
  </xsl:template>

  <xsl:template match="@numResults|@numLinks" mode="formatCount">
    <div class="cbNum">
      <xsl:value-of select="format-number(., '###.###', 'european')" />
    </div>
  </xsl:template>

</xsl:stylesheet>
