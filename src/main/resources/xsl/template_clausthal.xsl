<?xml version="1.0" encoding="ISO-8859-1"?>
  <!-- ============================================== -->
  <!-- $Revision$ $Date$ -->
  <!-- ============================================== -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:basket="xalan://org.mycore.frontend.basket.MCRBasketManager" xmlns:mcr="http://www.mycore.org/" xmlns:mcrxsl="xalan://org.mycore.common.xml.MCRXMLFunctions" xmlns:i18n="xalan://org.mycore.services.i18n.MCRTranslation"
  xmlns:actionmapping="xalan://org.mycore.wfc.actionmapping.MCRURLRetriever" exclude-result-prefixes="xlink basket actionmapping mcr mcrxsl i18n">
  <xsl:param name="numPerPage" />
  <xsl:param name="previousObject" />
  <xsl:param name="previousObjectHost" />
  <xsl:param name="nextObject" />
  <xsl:param name="nextObjectHost" />
  <xsl:param name="resultListEditorID" />
  <xsl:param name="page" />
  <xsl:param name="breadCrumb" />
  <xsl:param name="piwikID" select="'0'" />
  <xsl:param name="resultsText" />
  <xsl:variable name="wcms.useTargets" select="'no'" />

  <!-- any XML elements defined here will go into the head -->
  <!-- other stylesheets may override this variable -->
  <xsl:variable name="head.additional" />

  <!-- Various versions -->
  <xsl:variable name="bootstrap.version" select="'3.0.3'" />

  <!-- define specific PageTitle -->
  <xsl:variable name="clausthalPageTitle">
    <xsl:choose>
      <xsl:when test="/MyCoReWebPage/@i18n">
        <xsl:value-of select="i18n:translate(/MyCoReWebPage/@i18n)" />
      </xsl:when>
      <xsl:when test="/MyCoReWebPage/@title">
        <xsl:value-of select="/MyCoReWebPage/@title" />
      </xsl:when>
      <xsl:when test="/MyCoReWebPage/section/@i18n">
        <xsl:value-of select="i18n:translate(/MyCoReWebPage/section/@i18n)" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="/MyCoReWebPage/section[ lang($CurrentLang)]/@title != '' ">
            <xsl:value-of select="/MyCoReWebPage/section[lang($CurrentLang)]/@title" />
          </xsl:when>
          <xsl:when test="/MyCoReWebPage/section[@alt and contains(@alt,$CurrentLang)]/@title != '' ">
            <xsl:value-of select="/MyCoReWebPage/section[contains(@alt,$CurrentLang)]/@title" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="/MyCoReWebPage/section[lang($DefaultLang)]/@title" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!-- ============================================== -->
  <!-- the template                                   -->
  <!-- ============================================== -->
  <xsl:template name="template_clausthal">
    <html>

    <head>
      <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
        <title>
          <xsl:choose>
            <xsl:when test="string-length($clausthalPageTitle) &gt; 0">
              <xsl:value-of select="$clausthalPageTitle"/>
              <xsl:text> | </xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$PageTitle"/>
              <xsl:if test="string-length($PageTitle) &gt; 0"><xsl:text> | </xsl:text></xsl:if>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:if test="string-length($PageTitle) &gt; 0"></xsl:if>
          <xsl:text>UB Clausthal</xsl:text>
        </title>

      <link href="{$WebApplicationBaseURL}templates/master/{$template}/CSS/clzf_default.css" rel="stylesheet" type="text/css"/>
      <!--[if lte IE 7]>
      <link href="{$WebApplicationBaseURL}templates/master/{$template}/CSS/patches/patch_clzf_default.css" rel="stylesheet"
        type="text/css"/>
      <![endif]-->
      <link href="{$WebApplicationBaseURL}templates/master/{$template}/CSS/editor.css" rel="stylesheet" type="text/css"/>

      <link href="{$WebApplicationBaseURL}templates/master/template_wcms/CSS/style_admin.css" rel="stylesheet" type="text/css" />
      <link href="{$WebApplicationBaseURL}css/style_swf.css" rel="stylesheet" type="text/css" />

      <xsl:copy-of select="$head.additional" />
      <xsl:apply-templates select="/" mode="addHeader" />

      <script src="{$WebApplicationBaseURL}templates/master/{$template}/JS/lib/jquery.ui.draggable.js" type="text/javascript" />
      <script src="{$WebApplicationBaseURL}templates/master/{$template}/JS/lib/jquery.alerts.js" type="text/javascript" />
      <link href="{$WebApplicationBaseURL}templates/master/{$template}/JS/lib/jquery.alerts.css" rel="stylesheet" type="text/css" />
      <script src="{$WebApplicationBaseURL}templates/master/{$template}/JS/base.js" type="text/javascript" />

      <!-- add bootstrap css for some mycore components -->
      <xsl:if test="/MyCoReWebPage/section/@title='ACL Editor' or  /MyCoReWebPage/section/@title='SOLR expert search' or contains(/MyCoReWebPage//form/@action, 'XEditor') or /MyCoReWebPage/section/@title='Move Object'">
        <link type="text/css" rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/{$bootstrap.version}/css/bootstrap.min.css" />
      </xsl:if>

      <xsl:call-template name="module-broadcasting.getHeader" />

    </head>

    <body>
