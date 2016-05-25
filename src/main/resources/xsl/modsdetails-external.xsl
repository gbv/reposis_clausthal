<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xalan"
  xmlns:i18n="xalan://org.mycore.services.i18n.MCRTranslation" xmlns:mcrmods="xalan://org.mycore.mods.MCRMODSClassificationSupport"
  xmlns:basket="xalan://org.mycore.frontend.basket.MCRBasketManager" xmlns:acl="xalan://org.mycore.access.MCRAccessManager" xmlns:mcr="http://www.mycore.org/"
  xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:mods="http://www.loc.gov/mods/v3" xmlns:mcrxsl="xalan://org.mycore.common.xml.MCRXMLFunctions" xmlns:mcrurn="xalan://org.mycore.urn.MCRXMLFunctions"
  exclude-result-prefixes="basket xalan xlink mcr i18n acl mods mcrmods mcrxsl mcrurn" version="1.0" xmlns:ex="http://exslt.org/dates-and-times"
  extension-element-prefixes="ex">

  <!-- do nothing for display parent -->
  <xsl:template match="/mycoreobject" mode="parent" priority="1">
  </xsl:template>

  <xsl:template mode="printDerivatesThumb" match="/mycoreobject[contains(@ID,'_mods_')]" priority="1">
    <xsl:param name="staticURL" />
    <xsl:param name="layout" />
    <xsl:param name="xmltempl" />
    <xsl:param name="modsType" select="'report'" />
    <xsl:variable name="suffix">
      <xsl:if test="string-length($layout)&gt;0">
        <xsl:value-of select="concat('&amp;layout=',$layout)" />
      </xsl:if>
    </xsl:variable>
    <xsl:if test="./structure/derobjects">
      <xsl:variable name="derivtitle" select="./structure/derobjects/derobject/@xlink:title" />
      <div class="hit_symbol">
        <xsl:variable name="embargo" select="metadata/def.modsContainer/modsContainer/mods:mods/mods:accessCondition[@type='embargo']" />
        <xsl:choose>
          <xsl:when test="mcrxsl:isCurrentUserGuestUser() and count($embargo) &gt; 0 and mcrxsl:compare(string($embargo),ex:date-time()) &gt; 0">
            <!-- embargo is active for guest user -->
            <img src="{$WebApplicationBaseURL}templates/master/{$template}/IMAGES/icons_liste/big/icon_{$modsType}.png" alt="Link to {$derivtitle}" title="{$derivtitle}" />
          </xsl:when>
          <xsl:when test="$objectHost != 'local'">
            <img src="{$WebApplicationBaseURL}templates/master/{$template}/IMAGES/icons_liste/big/icon_{$modsType}.png" alt="Link to {$derivtitle}" title="{$derivtitle}" />
            <a href="{$staticURL}">nur auf original Server</a>
          </xsl:when>
          <xsl:otherwise>
            <xsl:variable name="deriv" select="./structure/derobjects/derobject/@xlink:href" />
            <xsl:variable name="derivlink" select="concat('mcrobject:',$deriv)" />
            <xsl:variable name="derivate" select="document($derivlink)" />
            <xsl:variable name="derivid" select="$derivate/mycorederivate/@ID" />
            <xsl:variable name="derivmain" select="$derivate/mycorederivate/derivate/internals/internal/@maindoc" />
            <xsl:variable name="derivbase" select="concat($ServletsBaseURL,'MCRFileNodeServlet/',$derivid,'/')" />
            <xsl:variable name="derivifs" select="concat($derivbase,$derivmain,$HttpSession)" />

            <xsl:variable name="contentType" select="document(concat('ifs:/',$deriv))/mcr_directory/children/child[name=$derivmain]/contentType" />
            <xsl:variable name="fileType" select="document('webapp:FileContentTypes.xml')/FileContentTypes/type[@ID=$contentType]//extension" />
            <a href="{$derivifs}" id="deriv_link">
              <img src="{$WebApplicationBaseURL}templates/master/{$template}/IMAGES/icons_liste/big/icon_{$modsType}.png" alt="Link to {$derivtitle}" title="{$derivtitle}" id="deriv_icon" />
              <xsl:choose>
                <xsl:when test="$fileType='pdf' or $fileType='msexcel' or $fileType='xlsx' or $fileType='msword97' or $fileType='docx'">
                  <img src="{$WebApplicationBaseURL}templates/master/{$template}/IMAGES/icons_liste/download_{$fileType}.png" alt="{$derivmain}"
                    title="{$derivmain}" id="deriv_filetype" />
                </xsl:when>
                <xsl:otherwise>
                  <img src="{$WebApplicationBaseURL}templates/master/{$template}/IMAGES/icons_liste/download_default.png" alt="{$derivmain}"
                    title="{$derivmain}" id="deriv_filetype" />
                </xsl:otherwise>
              </xsl:choose>
            </a>
            <a href="#derivateDetails" id="toDerivateDetails">Details</a>
           </xsl:otherwise>
        </xsl:choose>
      </div>
    </xsl:if>
  </xsl:template>

  <xsl:template match="mods:accessCondition" mode="rights_reserved" priority="1">
    <img>
      <xsl:attribute name="src">
        <xsl:value-of select="concat($WebApplicationBaseURL, 'templates/master/', $template , '/IMAGES/copyright.png')" />
      </xsl:attribute>
      <xsl:attribute name="alt">
        <xsl:value-of select="i18n:translate('component.mods.metaData.dictionary.rightsReserved')" />
      </xsl:attribute>
    </img>
  </xsl:template>

  <xsl:template match="children" mode="printChildren" priority="1">
    <xsl:param name="label" select="'enthält'" />

    <!-- the for-each would iterate over <id> with root not beeing /mycoreobject so we save the current node in variable context to access
      needed nodes -->
    <xsl:variable name="context" select="/mycoreobject" />

    <xsl:variable name="children" select="$context/structure/children/child[not(mcrxsl:isCurrentUserGuestUser()) or
                                          mcrxsl:isInCategory(@xlink:href,'clausthal_status:published')]" />

    <xsl:variable name="maxElements" select="20" />
    <xsl:variable name="positionMin">
      <xsl:choose>
        <xsl:when test="count($children) &gt; $maxElements">
          <xsl:value-of select="count($children) - $maxElements + 1" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="0" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <tr>
      <td valign="top" class="metaname">
        <xsl:value-of select="concat($label,':')" />
      </td>
      <td class="metavalue">
        <xsl:if test="$positionMin != 0">
          <p>
             <xsl:choose>
              <xsl:when test="not(mcrxsl:isCurrentUserGuestUser())">
                <a href="{$ServletsBaseURL}solr/parent?q={$context/@ID}&amp;fq=">
                  <xsl:value-of select="i18n:translate('component.mods.metaData.displayAll')" />
                </a>
              </xsl:when>
              <xsl:otherwise>
                <a href="{$ServletsBaseURL}solr/parent?q={$context/@ID}">
                  <xsl:value-of select="i18n:translate('component.mods.metaData.displayAll')" />
                </a>
              </xsl:otherwise>
            </xsl:choose>
          </p>
        </xsl:if>
        <xsl:choose>
          <xsl:when test="count($children) &gt; 1">
            <!-- display recent $maxElements only -->
            <ul class="document_children">
              <xsl:for-each select="$children[position() &gt;= $positionMin]">
                <li>
                <xsl:call-template name="objectLink">
                  <xsl:with-param name="obj_id" select="@xlink:href" />
                </xsl:call-template>
                </li>
              </xsl:for-each>
            </ul>
          </xsl:when>
          <xsl:otherwise>
                <xsl:call-template name="objectLink">
              <xsl:with-param name="obj_id" select="$children/@xlink:href" />
                </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </td>
    </tr>
  </xsl:template>


  <xsl:template match="/mycoreobject" mode="breadCrumb" priority="1">

    <li class="first">
      <a href="{$WebApplicationBaseURL}">
      <!-- Linktext ist der Haupttitel aus mycore.properties.wcms-->
      <xsl:value-of select="$MainTitle" />
      </a>
    </li>
    <li>
      <a href="#"><xsl:value-of select="'Detailansicht'" /></a>
    </li>
    <xsl:variable name="obj_host">
      <xsl:value-of select="$objectHost" />
    </xsl:variable>
    <xsl:if test="./structure/parents">
      <xsl:variable name="parent_genre">
        <xsl:apply-templates mode="mods-type" select="document(concat('mcrobject:',./structure/parents/parent/@xlink:href))/mycoreobject" />
      </xsl:variable>
      <li>
        <xsl:value-of select="i18n:translate(concat('component.mods.metaData.dictionary.', $parent_genre))" />
        <xsl:text>: </xsl:text>
        <xsl:apply-templates select="./structure/parents">
          <xsl:with-param name="obj_host" select="$obj_host" />
          <xsl:with-param name="obj_type" select="'this'" />
        </xsl:apply-templates>
        <xsl:apply-templates select="./structure/parents">
          <xsl:with-param name="obj_host" select="$obj_host" />
          <xsl:with-param name="obj_type" select="'before'" />
        </xsl:apply-templates>
        <xsl:apply-templates select="./structure/parents">
          <xsl:with-param name="obj_host" select="$obj_host" />
          <xsl:with-param name="obj_type" select="'after'" />
        </xsl:apply-templates>
      </li>
    </xsl:if>

    <xsl:variable name="internal_genre">
      <xsl:apply-templates mode="mods-type" select="." />
    </xsl:variable>
    <li>
      <xsl:value-of select="i18n:translate(concat('component.mods.metaData.dictionary.', $internal_genre))" />
    </li>
    <xsl:if test="./metadata/def.modsContainer/modsContainer/mods:mods/mods:genre[@type='kindof']">
      <li>
        <xsl:apply-templates select="./metadata/def.modsContainer/modsContainer/mods:mods/mods:genre[@type='kindof']"
          mode="printModsClassInfo" />
      </li>
    </xsl:if>
  </xsl:template>

  <xsl:template mode="printDerivates" match="/mycoreobject[contains(@ID,'_mods_')]" priority="2">
    <xsl:param name="staticURL" />
    <xsl:param name="layout" />
    <xsl:param name="xmltempl" />
    <xsl:variable name="suffix">
      <xsl:if test="string-length($layout)&gt;0">
        <xsl:value-of select="concat('&amp;layout=',$layout)" />
      </xsl:if>
    </xsl:variable>
    <xsl:if test="./structure/derobjects">
      <xsl:variable name="parentObjID" select="./@ID" />
      <xsl:variable name="embargo" select="./metadata/def.modsContainer/modsContainer/mods:mods/mods:accessCondition[@type='embargo']" />
      <tr>
        <td style="vertical-align:top;" class="metaname">
          <xsl:value-of select="concat(i18n:translate('component.mods.metaData.[derivates]'), ':')" />
        </td>
        <td class="metavalue">
          <xsl:if test="$objectHost != 'local'">
            <a href="{$staticURL}">nur auf original Server</a>
          </xsl:if>
          <xsl:if test="$objectHost = 'local'">
            <xsl:for-each select="./structure/derobjects/derobject">
              <xsl:variable select="@xlink:href" name="deriv" />

              <div class="derivateBox">
                <xsl:variable select="concat('mcrobject:',$deriv)" name="derivlink" />
                <xsl:variable select="document($derivlink)" name="derivate" />
                <xsl:variable name="derivateWithURN" select="mcrurn:hasURNDefined($deriv)" />

                <xsl:variable name="derivid" select="$derivate/mycorederivate/@ID" />
                <xsl:variable name="derivlabel" select="$derivate/mycorederivate/@label" />
                <xsl:variable name="derivmain" select="$derivate/mycorederivate/derivate/internals/internal/@maindoc" />
                <xsl:variable name="derivbase" select="concat($ServletsBaseURL,'MCRFileNodeServlet/',$derivid,'/')" />
                <xsl:variable name="derivifs" select="concat($derivbase,$derivmain,$HttpSession)" />
                <xsl:variable name="derivdir" select="concat($derivbase,$HttpSession)" />

                <xsl:variable name="contentTypes" select="document('resource:FileContentTypes.xml')/FileContentTypes" />
                <xsl:variable name="fileType" select="document(concat('ifs:/',@xlink:href,'/'))/mcr_directory/children/child[name=$derivmain]/contentType" />

                <a name="derivateDetails" />
                <div class="derivateHeading"><xsl:value-of select="$derivlabel" /></div>
                <div class="subcolumns">
                  <div class="c85l">
                    <div class="derivateURN">
                      <xsl:if test="$derivateWithURN">
                        <xsl:variable name="derivateURN" select="$derivate/mycorederivate/derivate/fileset/@urn" />
                        <a href="{concat('http://nbn-resolving.de/urn/resolver.pl?urn=',$derivateURN)}">
                          <xsl:value-of select="$derivateURN" />
                        </a>
                      </xsl:if>
                    </div>
                  </div>
                  <div class="c15r">
                    <div class="hit_links">
                      <xsl:choose>
                        <xsl:when test="mcrxsl:isCurrentUserGuestUser() and count($embargo) &gt; 0 and mcrxsl:compare(string($embargo),ex:date-time()) &gt; 0">
                          <!-- embargo is active for guest user -->
                          <xsl:value-of select="i18n:translate('component.mods.metaData.dictionary.accessCondition.embargo.available',$embargo)" />
                        </xsl:when>
                        <xsl:otherwise>
                          <a href="{$derivifs}">
                            <xsl:choose>
                              <xsl:when test="$fileType='pdf' or $fileType='msexcel' or $fileType='xlsx' or $fileType='msword97' or $fileType='docx'">
                                <img src="{$WebApplicationBaseURL}templates/master/{$template}/IMAGES/icons_liste/download_{$fileType}.png" alt="{$derivmain}"
                                  title="{$derivmain}" />
                              </xsl:when>
                              <xsl:otherwise>
                                <img src="{$WebApplicationBaseURL}templates/master/{$template}/IMAGES/icons_liste/download_default.png" alt="{$derivmain}"
                                  title="{$derivmain}" />
                              </xsl:otherwise>
                            </xsl:choose>
                          </a>
                          <a href="{$derivdir}">
                          <!-- xsl:value-of select="i18n:translate('buttons.details')" / -->
                            <img src="{$WebApplicationBaseURL}templates/master/{$template}/IMAGES/icons_liste/download_details.png" alt="Details"
                              title="Details" style="padding-bottom:2px;" />
                          </a>
                        </xsl:otherwise>
                      </xsl:choose>
                    </div>
                  </div>
                </div>

                <xsl:if test="acl:checkPermission(./@xlink:href,'writedb')">
                  <div class="derivate_options">
                    <img class="button_options" src="{$WebApplicationBaseURL}templates/master/{$template}/IMAGES/icon_arrow_circled_red_down.png"
                         alt="" title="{i18n:translate('component.mods.metaData.options')}" />
                    <div class="options">
                      <ul>
                        <xsl:if test="$derivateWithURN=false()">
                          <li>
                            <a href="{$ServletsBaseURL}derivate/update{$HttpSession}?objectid={../../../@ID}&amp;id={@xlink:href}{$suffix}">
                              <xsl:value-of select="i18n:translate('component.swf.derivate.addFile')" />
                            </a>
                          </li>
                        </xsl:if>
                        <li>
                          <xsl:if test="not($derivateWithURN=false() and mcrxsl:isAllowedObjectForURNAssignment($parentObjID))">
                            <xsl:attribute name="class">last</xsl:attribute>
                          </xsl:if>
                          <a href="{$ServletsBaseURL}derivate/update{$HttpSession}?id={@xlink:href}{$suffix}">
                            <xsl:value-of select="i18n:translate('component.swf.derivate.editDerivate')" />
                          </a>
                        </li>
                        <xsl:if test="$derivateWithURN=false() and mcrxsl:isAllowedObjectForURNAssignment($parentObjID)">
                          <xsl:variable name="apos">
                            <xsl:text>'</xsl:text>
                          </xsl:variable>
                          <li>
                            <xsl:if test="not(acl:checkPermission(./@xlink:href,'deletedb'))">
                              <xsl:attribute name="class">last</xsl:attribute>
                            </xsl:if>
                            <a href="{$ServletsBaseURL}MCRAddURNToObjectServlet{$HttpSession}?object={@xlink:href}" onclick="{concat('return confirm(',$apos, i18n:translate('component.mods.metaData.options.urn.confirm'), $apos, ');')}">
                              <xsl:value-of select="i18n:translate('component.mods.metaData.options.urn')" />
                            </a>
                          </li>
                        </xsl:if>
                        <xsl:if test="acl:checkPermission(./@xlink:href,'deletedb') and $derivateWithURN=false()">
                          <li class="last">
                            <a href="{$ServletsBaseURL}derivate/delete{$HttpSession}?id={@xlink:href}" class="confirm_derivate_deletion">
                              <xsl:value-of select="i18n:translate('component.swf.derivate.delDerivate')" />
                            </a>
                          </li>
                        </xsl:if>
                      </ul>
                    </div>
                  </div>
                </xsl:if>
              </div>
            </xsl:for-each>
          </xsl:if>
        </td>
      </tr>
    </xsl:if>
  </xsl:template>

  <xsl:template match="mods:name" mode="printName" priority="2">
    <xsl:choose>
      <xsl:when test="@valueURI">
        <!-- derived from printModsClassInfo template -->
        <xsl:variable name="classlink" select="mcrmods:getClassCategParentLink(.)" />
        <xsl:choose>
          <xsl:when test="string-length($classlink) &gt; 0">
            <xsl:for-each select="document($classlink)/mycoreclass//category[position()=1 or position()=last()]">
              <xsl:if test="position() > 1">
                <xsl:value-of select="', '" />
              </xsl:if>
              <xsl:apply-templates select="." mode="printModsClassInfo" />
            </xsl:for-each>
          </xsl:when>
          <xsl:when test="contains(@valueURI, 'http://d-nb.info/gnd/')">
            <xsl:variable name="gnd" select="substring-after(@valueURI, 'http://d-nb.info/gnd/')" />
            <a href="{$ServletsBaseURL}solr/mods_gnd?q={$gnd}">
              <xsl:choose>
                <xsl:when test="mods:displayForm">
                  <xsl:value-of select="mods:displayForm" />
                </xsl:when>
                <xsl:when test="@displayLabel">
                  <xsl:value-of select="@displayLabel" />
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="@valueURI" />
                </xsl:otherwise>
              </xsl:choose>
            </a>
            <a class="gnd" href="{@valueURI}" title="{@valueURI}">
              <!-- img src="{$WebApplicationBaseURL}templates/master/{$template}/IMAGES/icon_gnd.gif" alt="Link zur GND" title="{@valueURI}" /-->
              GND
            </a>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates select="." mode="hrefLink" />
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="displayName">
          <xsl:choose>
            <xsl:when test="mods:namePart">
              <xsl:choose>
                <xsl:when test="mods:namePart[@type='given'] and mods:namePart[@type='family']">
                  <xsl:value-of select="concat(mods:namePart[@type='family'], ', ',mods:namePart[@type='given'])" />
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="mods:namePart" />
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:when test="mods:displayForm">
              <xsl:value-of select="mods:displayForm" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="." />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <a href="{$ServletsBaseURL}solr/mods_name?q=%22{$displayName}%22">
          <xsl:value-of select="$displayName" />
        </a>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="/mycoreobject[contains(@ID,'_mods_')]" mode="externalObjectActions">
    <!-- add here your application specific edit menu entries, as <li />  -->
    <xsl:variable name="mods-type">
      <xsl:apply-templates mode="mods-type" select="." />
    </xsl:variable>
    <!-- journal,series,book,confpro -->
    <xsl:if test="$mods-type='journal' or $mods-type='series' or $mods-type='book' or $mods-type='confpro'">
      <li><a href="{$WebApplicationBaseURL}rsc/moveObj/start?objId={@ID}">Artikel verschieben</a></li>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>