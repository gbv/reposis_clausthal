<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:i18n="xalan://org.mycore.services.i18n.MCRTranslation"
  xmlns:mcrver="xalan://org.mycore.common.MCRCoreVersion"
  exclude-result-prefixes="i18n mcrver">

  <xsl:import href="resource:xsl/layout/mir-common-layout.xsl" />

  <xsl:template  name="mir.header">
    <div id="head" class="container">
      <div class="row">
        <div id="header_back">
          <img src="{$WebApplicationBaseURL}images/tuclogo.png" id="header_ratio" />
          <h2 id="project_title">
            <a href="http://www.ub.tu-clausthal.de/">Universitätsbibliothek</a>
          </h2>
          <h3 id="project_slogan">
            <a href="{$WebApplicationBaseURL}">
              Publikationsserver
            </a>
          </h3>
        </div>
        <noscript>
          <div class="mir-no-script alert alert-warning text-center" style="border-radius: 0;">
            <xsl:value-of select="i18n:translate('mir.noScript.text')" />&#160;
            <a href="http://www.enable-javascript.com/de/" target="_blank">
              <xsl:value-of select="i18n:translate('mir.noScript.link')" />
            </a>
            .
          </div>
        </noscript>
      </div>
    </div>
  </xsl:template>

  <xsl:template name="mir.top-navigation">
  <div class="navbar navbar-default mir-prop-nav">
    <nav class="mir-prop-nav-entries">
      <ul class="nav navbar-nav pull-right">
        <xsl:call-template name="mir.loginMenu" />
      </ul>
    </nav>
  </div>
  </xsl:template>

  <xsl:template name="mir.navigation">
    <div class="navbar navbar-default mir-side-nav">
      <nav class="mir-main-nav-entries">
        <form action="{$WebApplicationBaseURL}servlets/solr/find?q={0}" class="navbar-form form-inline" role="search">
          <div class="form-group">
            <input name="q" placeholder="{i18n:translate('mir.cosmol.navsearch.placeholder')}" title="{i18n:translate('mir.cosmol.navsearch.title')}" class="form-control search-query" id="searchInput" type="text" />
          </div>
          <button type="submit" title="{i18n:translate('mir.cosmol.navsearch.title')}" class="btn btn-primary"><span class="glyphicon glyphicon-search"></span></button>
        </form>
        <ul class="nav navbar-nav">
          <xsl:apply-templates select="$loaded_navigation_xml/menu[@id='main']" />
          <xsl:apply-templates select="$loaded_navigation_xml/menu[@id='search']" />
          <xsl:apply-templates select="$loaded_navigation_xml/menu[@id='browse']" />
          <xsl:apply-templates select="$loaded_navigation_xml/menu[@id='publish']" />
          <xsl:call-template name="mir.basketMenu" />
          <xsl:apply-templates select="$loaded_navigation_xml/menu[@id='misc']" />
        </ul>
      </nav>
    </div>
  </xsl:template>

  <xsl:template name="mir.footer">
    <div class="container">
        <div id="menu" class="row">
            <div class="col-xs-6">
                <ul id="sub_menu">
                  <xsl:for-each select="$loaded_navigation_xml/menu[@id='below']/item">
                    <xsl:apply-templates select="." />
                  </xsl:for-each>
                </ul>
            </div>
            <div class="col-xs-6">
                <div id="copyright">© <xsl:value-of select="$MCR.NameOfProject" /> 2016</div>
            </div>
        </div>
        <div id="credits" class="row">
            <div class="col-xs-12">
                <div id="powered_by">
                    <a href="http://www.mycore.de">
                        <xsl:variable name="mcr_version" select="concat('MyCoRe ',mcrver:getCompleteVersion())" />
                        <img src="{$WebApplicationBaseURL}mir-layout/images/mycore_logo_powered_120x30_blaue_schrift_frei.png" title="{$mcr_version}" alt="powered by MyCoRe"/>
                    </a>
                </div>
            </div>
        </div>
    </div>
  </xsl:template>

</xsl:stylesheet>