<!-- skip link navigation -->
      <ul id="skiplinks">
          <li><a class="skip" href="#nav">Skip to navigation (Press Enter).</a></li>
          <li><a class="skip" href="#col3">Skip to main content (Press Enter).</a></li>
      </ul>

      <div class="page_margins">
        <div class="page">

<!-- site header -->
          <div id="header" role="banner">
<!-- top navigation -->
            <div id="topnav" role="contentinfo">
              <div class="hlist">

<!-- DEBUG: print role -->
                <xsl:call-template name="userInfo"/>
                <xsl:text> | </xsl:text>
                <xsl:variable name="categories" select="document('classification:metadata:1:children:mcr-roles')/mycoreclass/categories" />
                <xsl:variable name="systemRole" select="$categories/category[mcrxsl:isCurrentUserInRole(@ID)]" />
                <xsl:variable name="roleNames">
                  <xsl:for-each select="$systemRole">
                    <xsl:value-of select="@ID" />
                    <xsl:if test="position()!=last()">
                      <xsl:value-of select="', '" />
                    </xsl:if>
                  </xsl:for-each>
                </xsl:variable>
                <xsl:choose>
                  <xsl:when test="string-length($roleNames)>0"><xsl:value-of select="$roleNames" /></xsl:when>
                  <xsl:otherwise><xsl:text>guest</xsl:text></xsl:otherwise>
                </xsl:choose>
<!-- DEBUG: end -->

                <!-- xsl:call-template name="generateFlagButton"/ -->
                <xsl:call-template name="NavigationRow">
                  <xsl:with-param name="rootNode" select="document($navigationBase)/navigation/navi-below" />
                </xsl:call-template>
              </div>
            </div>

<!-- site logo -->
            <div id="site_logo" role="projectlogo">
              <h1><a href="http://www.tu-clausthal.de/"><img src="{$WebApplicationBaseURL}templates/master/{$template}/IMAGES/tuc2005.gif" alt="Logo" /></a></h1>
            </div>

            <div id="project_info">
              <h2 id="project_title"><a href="http://www.ub.tu-clausthal.de/">Universitätsbibliothek</a></h2>
              <h3 id="project_slogan">
                <a>
                  <xsl:attribute name="href">
                    <xsl:call-template name="UrlAddSession">
                      <xsl:with-param name="url" select="concat($WebApplicationBaseURL,'content/main/index.xml')" />
                    </xsl:call-template>
                  </xsl:attribute>
                  Dokumentenserver
                </a>
              </h3>
            </div>

          </div>

<!-- main content area -->
          <div id="main">

