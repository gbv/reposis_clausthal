<?xml version="1.0" encoding="ISO-8859-1"?>

<!-- XSL to display data of a login user -->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xalan="http://xml.apache.org/xalan"
  xmlns:mcrxsl="xalan://org.mycore.common.xml.MCRXMLFunctions" xmlns:acl="xalan://org.mycore.access.MCRAccessManager" xmlns:i18n="xalan://org.mycore.services.i18n.MCRTranslation"
  xmlns:const="xalan://org.mycore.user2.MCRUser2Constants" exclude-result-prefixes="xsl xalan i18n acl const mcrxsl">

  <xsl:include href="MyCoReLayout.xsl" />

  <xsl:variable name="PageID" select="'show-user'" />

  <xsl:variable name="PageTitle" select="concat(i18n:translate('component.user2.admin.userDisplay'),' ',/user/@name)" />

  <xsl:param name="step" />

  <xsl:variable name="uid">
    <xsl:value-of select="/user/@name" />
    <xsl:if test="not ( /user/@realm = 'local' )">
      <xsl:text>@</xsl:text>
      <xsl:value-of select="/user/@realm" />
    </xsl:if>
  </xsl:variable>
  <xsl:variable name="owns" select="document(concat('user:getOwnedUsers:',$uid))/owns" />

  <xsl:template match="user" mode="actions">
    <xsl:variable name="isCurrentUser" select="$CurrentUser = /user/@name"/>
    <xsl:if test="(string-length($step) = 0) or ($step = 'changedPassword')">
      <xsl:variable name="isUserAdmin" select="acl:checkPermission(const:getUserAdminPermission())" />
      <li>
        <xsl:choose>
          <xsl:when test="$isUserAdmin">
            <a href="{$WebApplicationBaseURL}authorization/change-user.xed?action=save&amp;id={$uid}">
              <xsl:value-of select="i18n:translate('component.user2.admin.changedata')" />
            </a>
          </xsl:when>
          <xsl:when test="not($isCurrentUser)">
            <a href="{$WebApplicationBaseURL}authorization/change-read-user.xed?action=save&amp;id={$uid}">
              <xsl:value-of select="i18n:translate('component.user2.admin.changedata')" />
            </a>
          </xsl:when>
          <xsl:when test="$isCurrentUser and not(/user/@locked = 'true')">
            <a href="{$WebApplicationBaseURL}authorization/change-current-user.xed?action=saveCurrentUser">
              <xsl:value-of select="i18n:translate('component.user2.admin.changedata')" />
            </a>
          </xsl:when>
        </xsl:choose>
      </li>
      <xsl:if test="/user/@realm = 'local' and (not($isCurrentUser) or not(/user/@locked = 'true'))">
        <li>
          <a href="{$WebApplicationBaseURL}authorization/change-password.xed?action=password&amp;id={$uid}">
            <xsl:value-of select="i18n:translate('component.user2.admin.changepw')" />
          </a>
        </li>
      </xsl:if>
      <xsl:if test="$isUserAdmin and not($isCurrentUser)">
        <li>
          <a href="{$WebApplicationBaseURL}servlets/MCRUserServlet?action=show&amp;id={$uid}&amp;XSL.step=confirmDelete">
            <xsl:value-of select="i18n:translate('component.user2.admin.userDeleteYes')" />
          </a>
        </li>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <xsl:template match="user">
    <div class="blockbox" id="detail_view">
      <h3><xsl:value-of select="i18n:translate('component.user2.admin.userDisplay')" /></h3>
      <div class="document_options">
        <img title="Dokument Optionen" alt="" src="{$WebApplicationBaseURL}templates/master/template_clausthal/IMAGES/icon_arrow_circled_red_down.png" class="button_options" />
          <div class="options">
            <ul>
              <xsl:apply-templates select="." mode="actions" />
            </ul>
          </div>
      </div>
      <xsl:if test="$step = 'confirmDelete'">
        <div class="section">
          <p>
            <strong>
              <xsl:value-of select="i18n:translate('component.user2.admin.userDeleteRequest')" />
            </strong>
            <br />
            <xsl:value-of select="i18n:translate('component.user2.admin.userDeleteExplain')" />
            <br />
            <xsl:if test="$owns/user">
              <strong>
                <xsl:value-of select="i18n:translate('component.user2.admin.userDeleteExplainRead1')" />
                <xsl:value-of select="count($owns/user)" />
                <xsl:value-of select="i18n:translate('component.user2.admin.userDeleteExplainRead2')" />
              </strong>
            </xsl:if>
          </p>
          <div class="floatbox">
            <form class="action" method="post" action="MCRUserServlet">
              <input name="action" value="delete" type="hidden" />
              <input name="id" value="{$uid}" type="hidden" />
              <input name="XSL.step" value="deleted" type="hidden" />
              <button type="submit" class="user_button float_left" value="{i18n:translate('component.user2.button.deleteYes')}">
               <xsl:value-of select="i18n:translate('component.user2.button.deleteYes')" />
              </button>
            </form>
            <form class="action" method="get" action="MCRUserServlet">
              <input name="action" value="show" type="hidden" />
              <input name="id" value="{$uid}" type="hidden" />
              <button type="submit" class="user_button float_left" value="{i18n:translate('component.user2.button.cancelNo')}">
                <xsl:value-of select="i18n:translate('component.user2.button.cancelNo')" />
              </button>
            </form>
          </div>
        </div>
      </xsl:if>
      <xsl:if test="$step = 'deleted'">
        <div class="section">
          <p>
            <strong>
              <xsl:value-of select="i18n:translate('component.user2.admin.userDeleteConfirm')" />
            </strong>
          </p>
        </div>
      </xsl:if>
      <xsl:if test="$step = 'changedPassword'">
        <div class="section">
          <p>
            <strong>
              <xsl:value-of select="i18n:translate('component.user2.admin.passwordChangeConfirm')" />
            </strong>
          </p>
        </div>
      </xsl:if>
      <div class="detailbox floatbox" id="title_box">
        <h4 class="block_switch open" id="title_switch">
          <xsl:apply-templates select="." mode="name" />
        </h4>
        <div style="display: block;" class="block_content" id="title_content">
          <table class="metaData">
            <tbody>
              <tr>
                <td class="metaname" valign="top">
                  <xsl:value-of select="i18n:translate('component.user2.admin.userAccount')" />
                </td>
                <td class="metavalue">
                  <xsl:apply-templates select="." mode="name" />
                </td>
              </tr>
              <tr>
                <td class="metaname" valign="top">
                  <xsl:value-of select="i18n:translate('component.user2.admin.passwordHint')" />
                </td>
                <td class="metavalue">
                  <xsl:value-of select="password/@hint" />
                </td>
              </tr>
              <tr>
                <td class="metaname" valign="top">
                  <xsl:value-of select="i18n:translate('component.user2.admin.user.lastLogin')" />
                </td>
                <td class="metavalue">
                  <xsl:call-template name="formatISODate">
                    <xsl:with-param name="date" select="lastLogin" />
                    <xsl:with-param name="format" select="i18n:translate('metaData.dateTime')" />
                  </xsl:call-template>
                </td>
              </tr>
              <tr>
                <td class="metaname" valign="top">
                  <xsl:value-of select="i18n:translate('component.user2.admin.user.validUntil')" />
                </td>
                <td class="metavalue">
                  <xsl:call-template name="formatISODate">
                    <xsl:with-param name="date" select="validUntil" />
                    <xsl:with-param name="format" select="i18n:translate('metaData.dateTime')" />
                  </xsl:call-template>
                </td>
              </tr>
              <tr>
                <td class="metaname" valign="top">Name:</td>
                <td class="metavalue">
                  <xsl:value-of select="realName" />
                </td>
              </tr>
              <xsl:if test="eMail">
                <tr>
                  <td class="metaname" valign="top">E-Mail:</td>
                  <td class="metavalue">
                    <a href="mailto:{eMail}">
                      <xsl:value-of select="eMail" />
                    </a>
                  </td>
                </tr>
              </xsl:if>
              <tr>
                <td class="metaname" valign="top">
                  <xsl:value-of select="i18n:translate('component.user2.admin.user.locked')" />
                </td>
                <td class="metavalue">
                  <xsl:choose>
                    <xsl:when test="@locked='true'">
                      <xsl:value-of select="i18n:translate('component.user2.admin.user.locked.true')" />
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="i18n:translate('component.user2.admin.user.locked.false')" />
                    </xsl:otherwise>
                  </xsl:choose>
                </td>
              </tr>
              <xsl:if test="attributes">
                <tr>
                  <td class="metaname" valign="top">
                    <xsl:value-of select="i18n:translate('component.user2.admin.user.attributes')" />
                  </td>
                  <td class="metavalue">
                    <dl>
                      <xsl:for-each select="attributes/attribute">
                        <dt>
                          <xsl:value-of select="@name" />
                        </dt>
                        <dd>
                          <xsl:value-of select="@value" />
                        </dd>
                      </xsl:for-each>
                    </dl>
                  </td>
                </tr>
              </xsl:if>
              <tr>
                <td class="metaname" valign="top">
                  <xsl:value-of select="i18n:translate('component.user2.admin.owner')" />
                </td>
                <td class="metavalue">
                  <xsl:apply-templates select="owner" mode="link" />
                  <xsl:if test="count(owner)=0">
                    <xsl:value-of select="i18n:translate('component.user2.admin.userIndependent')" />
                  </xsl:if>
                </td>
              </tr>
              <tr>
                <td class="metaname" valign="top">
                  <xsl:value-of select="i18n:translate('component.user2.admin.roles')" />
                </td>
                <td class="metavalue">
                  <xsl:for-each select="roles/role">
                    <xsl:value-of select="@name" />
                    <xsl:variable name="lang">
                      <xsl:call-template name="selectPresentLang">
                        <xsl:with-param name="nodes" select="label" />
                      </xsl:call-template>
                    </xsl:variable>
                    <xsl:value-of select="concat(' [',label[lang($lang)]/@text,']')" />
                    <xsl:if test="position() != last()">
                      <br />
                    </xsl:if>
                  </xsl:for-each>
                </td>
              </tr>
              <tr>
                <td class="metaname" valign="top">
                  <xsl:value-of select="i18n:translate('component.user2.admin.userOwns')" />
                </td>
                <td class="metavalue">
                  <xsl:for-each select="$owns/user">
                    <xsl:apply-templates select="." mode="link" />
                    <xsl:if test="position() != last()">
                      <br />
                    </xsl:if>
                  </xsl:for-each>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </xsl:template>

  <xsl:template match="user|owner" mode="link">
    <xsl:variable name="uid">
      <xsl:value-of select="@name" />
      <xsl:if test="not ( @realm = 'local' )">
        <xsl:text>@</xsl:text>
        <xsl:value-of select="@realm" />
      </xsl:if>
    </xsl:variable>
    <a href="MCRUserServlet?action=show&amp;id={$uid}">
      <xsl:apply-templates select="." mode="name" />
    </a>
  </xsl:template>

  <xsl:template match="user|owner" mode="name">
    <xsl:value-of select="@name" />
    <xsl:text> [</xsl:text>
    <xsl:value-of select="@realm" />
    <xsl:text>]</xsl:text>
  </xsl:template>

</xsl:stylesheet>
