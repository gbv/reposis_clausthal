<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [
  <!ENTITY html-output SYSTEM "xsl/xsl-output-html.fragment">
]>

<!-- ============================================== -->
<!-- $Revision: 1.4 $ $Date: 2009/03/20 10:42:33 $ -->
<!-- ============================================== -->

<!-- +
| This stylesheet controls the Web-Layout of the Login Servlet. The Login Servlet
| gathers information about the session, user ID, password and calling URL and
| then tries to login the user by delegating the login request to the user manager.
| Depending on whether the login was successful or not, the Login Servlet generates
| the following XML output stream:
|
| <mcr_user unknown_user="true|false"
|           user_disabled="true|false"
|           invalid_password="true|false">
|   <guest_id>...</guest_id>
|   <guest_pwd>...</guest_pwd>
|   <backto_url>...<backto_url>
| </mcr_user>
|
| The XML stream is sent to the Layout Servlet and finally handled by this stylesheet.
|
| Authors: Detlev Degenhardt, Thomas Scheffler, Kathleen Neumann
| Last changes: 2012-03-16
+ -->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:i18n="xalan://org.mycore.services.i18n.MCRTranslation" xmlns:encoder="xalan://java.net.URLEncoder" exclude-result-prefixes="xlink encoder i18n">
  &html-output;
  <xsl:include href="MyCoReLayout.xsl" />
  <xsl:param name="MCR.Users.Guestuser.UserName" />
  <xsl:param name="FormTarget" select="concat($ServletsBaseURL,'MCRLoginServlet')" />
  <xsl:param name="Realm" select="'local'" />
  <xsl:variable name="loginToRealm" select="document(concat('realm:',$Realm))" />

  <xsl:variable name="PageTitle" select="i18n:translate('component.user2.login.form.title')" />

  <xsl:template match="/login">
    <div id="userlogin" class="user-login">
        <!-- At first we display the current user in a head line. -->
      <p class="header">
        <xsl:variable name="currentAccount">
          <xsl:value-of select="'&lt;strong&gt;'" />
          <xsl:choose>
            <xsl:when test="@guest='true'">
              <xsl:value-of select="i18n:translate('component.user2.login.guest')" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="concat(@user,' [',@realm,']')" />
            </xsl:otherwise>
          </xsl:choose>
          <xsl:value-of select="'&lt;/strong&gt;'" />
        </xsl:variable>
        <xsl:value-of select="i18n:translate('component.user2.login.currentAccount', $currentAccount)" disable-output-escaping="yes" />
      </p>

      <h2><xsl:value-of select="$loginToRealm//login/label[@xml:lang='de']" /></h2>

        <!-- +
        | There are three possible error-conditions: wrong password, unknown user and disabled
        | user. If one of these conditions occured, the corresponding information will be
        | presented at the top of the page.
        + -->
      <xsl:apply-templates select="." mode="userStatus" />
      <xsl:apply-templates select="." mode="userAction" />
    </div>
  </xsl:template>

  <xsl:template match="login" mode="userAction">
    <form id="login_form" action="{$FormTarget}{$HttpSession}" method="post" role="form" class="yform">
      <xsl:apply-templates select="$loginToRealm" mode="form" />
      <input type="hidden" name="action" value="login" />
      <input type="hidden" name="url" value="{returnURL}" />
      <fieldset>
        <!-- Here come the input fields... -->
        <xsl:choose>
          <xsl:when test="$direction = 'rtl' ">
            <div class="type-text">
              <input type="text" name="uid" id="user" size="20"/>
              <label for="user"><xsl:value-of select="concat(i18n:translate('component.user2.login.form.userName'),' ')" /></label>
            </div>
            <div class="type-text">
              <input type="password" name="pwd" id="password" size="20"/>
              <label for="password"><xsl:value-of select="concat(i18n:translate('component.user2.login.form.password'),' ')" /></label>
            </div>
          </xsl:when>
          <xsl:otherwise>
            <div class="type-text">
              <label for="user"><xsl:value-of select="concat(i18n:translate('component.user2.login.form.userName'),':')" /></label>
              <input type="text" name="uid" id="user" size="20"/>
            </div>
            <div class="type-text">
              <label for="password"><xsl:value-of select="concat(i18n:translate('component.user2.login.form.password'),':')" /></label>
              <input type="password" name="pwd" id="password" size="20"/>
            </div>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:choose>
          <xsl:when test="$direction = 'rtl' ">
            <div class="type-button">
              <input id="cancel" onClick="self.location.href='{$ServletsBaseURL}MCRLoginServlet{$HttpSession}?action=cancel'" type="button"
                tabindex="999" value="{i18n:translate('component.user2.button.cancel')}" />
              <xsl:value-of select="' '" />
              <input id="submit" type="submit" value="{i18n:translate('component.user2.button.login')}" name="LoginSubmit" />
            </div>
          </xsl:when>
          <xsl:otherwise>
            <div class="type-button">
              <input id="submit" type="submit" value="{i18n:translate('component.user2.button.login')}" name="LoginSubmit" />
              <xsl:value-of select="' '" />
              <input id="cancel" onClick="self.location.href='{returnURL}'" type="button"
                tabindex="999" value="{i18n:translate('component.user2.button.cancel')}" />
            </div>
          </xsl:otherwise>
        </xsl:choose>
      </fieldset>
    </form>
  </xsl:template>

  <xsl:template match="login" mode="userStatus">
    <xsl:if test="@loginFailed='true'">
      <p class="status">
        <strong>
          <xsl:value-of select="i18n:translate('component.user2.login.failed')" />
        </strong>
        <xsl:value-of select="concat(' ',i18n:translate('component.user2.login.invalidUserPwd'))" />
      </p>
    </xsl:if>
  </xsl:template>
  <xsl:template match="login" mode="controlGroupClass">
    <xsl:attribute name="class">
      <xsl:value-of select="'form-group'" />
      <xsl:if test="@loginFailed='true'">
        <xsl:value-of select="' has-error'" />
      </xsl:if>
    </xsl:attribute>
  </xsl:template>

  <xsl:template match="realm" mode="form">
    <xsl:if test="login/@realmParameter">
      <input type="hidden" name="{login/@realmParameter}" value="{@id}" />
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