<!-- first float column -->
            <xsl:if test="not(/MyCoReWebPage/section/@title='Move Object')">
              <div id="col1" role="complementary">
                <div id="col1_content" class="clearfix">

                  <h2>Menü</h2>
                  <div id="nav" role="navigation">
                    <div class="vlist">
                      <xsl:call-template name="Navigation_main" />
                    </div>
                    <div id="search">
                      <h1>Suche</h1>
                      <form action="{$WebApplicationBaseURL}servlets/solr/clausthal_default" method="get" class="yform full" id="nav_search_form">
                        <input type="hidden" name="start" value="0" />
                        <input type="hidden" name="rows" value="20" />
                        <input type="hidden" name="fl" value="*,score" />
                        <input type="hidden" name="mask" value="modules/mods/search-simplemods.xml" />
                        <div class="type-text">
                          <input name="q" type="text" size="15" maxlength="50" value="Suchbegriff" class="focus_form_field search_text_gray" id="nav_search">
                          </input>
                        </div>
                      </form>
                    </div>
                    <div id="basket">
                      <h1>Suchkorb</h1>
                      <xsl:call-template name="clausthal.basketbox" />
                    </div>
                    <div class="dllist">
                      <h1>Direktlinks</h1>
                      <ul>
                        <li><a href="http://opac.ub.tu-clausthal.de">Gesamtkatalog</a></li>
                        <li><a href="http://rzblx1.uni-regensburg.de/ezeit/fl.phtml?bibid=UBCL&amp;colors=7&amp;lang=de">EZB</a></li>
                        <li><a href="http://rzblx10.uni-regensburg.de/dbinfo/fachliste.php?bib_id=ubcl&amp;lett=l&amp;colors=&amp;ocolors=">DBIS</a></li>
                        <li><a href="http://www.ub.tu-clausthal.de/kontakt/online-hilfe-chat/">Online-Hilfe</a></li>
                      </ul>
                    </div>
                  </div>

                </div>
              </div>
            </xsl:if>

<!-- static column -->

             <!-- Krümelleiste -->
            <div role="main" id="col3">
              <xsl:if test="/MyCoReWebPage/section/@title='Move Object'">
                <xsl:attribute name="style">margin-left:20px;</xsl:attribute>
              </xsl:if>
              <div id="col3_crumble">
                <ul class="breadcrumb">
                  <li class="first"><xsl:copy-of select="'Navigation:'" /></li>
                  <xsl:choose>
                    <xsl:when test="string-length($breadCrumb)>0">
                      <xsl:copy-of select="$breadCrumb" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:call-template name="MyHistoryNavigationRow" />
                    </xsl:otherwise>
                  </xsl:choose>
                </ul>
              </div>
              <div id="col3_content" class="clearfix">

                <xsl:choose>
                  <xsl:when test="/basket"><!-- ToDo: Fix this hack ... -->
                    <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                  </xsl:when>
                  <xsl:when test="/response and not (contains($PageTitle, 'browsingPage'))">
                    <h1><xsl:value-of select="concat($PageTitle, ': ',$resultsText)" /></h1>
                  </xsl:when>
              <!-- Seitentitel -->
                  <xsl:otherwise>
                    <!-- xsl:if test="string-length($PageTitle)>0">
                      <h1>
                        <xsl:copy-of select="$PageTitle" />
                      </h1>
                    </xsl:if -->
                  </xsl:otherwise>
                </xsl:choose>

                <xsl:call-template name="template_clausthal.write.content" />
              </div>
<!-- ie column clearing -->
              <div id="ie_clearing">&amp;nbsp;</div>
            </div>

          </div>

          <!-- footer -->
          <div id="footer" role="contentinfo" class="clearfix">
            <div id="bottomnav" role="contentinfo">
              <div class="hlist">
                <ul>
                  <li><a href="http://www.tu-clausthal.de/info/impressum/">Impressum</a><span class="seperator"> · </span></li>
                  <li><a href="http://www.ub.tu-clausthal.de/kontakt/">Kontakt</a></li>
                  <!-- li><xsl:call-template name="footer" /><span class="seperator"> · </span></li>
                  <li>Powered by <a href="http://www.mycore.de/">MyCoRe</a><span class="seperator"> · </span></li>
                  <li>Layout based on <a href="http://www.yaml.de/">YAML</a></li -->
                </ul>
              </div>
            </div>
            <div id="trademark">
              © TU Clausthal 2013
            </div>
          </div>

        </div>
      </div>

