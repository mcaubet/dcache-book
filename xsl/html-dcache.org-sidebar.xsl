<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version="1.0">
  
  <xsl:import href="http://docbook.sourceforge.net/release/xsl/current/html/chunk.xsl"/>
  
  <!--
       With 'import' we make shure that 'chunk-element-content'
       gets overwritten again below.

       This way, changes to "dcb-dcache.org-customizations.xsl"
       outside of 'chunk-element-content' will go in here, as well.
  -->
  <xsl:import href="dcb-dcache.org-customizations.xsl"/>


  <xsl:include href="dcb-docbook-parameters.xsl"/>
  
  <xsl:include href="dcb-docbook-html-chunk-customizations.xsl"/>
  
  <xsl:include href="dcb-extensions.xsl"/>
  
  <!--
       The following included xsl file is generated by the command

       xsltproc -nonet -output dcb-dcache.org-sidebar-title.xsl \
         http://docbook.sourceforge.net/release/xsl/current/template/titlepage.xsl \
         dcb-dcache.org-sidebar-title-tpl.xml

       This is the proper customization method for the titlepage
       in docbook-xsl. Since we only want the TOC of the book,
       only the '<t:titlepage t:element="book">' is used.

       For convenience a version of the following template is
       checked into CVS.
  -->

  <xsl:include href="dcb-dcache.org-sidebar-title.xsl"/>
  
  
  <xsl:template name="chunk-element-content">
    <xsl:param name="prev"/>
    <xsl:param name="next"/>
    <xsl:param name="nav.context"/>
    <xsl:param name="content">
      <xsl:apply-imports/>
    </xsl:param>
    
    <!-- <xsl:call-template name="user.preroot"/> -->
    
    <!-- 
    <html>
      <xsl:call-template name="html.head">
        <xsl:with-param name="prev" select="$prev"/>
        <xsl:with-param name="next" select="$next"/>
      </xsl:call-template>
      
      <body> 
        <xsl:call-template name="body.attributes"/>
        <xsl:call-template name="user.header.navigation"/>
        
        <xsl:call-template name="header.navigation">
          <xsl:with-param name="prev" select="$prev"/>
          <xsl:with-param name="next" select="$next"/>
          <xsl:with-param name="nav.context" select="$nav.context"/>
        </xsl:call-template>
        
        <xsl:call-template name="user.header.content"/>
        -->
       
        <xsl:copy-of select="$content"/>
        
        <!--
        <xsl:call-template name="user.footer.content"/>
        
        <xsl:call-template name="footer.navigation">
          <xsl:with-param name="prev" select="$prev"/>
          <xsl:with-param name="next" select="$next"/>
          <xsl:with-param name="nav.context" select="$nav.context"/>
        </xsl:call-template>
        
        <xsl:call-template name="user.footer.navigation"/>
        
      </body>
    </html>
    -->
    
  </xsl:template>
  
  
  
  <xsl:template name="subtoc">
    <xsl:param name="toc-context" select="."/>
    <xsl:param name="nodes" select="NOT-AN-ELEMENT"/>
    
    <xsl:variable name="subtoc">
      <xsl:element name="{$toc.list.type}">
        <xsl:apply-templates mode="toc" select="$nodes">
          <xsl:with-param name="toc-context" select="$toc-context"/>
        </xsl:apply-templates>
      </xsl:element>
    </xsl:variable>
    
    <xsl:variable name="depth">
      <xsl:choose>
        <xsl:when test="local-name(.) = 'section'">
          <xsl:value-of select="count(ancestor::section) + 1"/>
        </xsl:when>
        <xsl:when test="local-name(.) = 'sect1'">1</xsl:when>
        <xsl:when test="local-name(.) = 'sect2'">2</xsl:when>
        <xsl:when test="local-name(.) = 'sect3'">3</xsl:when>
        <xsl:when test="local-name(.) = 'sect4'">4</xsl:when>
        <xsl:when test="local-name(.) = 'sect5'">5</xsl:when>
        <xsl:when test="local-name(.) = 'refsect1'">1</xsl:when>
        <xsl:when test="local-name(.) = 'refsect2'">2</xsl:when>
        <xsl:when test="local-name(.) = 'refsect3'">3</xsl:when>
        <xsl:when test="local-name(.) = 'simplesect'">
          <!-- sigh... -->
          <xsl:choose>
            <xsl:when test="local-name(..) = 'section'">
              <xsl:value-of select="count(ancestor::section)"/>
            </xsl:when>
            <xsl:when test="local-name(..) = 'sect1'">2</xsl:when>
            <xsl:when test="local-name(..) = 'sect2'">3</xsl:when>
            <xsl:when test="local-name(..) = 'sect3'">4</xsl:when>
            <xsl:when test="local-name(..) = 'sect4'">5</xsl:when>
            <xsl:when test="local-name(..) = 'sect5'">6</xsl:when>
            <xsl:when test="local-name(..) = 'refsect1'">2</xsl:when>
            <xsl:when test="local-name(..) = 'refsect2'">3</xsl:when>
            <xsl:when test="local-name(..) = 'refsect3'">4</xsl:when>
            <xsl:otherwise>1</xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>0</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <xsl:variable name="subtoc.list">
      <xsl:choose>
        <xsl:when test="$toc.dd.type = ''">
          <xsl:copy-of select="$subtoc"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:element name="{$toc.dd.type}">
            <xsl:attribute name="style"> margin-left: 14px; font-size: 9pt; padding 4px;</xsl:attribute>
            <xsl:copy-of select="$subtoc"/>
          </xsl:element>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <xsl:element name="{$toc.listitem.type}">
      <xsl:variable name="label">
        <xsl:apply-templates select="." mode="label.markup"/>
      </xsl:variable>
      <xsl:copy-of select="$label"/>
      <xsl:if test="$label != ''">
        <xsl:value-of select="$autotoc.label.separator"/>
      </xsl:if>
      
      <a>
        <xsl:attribute name="href">
          <xsl:call-template name="href.target">
            <xsl:with-param name="context" select="$toc-context"/>
          </xsl:call-template>
        </xsl:attribute>
        <xsl:apply-templates select="." mode="title.markup"/>
      </a>
      <xsl:if test="$toc.listitem.type = 'li'
                    and $toc.section.depth > $depth and count($nodes)&gt;0">
        <xsl:copy-of select="$subtoc.list"/>
      </xsl:if>
    </xsl:element>
    <xsl:if test="$toc.listitem.type != 'li'
                  and $toc.section.depth > $depth and count($nodes)&gt;0">
      <xsl:copy-of select="$subtoc.list"/>
    </xsl:if>
  </xsl:template>
  
  
  
</xsl:stylesheet>
 
