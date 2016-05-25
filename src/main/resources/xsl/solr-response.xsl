<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [
  <!ENTITY html-output SYSTEM "xsl/xsl-output-html.fragment">
]>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:encoder="xalan://java.net.URLEncoder"
  xmlns:i18n="xalan://org.mycore.services.i18n.MCRTranslation" xmlns:xalan="http://xml.apache.org/xalan" exclude-result-prefixes="xalan i18n encoder">
  &html-output;
  <xsl:include href="MyCoReLayout.xsl" />
  <xsl:include href="response-utils.xsl" />
  <xsl:include href="xslInclude:solrResponse" />

  <xsl:param name="WebApplicationBaseURL" />
  <xsl:param name="MCR.Results.FetchHit" />

  <xsl:decimal-format name="european" decimal-separator=',' grouping-separator='.' />

  <xsl:variable name="PageTitle">
    <xsl:value-of select="i18n:translate('component.solr.searchresult.resultList')" />
  </xsl:variable>

  <xsl:variable name="numPerPage">
    <xsl:choose>
      <xsl:when test="$params/str[@name='rows']">
        <xsl:value-of select="$params/str[@name='rows']" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>20</xsl:text>  <!-- default value -->
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="pagePosition">
    <xsl:value-of select="($numPerPage * $currentPage ) - $numPerPage" />
  </xsl:variable>
  <xsl:variable name="resultsText">
    <xsl:choose>
      <xsl:when test="/response/result[@numFound=1]">
        <xsl:value-of select="i18n:translate('results.oneObject')" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="i18n:translate('results.nObjects',format-number(/response/result/@numFound, '###.###', 'european'))" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:template match="/response">
    <xsl:apply-templates select="result" />
  </xsl:template>

  <xsl:template match="/response/result">
    <xsl:if test="@numFound &gt; 0">
      <xsl:variable name="ResultPages">
        <xsl:call-template name="solr.Pagination">
          <xsl:with-param name="size" select="$rows" />
          <xsl:with-param name="currentpage" select="$currentPage" />
          <xsl:with-param name="totalpage" select="$totalPages" />
        </xsl:call-template>
      </xsl:variable>
      <xsl:variable name="searchMask" select="$params/str[@name='mask']" />

      <xsl:copy-of select="$ResultPages" />
      <xsl:comment>
        RESULT LIST START
      </xsl:comment>
      <div class="blockbox">
        <xsl:apply-templates select="doc" />
      </div>
      <xsl:comment>
        RESULT LIST END
      </xsl:comment>
      <xsl:copy-of select="$ResultPages" />
    </xsl:if>
  </xsl:template>

  <xsl:template match="doc">
    <xsl:comment>
      RESULT ITEM START
    </xsl:comment>
    <div>
      <xsl:attribute name="class">
        <xsl:text>hit_item</xsl:text>
        <xsl:if test="position()=last()"> last</xsl:if>
      </xsl:attribute>
      <div class="floatbox">
        <div class="hit_counter"><xsl:number value="position() + $pagePosition" format="01. " /></div>
        <xsl:choose>
          <xsl:when test="$MCR.Results.FetchHit='true'">
            <!--
              LOCAL REQUEST
            -->
            <xsl:variable name="mcrobj" select="document(concat('mcrobject:',@id))/mycoreobject" />
            <xsl:apply-templates select="." mode="resultList">
              <xsl:with-param name="mcrobj" select="$mcrobj" />
              <xsl:with-param name="currentPos" select="position() + $pagePosition - 1" />
            </xsl:apply-templates>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="." mode="resultList">
              <xsl:with-param name="currentPos" select="position() + $pagePosition - 1" />
            </xsl:apply-templates>
          </xsl:otherwise>
        </xsl:choose>
      </div>
    </div>
    <xsl:comment>
      RESULT ITEM END
    </xsl:comment>
  </xsl:template>

  <xsl:template match="doc" mode="resultList">
    <!--
      Do not read MyCoRe object at this time
    -->
    <xsl:variable name="identifier" select="@id" />
    <xsl:variable name="mcrobj" select="." />
    <xsl:variable name="mods-type">
      <xsl:choose>
        <xsl:when test="str[@name='mods.type']">
          <xsl:value-of select="str[@name='mods.type']" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="'article'" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <article class="result clearfix" itemscope="" itemtype="http://schema.org/Book">
      <header class="top-head">
        <h3>
          <xsl:apply-templates select="." mode="linkTo" />
        </h3>
      </header>
      <footer class="date">
        <xsl:variable name="dateModified" select="date[@name='modified']" />
        <p>
          Zuletzt bearbeitet am :
          <time itemprop="dateModified" datetime="{$dateModified}">
            <xsl:call-template name="formatISODate">
              <xsl:with-param select="$dateModified" name="date" />
              <xsl:with-param select="i18n:translate('metaData.date')" name="format" />
            </xsl:call-template>
          </time>
        </p>
      </footer>
      <section>
        <ul class="actions">
          <li>
            <a href="#">
              <i class="icon-edit"></i>
              Bearbeiten
            </a>
          </li>
          <li>
            <a
              href="{$ServletsBaseURL}MCRBasketServlet{$HttpSession}?type=objects&amp;action=add&amp;id={$mcrobj/@ID}&amp;uri=mcrobject:{$mcrobj/@ID}&amp;redirect=referer">
              <i class="icon-plus"></i>
              <xsl:value-of select="i18n:translate('basket.add')" />
            </a>
          </li>
        </ul>
      </section>
    </article>

  </xsl:template>

</xsl:stylesheet>