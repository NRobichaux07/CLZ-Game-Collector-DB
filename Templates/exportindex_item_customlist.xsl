<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet [<!ENTITY nbsp "&#160;">]>

<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="html"/>

<xsl:param name="details">false</xsl:param>
<xsl:param name="absolutelinks">false</xsl:param>
<xsl:param name="thumbnails">false</xsl:param>
<xsl:param name="indextablecols">5</xsl:param>
<xsl:param name="thumbshowcaption">true</xsl:param>

<!-- process a lookup item -->
<xsl:template match="node()[displayname!='']">
  <xsl:choose>
    <xsl:when test="url!=''">
      <a href="{url}"><xsl:value-of select="displayname"/></a>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="displayname"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- the main template -->
<xsl:template match="/">
  <HEAD>
    <LINK REL="StyleSheet" TYPE="text/css" HREF="exportindex_item_customlist.css"></LINK>
    <META http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
    <TITLE>Game List</TITLE>
  </HEAD>
  <BODY>
    <div align="center">
    <span class="title">Game List</span>
    <xsl:apply-templates select="gameinfo/navigation"/>    
    <br/>
    <table>    
    <xsl:apply-templates select="gameinfo/gamelist"/>
    </table>
    <xsl:if test="'Yes'='Yes'">
      <br/>
      <div class="value"><xsl:value-of select="//@creationdate"/></div>
    </xsl:if>
    </div>
  </BODY>
</xsl:template>

<xsl:template match="gamelist">
  <xsl:choose>
    <xsl:when test="$indextablecols = 1">
      <xsl:for-each select="game">
        <tr>
          <xsl:apply-templates select=". | following-sibling::game[position() &lt; $indextablecols]"/>
        </tr>
      </xsl:for-each>
    </xsl:when>
    <xsl:otherwise>
      <xsl:for-each select="game[position() mod $indextablecols = 1]">
        <tr>
          <xsl:apply-templates select=". | following-sibling::game[position() &lt; $indextablecols]"/>
        </tr>
      </xsl:for-each>
    </xsl:otherwise>            
  </xsl:choose>
</xsl:template>

<xsl:template match="game">
  <xsl:choose>
    <xsl:when test="$details = 'true'">
      <xsl:variable name="the_href">details/<xsl:value-of select="id"/>.html</xsl:variable>
    </xsl:when>
    <xsl:otherwise>
      <xsl:choose>
        <xsl:when test="$absolutelinks = 'true'">
          <xsl:if test="coverfront!=''">
            <xsl:variable name="the_href">file:///<xsl:value-of select="coverfront"/></xsl:variable>
          </xsl:if>
        </xsl:when>
        <xsl:otherwise>
          <xsl:if test="coverfront!=''">
            <xsl:variable name="the_href">images/<xsl:value-of select="id"/>f.jpg</xsl:variable>
          </xsl:if>
        </xsl:otherwise>            
      </xsl:choose>
    </xsl:otherwise>            
  </xsl:choose>
  <xsl:choose>
    <xsl:when test="thumbfilepath!=''">
      <xsl:variable name="the_img_src">images/<xsl:value-of select="id"/>t.jpg</xsl:variable>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="the_img_src">images/mainitem.jpg</xsl:variable>
    </xsl:otherwise>            
  </xsl:choose>
  <xsl:variable name="the_caption"><xsl:value-of select="title"/></xsl:variable>
  
  <td valign="top">
  <a href="{$the_href}" title="{$the_caption}" id="thumbimage"><img src="{$the_img_src}"/></a>
  <xsl:if test="$thumbshowcaption = 'true'">
  <br/><a href="{$the_href}" title="{$the_caption}"><xsl:value-of select="$the_caption"/></a>
  </xsl:if>
  </td>

   <xsl:if test="(last() &gt; $indextablecols) and (last()=position()) and (position() mod $indextablecols &gt; 0)">
      <xsl:variable name="filledCells" select="position() mod $indextablecols"/>
      <td colspan="{$indextablecols - $filledCells}">&#160;</td>
   </xsl:if>   
</xsl:template>

<xsl:template match="navigation">
  <div class="navigation" align="center">
    <xsl:if test="count(pagelink) > 1">
      <div class="navigationline">
        <xsl:for-each select="pagelink">
          <xsl:choose>
            <xsl:when test="@url!=''">      
              <div class="navlink"><a href="{@url}"><xsl:value-of select="@pagenum"/></a></div>
            </xsl:when>
            <xsl:otherwise>
              <div class="navlink" id="current"><xsl:value-of select="@pagenum"/></div>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:if test="position()!=last()"></xsl:if>
        </xsl:for-each>  
        </div>
        <div class="navigationline">
        <xsl:choose>
          <xsl:when test="firstlink/@url!=''">
            <div class="navlink"><a href="{firstlink/@url}"><xsl:value-of select="/gameinfo/localizedtemplatetexts/field[@id='ttFirst']/@label"/></a></div>
          </xsl:when>
          <xsl:otherwise>
            <div class="navlink"><xsl:value-of select="/gameinfo/localizedtemplatetexts/field[@id='ttFirst']/@label"/></div>
          </xsl:otherwise>
        </xsl:choose>   
        <xsl:choose>
          <xsl:when test="prevlink/@url!=''">
            <div class="navlink"><a href="{prevlink/@url}"><xsl:value-of select="/gameinfo/localizedtemplatetexts/field[@id='ttPrev']/@label"/></a></div>
          </xsl:when>
          <xsl:otherwise>
            <div class="navlink"><xsl:value-of select="/gameinfo/localizedtemplatetexts/field[@id='ttPrev']/@label"/></div>
          </xsl:otherwise>
        </xsl:choose>   
        <xsl:choose>
          <xsl:when test="nextlink/@url!=''">
            <div class="navlink"><a href="{nextlink/@url}"><xsl:value-of select="/gameinfo/localizedtemplatetexts/field[@id='ttNext']/@label"/></a></div>
          </xsl:when>
          <xsl:otherwise>
            <div class="navlink"><xsl:value-of select="/gameinfo/localizedtemplatetexts/field[@id='ttNext']/@label"/></div>
          </xsl:otherwise>
        </xsl:choose>   
        <xsl:choose>
          <xsl:when test="lastlink/@url!=''">
            <div class="navlink"><a href="{lastlink/@url}"><xsl:value-of select="/gameinfo/localizedtemplatetexts/field[@id='ttLast']/@label"/></a></div>
          </xsl:when>
          <xsl:otherwise>
            <div class="navlink"><xsl:value-of select="/gameinfo/localizedtemplatetexts/field[@id='ttLast']/@label"/></div>
          </xsl:otherwise>
        </xsl:choose> 
      </div>
    </xsl:if>
  </div>
</xsl:template>

</xsl:stylesheet>

