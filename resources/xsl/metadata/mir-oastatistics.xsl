<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:i18n="xalan://org.mycore.services.i18n.MCRTranslation"
  xmlns:ex="http://exslt.org/dates-and-times" exclude-result-prefixes="i18n ex">

  <xsl:import href="xslImport:modsmeta:metadata/mir-oastatistics.xsl" />

  <xsl:param name="MIR.OAS" select="'hide'" />
  <xsl:param name="MIR.OAS.Prefix" />
  <xsl:param name="MIR.OAS.GraphProviderURL" />

  <xsl:template match="/">
    <xsl:if test="$MIR.OAS = 'show'">
      <xsl:variable name="ID" select="/mycoreobject/@ID" />
      <xsl:variable name="now" select="ex:date-time()"/>
      <xsl:variable name="now-1year">
        <xsl:choose>
          <xsl:when test="ex:monthInYear($now) = 9 and ex:dayInMonth($now) = 29">
            <xsl:value-of select="concat(ex:year($now)-1,'-02-28')" />
          </xsl:when>
          <xsl:when test="ex:monthInYear($now) &gt; 9 and ex:dayInMonth($now) &gt; 9">
            <xsl:value-of select="concat(ex:year($now)-1,'-',ex:monthInYear($now),'-',ex:dayInMonth($now))" />
          </xsl:when>
          <xsl:when test="ex:monthInYear($now) &gt; 9 ">
            <xsl:value-of select="concat(ex:year($now)-1,'-',ex:monthInYear($now),'-0',ex:dayInMonth($now))" />
          </xsl:when>
          <xsl:when test="ex:dayInMonth($now) &gt; 9">
            <xsl:value-of select="concat(ex:year($now)-1,'-0',ex:monthInYear($now),'-',ex:dayInMonth($now))" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="concat(ex:year($now)-1,'-0',ex:monthInYear($now),'-0',ex:dayInMonth($now))" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="from" select="$now-1year" />
      <xsl:variable name="until" select="ex:format-date($now,'yyyy-MM-dd')" />
      <xsl:variable name="objID" select="mycoreobject/@ID" />
      <div id="mir-oastatistics">
        <span><strong><xsl:value-of select="concat(i18n:translate('mir.oas.total'),':')" /></strong></span>
        <div class="row">
          <div class="col-md-7 col-sm-9 col-xs-6 text-right"><xsl:value-of select="i18n:translate('mir.oas.counter.fulltext')" /></div>
          <div  data-oaselementtype="OASInline"
              data-oasproviderurl="{$MIR.OAS.GraphProviderURL}"
              data-oasidentifier="{$MIR.OAS.Prefix}{$objID}"
              data-oascounttype="counter"
          />
        </div>
        <div class="row">
          <div class="col-md-7 col-sm-9 col-xs-6 text-right"><xsl:value-of select="i18n:translate('mir.oas.counter.abstract')" /></div>
          <div  data-oaselementtype="OASInline"
              data-oasproviderurl="{$MIR.OAS.GraphProviderURL}"
              data-oasidentifier="{$MIR.OAS.Prefix}{$objID}"
              data-oascounttype="counter_abstract"
          />
        </div>
        <span><strong><xsl:value-of select="concat(i18n:translate('mir.oas.last12Month'),':')" /></strong></span>
        <div class="row">
          <div class="col-md-7 col-sm-9 col-xs-6 text-right"><xsl:value-of select="i18n:translate('mir.oas.counter.fulltext')" /></div>
          <div  data-oaselementtype="OASInline"
              data-oasproviderurl="{$MIR.OAS.GraphProviderURL}"
              data-oasidentifier="{$MIR.OAS.Prefix}{$objID}"
              data-oascounttype="counter"
              data-oasfrom="{$from}" data-oasuntil="{$until}"
          />
        </div>
        <div class="row">
          <div class="col-md-7 col-sm-9 col-xs-6 text-right"><xsl:value-of select="i18n:translate('mir.oas.counter.abstract')" /></div>
          <div data-oaselementtype="OASInline"
            data-oasproviderurl="{$MIR.OAS.GraphProviderURL}" 
              data-oasidentifier="{$MIR.OAS.Prefix}{$objID}"
              data-oascounttype="counter_abstract"
              data-oasfrom="{$from}" data-oasuntil="{$until}"
          />
        </div>
        <p class="text-right">
          <a href="#" data-toggle="modal" data-target="#oasGraphModal"><xsl:value-of select="i18n:translate('mir.oas.open')" /></a>
        </p>
        <div class="modal fade" id="oasGraphModal" tabindex="-1" role="dialog" aria-labelledby="oasGraphTitel" aria-hidden="true">
          <div class="modal-dialog" role="document">
            <div class="modal-content">
              <div class="modal-header">
                <div class="row">
                  <h4 class="modal-title col-md-9" id="oasGraphTitel">
                    <xsl:value-of select="i18n:translate('mir.oas.panelheading')" />
                  </h4>
                  <div class="col-md-3">
                    <button
                      type="button"
                      class="close modalFrame-cancel"
                      data-dismiss="modal"
                      aria-label="Close">
                      <i class="fa fa-times" aria-hidden="true"></i>
                    </button>
                  </div>
                </div>
              </div>
              <div class="modal-body">
                <div id="oasGraph" style="width:100%;height:200px;"
                    data-oaselementtype="OASGraph"
                    data-oasproviderurl="{$MIR.OAS.GraphProviderURL}"
                    data-oasidentifier="{$MIR.OAS.Prefix}{$objID}"
                    data-oasfrom="{$from}" data-oasuntil="{$until}"
                />
              </div>
              <div class="modal-footer">
                <img src="{$WebApplicationBaseURL}images/epusta/epustalogo.png" style="height: 40px;"/>
              </div>
            </div>
          </div>
        </div>
        <script src="{$MIR.OAS.GraphProviderURL}includes/raphael-2.1.2/raphael-min.js"></script>
        <script src="{$MIR.OAS.GraphProviderURL}includes/morris.js-0.5.1/morris.js"></script>
        <script src="{$WebApplicationBaseURL}js/oa-statistic.min.js" ></script>
        <style type="text/css"> @import url("<xsl:value-of select="$MIR.OAS.GraphProviderURL" />includes/morris.js-0.5.1/morris.css"); </style>
      </div>
    </xsl:if>
    <xsl:apply-imports />
  </xsl:template>

</xsl:stylesheet>