<?xml version="1.0" encoding="ISO-8859-1"?>

<!-- Renders the output of MCRBasketServlet -->

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:xalan="http://xml.apache.org/xalan"
  xmlns:i18n="xalan://org.mycore.services.i18n.MCRTranslation"
  exclude-result-prefixes="xlink xalan i18n">

  <xsl:include href="MyCoReLayout.xsl" />

  <!-- include custom templates for supported objecttypes -->
  <xsl:include href="xslInclude:objectTypes"/>

  <xsl:variable name="Type" select="'mods'" />
  <xsl:variable name="MainTitle" select="i18n:translate(concat('basket.title.',/basket/@type))" />
  <xsl:variable name="PageTitle" select="$MainTitle" />

  <xsl:template match="/basket">
    <!-- xsl:call-template name="basketNumEntries" / -->
    <xsl:call-template name="basketEntries" />
  </xsl:template>

  <xsl:template name="basketNumEntries">
    <div>
      <p>
        <xsl:choose>
          <xsl:when test="count(entry) = 0">
            <xsl:value-of select="i18n:translate('basket.numEntries.none')" />
          </xsl:when>
          <xsl:when test="count(entry) = 1">
            <xsl:value-of select="i18n:translate('basket.numEntries.one')" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="i18n:translate('basket.numEntries.many',count(*))" />
          </xsl:otherwise>
        </xsl:choose>
      </p>
      <xsl:if test="entry">
        <a href="MCRBasketServlet?type={@type}&amp;action=clear">
          <xsl:value-of select="i18n:translate('basket.clear')" />
        </a>
      </xsl:if>
    </div>
  </xsl:template>

  <xsl:template name="basketEntries">
    <div class="blockbox" id="basket_view">
      <h3>
        <xsl:choose>
          <xsl:when test="count(entry) = 0">
            <xsl:value-of select="i18n:translate('basket.numEntries.none')" disable-output-escaping="yes" />
          </xsl:when>
          <xsl:when test="count(entry) = 1">
            <xsl:value-of select="i18n:translate('basket.numEntries.one')" disable-output-escaping="yes" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="i18n:translate('basket.numEntries.many',count(*))" disable-output-escaping="yes" />
          </xsl:otherwise>
        </xsl:choose>
      </h3>
      <xsl:if test="entry">
        <div class="document_options">
          <img titel="Optionen" alt="" src="{$WebApplicationBaseURL}templates/master/{$template}/IMAGES/icon_arrow_circled_red_down.png" class="button_options" />
          <div class="options">
            <xsl:call-template name="options" />
          </div>
        </div>
        <xsl:apply-templates select="entry" />
      </xsl:if>
      <br />
    </div>
  </xsl:template>

  <xsl:template match="entry">
    <div class="basketEntry">
      <xsl:attribute name="class">
      <xsl:text>basketEntry floatbox background</xsl:text>
      <xsl:value-of select="2 - (position() mod 2)" />
    </xsl:attribute>
      <div class="basketCounter">
        <span><xsl:value-of select="position()" /></span>
      </div>
      <div class="basketButtons">
        <xsl:call-template name="basketButtonsUpDownDelete" />
      </div>
      <div class="basketContent">
        <xsl:choose>
          <xsl:when test="*[not(name()='comment')]">
            <xsl:apply-templates select="*[not(name()='comment')]" mode="basketContent" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="document(@uri)/*" mode="basketContent" />
          </xsl:otherwise>
        </xsl:choose>
        <xsl:apply-templates select="comment" mode="basketContent" />
      </div>
    </div>
  </xsl:template>

  <xsl:template name="basketButtonsUpDownDelete">
    <xsl:call-template name="button">
      <xsl:with-param name="image">minus</xsl:with-param>
      <xsl:with-param name="action">remove</xsl:with-param>
    </xsl:call-template>
    <xsl:text>
    </xsl:text>
    <xsl:call-template name="button">
      <xsl:with-param name="image">up</xsl:with-param>
      <xsl:with-param name="action">up</xsl:with-param>
      <xsl:with-param name="condition" select="position() &gt; 1" />
    </xsl:call-template>
    <xsl:text>
    </xsl:text>
    <xsl:call-template name="button">
      <xsl:with-param name="image">down</xsl:with-param>
      <xsl:with-param name="action">down</xsl:with-param>
      <xsl:with-param name="condition" select="position() != last()" />
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="button">
    <xsl:param name="image" />
    <xsl:param name="action" />
    <xsl:param name="condition" select="true()" />

    <xsl:choose>
      <xsl:when test="$condition">
        <a href="MCRBasketServlet?action={$action}&amp;type={/basket/@type}&amp;id={@id}">
          <img alt="{i18n:translate(concat('basket.button.',$action))}" src="{$WebApplicationBaseURL}images/pmud-{$image}.png" />
        </a>
      </xsl:when>
      <xsl:otherwise>
        <span />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="options">
      <ul>
        <li>
          <a href="{$ServletsBaseURL}MCRBasketServlet{$HttpSession}?type={@type}&amp;action=clear&amp;redirect=referer">
            <xsl:value-of select="i18n:translate('basket.clear')" />
          </a>
        </li>
        <li>
          <a href="{$ServletsBaseURL}MCRExportServlet{$HttpSession}?basket={@type}&amp;transformer=bibtex">
            als BibTex exportieren
          </a>
        </li>
        <li>
          <a href="{$ServletsBaseURL}MCRExportServlet{$HttpSession}?basket={@type}&amp;transformer=endnote">
            als Endnote exportieren
          </a>
        </li>
        <li>
          <a href="{$ServletsBaseURL}MCRExportServlet{$HttpSession}?basket={@type}&amp;transformer=ris">
            als RIS exportieren
          </a>
        </li>
        <li>
          <a href="{$ServletsBaseURL}MCRExportServlet{$HttpSession}?basket={@type}&amp;transformer=isi">
            als ISI exportieren
          </a>
        </li>
        <li>
          <a href="{$ServletsBaseURL}MCRExportServlet{$HttpSession}?basket={@type}&amp;transformer=wordbib">
            als Word 2007 bibliography exportieren
          </a>
        </li>
        <li>
          <a href="{$ServletsBaseURL}MCRExportServlet{$HttpSession}?basket={@type}&amp;transformer=mods">
            als MODS exportieren
          </a>
        </li>
      </ul>
  </xsl:template>

</xsl:stylesheet>
