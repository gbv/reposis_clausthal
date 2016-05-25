<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE xsl:stylesheet [
  <!ENTITY html-output SYSTEM "xsl/xsl-output-html.fragment">
]>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:i18n="xalan://org.mycore.services.i18n.MCRTranslation" exclude-result-prefixes="xlink">
  &html-output;
  <xsl:variable name="Type" select="'document'" />

  <xsl:variable name="MainTitle" select="concat(/mcr_error/@HttpError,': OpenAgrar')" />

  <xsl:variable name="PageTitle" select="i18n:translate('titles.pageTitle.error',concat(' ',/mcr_error/@HttpError))" />

  <xsl:template match="/mcr_error">

    <xsl:choose>
      <xsl:when test="/mcr_error/@HttpError = '500'">
        <div class="blockbox" id="errormessage">
          <h2>Interner Serverfehler</h2>
          <p>Es ist leider ein Serverfehler aufgetreten. Wir arbeiten an dessen Beseitigung!
          Gern können Sie uns eine Mail an <span class="madress">dms-list [at] gbv.de</span>
          schicken und kurz schildern wie es zu diesem Fehler kam.
          <br/><br/>
          Vielen Dank!</p>
        </div>
      </xsl:when>
      <xsl:when test="/mcr_error/@HttpError = '404'">
        <div class="blockbox" id="errormessage">
          <h2><xsl:value-of select="." /></h2>
          <p>Die von Ihnen angefordete Seite konnte leider nicht gefunden werden. Eventuell
          haben Sie ein altes Lesezeichen oder einen veralteten Link benutzt. Bitte versuchen
          Sie mithilfe der <a href="/index.html">Suche</a> die gewünschte Seite zu finden oder
          schreiben Sie eine Mail an <span class="madress">dms-list [at] gbv.de</span> und
          schildern kurz wie es zu diesem Fehler kam.
          <br/><br/>
          Vielen Dank!</p>
        </div>
      </xsl:when>
      <xsl:when test="/mcr_error/@HttpError = '403'">
        <div class="blockbox" id="errormessage">
          <h2>Zugriff verweigert</h2>
          <p>Sie haben keine Berechtigung diese Seite zu sehen. Melden Sie sich bitte am System an.
          Sollten Sie trotz Anmeldung nicht die nötigen Rechte haben um diese Seite zu sehen, wenden
          Sie sich ggf. an Ihren Administrator.
          <br/><br/>
          Vielen Dank!</p>
        </div>
      </xsl:when>
      <xsl:otherwise>
        <div class="blockbox" id="errormessage">
          <h2><xsl:value-of select="."></xsl:value-of></h2>
          <p>Es ist leider ein Fehler aufgetreten. Sollte dies wiederholt der Fall sein,
          schreiben Sie bitte eine Mail an <span class="madress">dms-list [at] gbv.de</span> und
          schildern kurz wie es dazu kam.
          <br/><br/>
          Vielen Dank!</p>
        </div>
      </xsl:otherwise>
    </xsl:choose>


<!--       Here put in dynamic search mask
      <table border="0" width="90%">
        <xsl:choose>
          <xsl:when test="@errorServlet">
            MCRErrorServlet generated this page
            <tr>
              <td class="errormain">
                <xsl:call-template name="lf2br">
                  <xsl:with-param name="string" select="text()" />
                </xsl:call-template>
                <p>
                  <xsl:value-of select="i18n:translate('error.requestURI',@requestURI)" />
                </p>
              </td>
            </tr>
            <xsl:if test="exception">
              <tr>
                <td class="errortrace">
                  <p>
                    <xsl:value-of select="concat(i18n:translate('error.stackTrace'),' :')" />
                  </p>
                  <xsl:for-each select="exception/trace">
                    <pre style="font-size:0.8em;">
                      <xsl:value-of select="." />
                    </pre>
                  </xsl:for-each>
                </td>
              </tr>
            </xsl:if>
          </xsl:when>
          <xsl:otherwise>
            MCRServlet.generateErrorMessage() was called
            <tr>
              <td class="errormain">
                <xsl:value-of select="concat(i18n:translate('error.intro'),' :')" />
              </td>
            </tr>
            <tr>
              <td class="errortrace">
                <pre>
                  <xsl:value-of select="text()" />
                </pre>
              </td>
            </tr>
            <tr>
              <xsl:choose>
                <xsl:when test="exception">
                  <td class="errortrace">
                    <p>
                      <xsl:value-of select="concat(i18n:translate('error.stackTrace'),' :')" />
                    </p>
                    <xsl:for-each select="exception/trace">
                      <pre style="font-size:0.8em;">
                        <xsl:value-of select="." />
                      </pre>
                    </xsl:for-each>
                  </td>
                </xsl:when>
                <xsl:otherwise>
                  <td class="errortrace" style="text-align:center;">
                    <xsl:value-of select="i18n:translate('error.noInfo')" />
                  </td>
                </xsl:otherwise>
              </xsl:choose>
            </tr>
          </xsl:otherwise>
        </xsl:choose>
      </table>
 -->
  </xsl:template>
  <xsl:include href="MyCoReLayout.xsl" />
</xsl:stylesheet>
