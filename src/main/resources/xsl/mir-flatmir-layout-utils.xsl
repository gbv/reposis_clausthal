<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:i18n="xalan://org.mycore.services.i18n.MCRTranslation"
    xmlns:mcrver="xalan://org.mycore.common.MCRCoreVersion"
    xmlns:mcrxsl="xalan://org.mycore.common.xml.MCRXMLFunctions"
    xmlns:calendar="xalan://java.util.GregorianCalendar"
    exclude-result-prefixes="i18n mcrver mcrxsl calendar">

  <xsl:import href="resource:xsl/layout/mir-common-layout.xsl" />
  <xsl:param name="MCR.NameOfProject"/>

  <xsl:template name="mir.navigation">

  <div id="header_box" class="container">
    <div class="row">

      <div class="col-6">
        <div class="project_logo_box">
          <a href="https://www.tu-clausthal.de/"
             class="project_logo_link project_logo_link--logo">
            <img src="{$WebApplicationBaseURL}images/logos/Logo_TUC_de_rgb.SVG" alt="TUC Logo" />
          </a>
          <div class="project_slogans">
            <a href="https://www.ub.tu-clausthal.de/"
               class="project_logo_link project_logo_link--ub">
                Universitätsbibliothek
            </a>
            |
            <a href="{concat($WebApplicationBaseURL,substring($loaded_navigation_xml/@hrefStartingPage,2),$HttpSession)}"
               class="project_logo_link project_logo_link--project">
                Publikationsserver
            </a>
          </div>
        </div>
      </div>

      <div class="col">

        <div class="row">
          <div class="col">
            <div class="mir-prop-nav">
              <nav>
                <ul class="navbar-nav ml-auto flex-row">
                  <xsl:call-template name="mir.loginMenu" />
                  <xsl:call-template name="mir.languageMenu" />
                </ul>
              </nav>
            </div>
          </div>
        </div>

        <div class="row">
          <div class="col">
            <div class="mir-prop-nav">

              <form
                action="{$WebApplicationBaseURL}servlets/solr/find"
                class="searchfield_box form-inline m-3"
                role="search">
                <input
                  name="condQuery"
                  placeholder="{i18n:translate('mir.navsearch.placeholder')}"
                  class="form-control mr-sm-2 search-query"
                  id="searchInput"
                  type="text"
                  aria-label="Search" />
                <xsl:choose>
                  <xsl:when test="contains($isSearchAllowedForCurrentUser, 'true')">
                    <input name="owner" type="hidden" value="createdby:*" />
                  </xsl:when>
                  <xsl:when test="not(mcrxsl:isCurrentUserGuestUser())">
                    <input name="owner" type="hidden" value="createdby:{$CurrentUser}" />
                  </xsl:when>
                </xsl:choose>
                <button type="submit" class="btn btn-primary my-2 my-sm-0">
                  <i class="fas fa-search"></i>
                </button>
              </form>

            </div>
          </div>
        </div>


      </div>
    </div>
  </div>

    <!-- Collect the nav links, forms, and other content for toggling -->
    <div class="mir-main-nav">
      <div class="container">
        <nav class="navbar navbar-expand-lg navbar-light">

          <button
            class="navbar-toggler"
            type="button"
            data-toggle="collapse"
            data-target="#mir-main-nav-collapse-box"
            aria-controls="mir-main-nav-collapse-box"
            aria-expanded="false"
            aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
          </button>

          <div id="mir-main-nav-collapse-box" class="collapse navbar-collapse mir-main-nav__entries">
            <ul class="navbar-nav ml-auto mt-2 mt-lg-0">
              <xsl:for-each select="$loaded_navigation_xml/menu">
                <xsl:choose>
                  <!-- Ignore some menus, they are shown elsewhere in the layout -->
                  <xsl:when test="@id='main'"/>
                  <xsl:when test="@id='brand'"/>
                  <xsl:when test="@id='below'"/>
                  <xsl:when test="@id='user'"/>
                  <xsl:otherwise>
                    <xsl:apply-templates select="."/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:for-each>
              <xsl:call-template name="mir.basketMenu" />
            </ul>
          </div>

        </nav>
      </div>
    </div>
  </xsl:template>

  <xsl:template name="mir.jumbotwo">
    <!-- show only on startpage -->
    <xsl:if test="//div/@class='jumbotwo'">
    </xsl:if>
  </xsl:template>

  <xsl:template name="mir.footer">
    <div class="container">
      <div class="row">

        <div class="col-auto">
          <h4>Info</h4>
          <ul class="project-nav-footer nav">
            <xsl:apply-templates select="$loaded_navigation_xml/menu[@id='below']/*" />
          </ul>
        </div>

        <div class="col">
          <div class="dini-box text-right">
            <img
              class="img-fluid"
              src="{$WebApplicationBaseURL}images/DINI_Siegel_FINAL_22__3_.png"
              alt="DINI 22" />
          </div>
        </div>

        <div class="col-auto text-right">
          <div class="text-right">
            <xsl:variable name="tmp" select="calendar:new()"/>
            <div id="copyright">
              <xsl:text>© </xsl:text>
              <xsl:value-of select="$MCR.NameOfProject" />
              <xsl:text> </xsl:text>
              <xsl:value-of select="calendar:get($tmp, 1)"/>
            </div>
          </div>
        </div>

      </div>
    </div>
  </xsl:template>

  <xsl:template name="mir.powered_by">
    <xsl:variable name="mcr_version" select="concat('MyCoRe ',mcrver:getCompleteVersion())" />
    <div id="powered_by">
      <a href="http://www.mycore.de">
        <img src="{$WebApplicationBaseURL}mir-layout/images/mycore_logo_powered_120x30_blaue_schrift_frei.png" title="{$mcr_version}" alt="powered by MyCoRe" />
      </a>
    </div>
  </xsl:template>

</xsl:stylesheet>
