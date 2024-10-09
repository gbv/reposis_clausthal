<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:i18n="xalan://org.mycore.services.i18n.MCRTranslation"
  xmlns:ex="http://exslt.org/dates-and-times" exclude-result-prefixes="i18n ex">

  <xsl:import href="xslImport:modsmeta:metadata/mir-epusta.xsl" />

  <xsl:param name="MIR.ePuSta" select="'hide'" />
  <xsl:param name="MIR.ePuSta.Prefix" />
  <xsl:param name="MIR.ePuSta.GraphProviderURL" />
  <xsl:param name="MIR.ePuSta.providerURL" />

  <xsl:template match="/">
    <xsl:if test="$MIR.ePuSta = 'show'">
      <xsl:variable name="ID" select="/mycoreobject/@ID" />
      <xsl:variable name="now" select="ex:date-time()"/>
      <xsl:variable name="now-1year">
        <xsl:choose>
          <xsl:when test="ex:monthInYear($now) = 2 and ex:dayInMonth($now) = 29">
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
      <div id="mir-epusta">
        <div class="card">
          <div class="card-header d-flex justify-content-between align-items-center">
            <h3 class="card-title">
              <xsl:value-of select="i18n:translate('mir.epusta.panelheading')" />
            </h3>
            <img src="{$WebApplicationBaseURL}images/epusta/epustalogo_small.png" class="mir-epusta-logo" />
          </div>
          <div class="card-body">
            <span>
              <strong>
                <xsl:value-of select="concat(i18n:translate('mir.epusta.total'),':')" />
              </strong>
            </span>
            <div class="row">
              <div class="col-md-7 col-sm-9 col-6 text-right">
                <xsl:value-of select="i18n:translate('mir.epusta.counter.fulltext')" />
              </div>
              <div
                  data-epustaelementtype="ePuStaInline"
                  data-epustaproviderurl="{$MIR.ePuSta.providerURL}"
                  data-epustaidentifier="{$MIR.ePuSta.Prefix}{$objID}"
                  data-epustacounttype="counter"
              />
            </div>
            <div class="row">
              <div class="col-md-7 col-sm-9 col-6 text-right">
                <xsl:value-of select="i18n:translate('mir.epusta.counter.abstract')" />
              </div>
              <div
                  data-epustaelementtype="ePuStaInline"
                  data-epustaproviderurl="{$MIR.ePuSta.providerURL}"
                  data-epustaidentifier="{$MIR.ePuSta.Prefix}{$objID}"
                  data-epustacounttype="counter_abstract"
              />
            </div>
            <span>
              <strong>
                <xsl:value-of select="concat(i18n:translate('mir.epusta.last12Month'),':')" />
              </strong>
            </span>
            <div class="row">
              <div class="col-md-7 col-sm-9 col-6 text-right">
                <xsl:value-of select="i18n:translate('mir.epusta.counter.fulltext')" />
              </div>
              <div
                  data-epustaelementtype="ePuStaInline"
                  data-epustaproviderurl="{$MIR.ePuSta.providerURL}"
                  data-epustaidentifier="{$MIR.ePuSta.Prefix}{$objID}"
                  data-epustacounttype="counter"
                  data-epustafrom="{$from}" data-epustauntil="{$until}"
              />
            </div>
            <div class="row">
              <div class="col-md-7 col-sm-9 col-6 text-right">
                <xsl:value-of select="i18n:translate('mir.epusta.counter.abstract')" />
              </div>
              <div data-epustaelementtype="ePuStaInline"
                   data-epustaproviderurl="{$MIR.ePuSta.providerURL}"
                   data-epustaidentifier="{$MIR.ePuSta.Prefix}{$objID}"
                   data-epustacounttype="counter_abstract"
                   data-epustafrom="{$from}" data-epustauntil="{$until}"
              />
            </div>
            <div class="text-right">
              <a href="#" data-toggle="modal" data-target="#epustaGraphModal">
                <xsl:value-of select="i18n:translate('mir.epusta.open')" />
              </a>
            </div>
            <div
              class="modal fade"
              id="epustaGraphModal"
              tabindex="-1"
              role="dialog"
              aria-labelledby="epustaGraphTitel"
              aria-hidden="true">
              <div class="modal-dialog" role="document">
                <div class="modal-content">
                  <div class="modal-header">
                    <h4 class="modal-title " id="epustaGraphTitel">
                      <xsl:value-of select="i18n:translate('mir.epusta.panelheading')" />
                    </h4>
                    <button
                      type="button"
                      class="close modalFrame-cancel"
                      data-dismiss="modal"
                      aria-label="Close">
                      <i class="fas fa-times" aria-hidden="true"></i>
                    </button>
                  </div>
                  <div class="modal-body">
                    <div id="epustaGraph" class="mir-epusta-graph"/>
                    <div class="row mir-epusta-graph-controls" style="margin-top:13px">
                      <div class="col-md-12 text-center">
                        <!--<select id="epustaGraphSelect" class="form-select" onchange="changeEpustaGraphSelect();" style="margin-top:10px">
                          <option value='day'>letzten 30 Tage</option>
                          <option value='month'>letzten 12 Monate</option>
                          <option value='year'>letzten 10 Jahre</option>
                        </select>-->
                        die letzten:
                        <input style="margin-left:6px" type="radio" id="grday" name="granularity" value="day" onchange="changeEpustaGraphSelect();" checked="checked"/>
                        <label for="grday">30 Tage</label>
                        <input style="margin-left:13px" type="radio" id="grmonth" name="granularity" value="month" onchange="changeEpustaGraphSelect();" />
                        <label for="grday">12 Monate</label>
                        <input style="margin-left:13px" type="radio" id="gryear" name="granularity" value="year" onchange="changeEpustaGraphSelect();" />
                        <label for="grday">10 Jahre</label>
                      </div>
                    </div>
                  </div>
                  <div class="modal-footer">
                    <img
                      src="{$WebApplicationBaseURL}images/epusta/epustalogo.png"
                      class="mir-epusta-logo" />
                  </div>
                </div>
              </div>
            </div>
            <script type="module" src="{$WebApplicationBaseURL}assets/epusta_elements.js/epusta_elements.js" ></script>
            <script type="module" src="{$WebApplicationBaseURL}assets/chart.js/chart.umd.js" ></script>
            <script type="module">
              import {ePuStaGraph} from "<xsl:value-of select="$WebApplicationBaseURL"/>assets/epusta_elements.js/epusta_elements.js";
              
              var graph = document.getElementById('epustaGraph');
              var graphSelect = document.getElementById('epustaGraphSelect');
              var granularity = 'day' ;
              var epustaProviderurl='<xsl:value-of select="$MIR.ePuSta.providerURL"/>';
              var identifier='<xsl:value-of select="$objID"/>';
              var from='auto';
              var until='<xsl:value-of select="$until"/>';
              //var tagQuery = "-epusta:filter:httpMethod -epusta:filter:httpStatus -filter:30sek:counter3 -filter:robot oas:content:counter";
              var labelsByTagQuery = [
                {
                  label: "Volltextzugriffe",
                  //color: "#003259",
                  color: "#3b617f",
                  tagquery: "-epusta:filter:httpMethod -epusta:filter:httpStatus -filter:30sek:counter3 -filter:robot oas:content:counter"
                },
                {
                  label: "Metadatenansichten",
                  //color: "#e40c31",
                  color: "#eb4a66",
                  tagquery: "-epusta:filter:httpMethod -epusta:filter:httpStatus -filter:30sek:counter3 -filter:robot oas:content:counter_abstract"
                }
              ];
              
              $('#epustaGraphModal').on('shown.bs.modal', function () {
                var granularity = document.querySelector('input[name="granularity"]:checked').value;
                var epustaElement = new ePuStaGraph(graph,epustaProviderurl,identifier,from,until,labelsByTagQuery,granularity)
                epustaElement.requestData();
              })
              function changeFunc() {
                var granularity = document.querySelector('input[name="granularity"]:checked').value; 
                var epustaElement = new ePuStaGraph(graph,epustaProviderurl,identifier,from,until,labelsByTagQuery,granularity)
                epustaElement.requestData();
              }
              window.changeEpustaGraphSelect = changeFunc;
            </script>
          </div>
        </div>
      </div>
    </xsl:if>
    <xsl:apply-imports />
  </xsl:template>

</xsl:stylesheet>