<!-- full skip link functionality in webkit browsers -->
      <script src="{$WebApplicationBaseURL}templates/master/{$template}/yaml/core/js/yaml-focusfix.js" type="text/javascript"></script>

      <xsl:if test="$piwikID &gt; 0">
        <!-- Piwik -->
        <script type="text/javascript">
          var _paq = _paq || [];
          _paq.push(["setDoNotTrack", true]);
          _paq.push(["trackPageView"]);
          _paq.push(["enableLinkTracking"]);

          (function() {
            var u=(("https:" == document.location.protocol) ? "https" : "http") + "://piwik.gbv.de/";
            var objectID = '<xsl:value-of select="/mycoreobject/@ID" />';
            if(objectID != "") {
              _paq.push(["setCustomVariable",1, "object", objectID, "page"]);
            }
            _paq.push(["setTrackerUrl", u+"piwik.php"]);
            _paq.push(["setSiteId", "<xsl:value-of select="$piwikID" />"]);
            _paq.push(["setDownloadExtensions", "7z|aac|arc|arj|asf|asx|avi|bin|bz|bz2|csv|deb|dmg|doc|exe|flv|gif|gz|gzip|hqx|jar|jpg|jpeg|js|mp2|mp3|mp4|mpg|mpeg|mov|movie|msi|msp|odb|odf|odg|odp|ods|odt|ogg|ogv|pdf|phps|png|ppt|qt|qtm|ra|ram|rar|rpm|sea|sit|tar|tbz|tbz2|tgz|torrent|txt|wav|wma|wmv|wpd|z|zip"]);
            var d=document, g=d.createElement("script"), s=d.getElementsByTagName("script")[0]; g.type="text/javascript";
            g.defer=true; g.async=true; g.src=u+"piwik.js"; s.parentNode.insertBefore(g,s);
          })();
        </script>
        <noscript>
          <!-- Piwik Image Tracker -->
          <img src="http://piwik.gbv.de/piwik.php?idsite={$piwikID}&amp;rec=1" style="border:0" alt="" />
          <!-- End Piwik -->
        </noscript>
        <!-- End Piwik Code -->
      </xsl:if>
    </body>
  </html>

  </xsl:template>

  <!-- ======================================================================================================== -->
  <xsl:template name="template_clausthal.write.content">
    <xsl:call-template name="print.writeProtectionMessage" />
    <xsl:choose>
      <xsl:when test="$readAccess='true'">
        <!-- xsl:call-template name="getFastWCMS" / -->
        <xsl:apply-templates />
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="printNotLoggedIn" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="clausthal.basketbox">
    <xsl:variable name="basketType" select="'objects'" />
    <xsl:variable name="basket" select="document(concat('basket:',$basketType))/basket" />
    <xsl:apply-templates select="$basket" mode="preview" />
    <xsl:choose>
      <xsl:when test="/mycoreobject and not(basket:contains($basketType, /mycoreobject/@ID))">
        <form action="{$ServletsBaseURL}MCRBasketServlet{$HttpSession}" method="post" class="basket_form">
          <input type="hidden" name="action" value="add" />
          <input type="hidden" name="redirect" value="referer" />
          <input type="hidden" name="type" value="{$basketType}" />
          <input type="hidden" name="id" value="{/mycoreobject/@ID}" />
          <input type="hidden" name="uri" value="{concat('mcrobject:',/mycoreobject/@ID)}" />
          <p>
            <button type="submit" tabindex="1" class="basket_button" value="add"><xsl:value-of select="i18n:translate('basket.add')" /></button>
          </p>
        </form>
      </xsl:when>
      <xsl:when test="/response/result/doc">
        <form action="{$ServletsBaseURL}MCRBasketServlet{$HttpSession}" method="post" class="basket_form">
          <input type="hidden" name="action" value="add" />
          <input type="hidden" name="redirect" value="referer" />
          <input type="hidden" name="type" value="{$basketType}" />
          <xsl:for-each select="/response/result/doc">
            <xsl:choose>
              <xsl:when test="@id!=''">
                <input type="hidden" name="id" value="{@id}" />
                <input type="hidden" name="uri" value="{concat('mcrobject:',@id)}" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:variable name="id" select="str[@name='id']" />
                <input type="hidden" name="id" value="{$id}" />
                <input type="hidden" name="uri" value="{concat('mcrobject:',$id)}" />
              </xsl:otherwise>
            </xsl:choose>

          </xsl:for-each>
          <p>
            <button type="submit" tabindex="1" class="basket_button" value="add"><xsl:value-of select="i18n:translate('basket.add.searchpage')" /></button>
          </p>
        </form>
      </xsl:when>
    </xsl:choose>
    <xsl:apply-templates select="$basket" mode="open" />
  </xsl:template>
  <xsl:template match="basket" mode="preview">
    <p>
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
    </p>
  </xsl:template>
  <xsl:template match="basket" mode="open">
    <p>
      <a href="{$ServletsBaseURL}MCRBasketServlet{$HttpSession}?type={@type}&amp;action=show"
        class="mainlink"><xsl:value-of select="i18n:translate('basket.open')" /></a>
    </p>
  </xsl:template>


  <!--
    =================================================================================
    HistoryNavigationRow
    ==================================================================================
  -->

  <xsl:template name="MyHistoryNavigationRow">

    <!-- get href of starting page -->
    <!--
      Variable beinhaltet die url der in navigation.xml angegebenen
      Startseite
    -->
    <xsl:variable name="hrefStartingPage"
      select="$loaded_navigation_xml/@hrefStartingPage" />
    <!-- END OF: get href of starting page -->

    <!--
      fuer jedes Element des Elternknotens <navigation> in
      navigation.xml
    -->
    <xsl:for-each select="$loaded_navigation_xml//item[@href]">
      <!-- pruefe ob ein Element gerade angezeigt wird -->
      <xsl:if test="@href = $browserAddress ">
        <!-- dann eroeffne einen Verweis -->
        <li class="first"><a>
          <!-- auf die Startseite der Webanwendung -->
          <xsl:attribute name="href">
            <!-- fuege der Adresse die session ID hinzu -->
            <xsl:call-template name="UrlAddSession">
              <xsl:with-param name="url"
            select="concat($WebApplicationBaseURL,substring-after($hrefStartingPage,'/'))" />
            </xsl:call-template>
          </xsl:attribute>

          <!-- Linktext ist der Haupttitel aus mycore.properties.wcms-->
          <xsl:value-of select="$MainTitle" />
        </a></li>
        <!-- END OF: Verweis -->

        <!-- fuer sich selbst und jedes seiner Elternelemente -->
        <xsl:for-each select="ancestor-or-self::item">
          <!--
            und fuer alle Seiten ausser der Startseite zeige den
            Seitentitel in der Navigationsleiste Verweis auf die
            Startseite existiert bereits s.o.
          -->
          <xsl:if test="$browserAddress != $hrefStartingPage ">
            <li><a>
              <xsl:attribute name="href">
                <xsl:call-template name="UrlAddSession">
                  <xsl:with-param name="url"
                select="concat($WebApplicationBaseURL,substring-after(@href,'/'))" />
                </xsl:call-template>
              </xsl:attribute>
              <xsl:choose>
                <xsl:when test="./label[lang($CurrentLang)] != ''">
                  <xsl:value-of select="./label[lang($CurrentLang)]" />
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="./label[lang($DefaultLang)]" />
                </xsl:otherwise>
              </xsl:choose>
            </a></li>
          </xsl:if>
        </xsl:for-each>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <!-- ======================================================================================================== -->
</xsl:stylesheet>