<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:exist="http://exist.sourceforge.net/NS/exist"
    exclude-result-prefixes="exist">
    
    <xsl:output method="xml" omit-xml-declaration="yes"/>
    <xsl:param name="id"/>
    <xsl:param name="defaultindent">5</xsl:param>	  
    
    <xsl:variable name="url_suffix"><xsl:if test="$id">&amp;doctitle=<xsl:value-of select="$id"/></xsl:if></xsl:variable>
    
    <xsl:template match="/">
        <xsl:apply-templates/> <!-- get everything -->
    </xsl:template>
    
    <xsl:template match="group/group">
        <xsl:element name="h3">
        <xsl:value-of select="head"/><xsl:text>, Date: </xsl:text><xsl:value-of select="docDate"/>
        </xsl:element>
        <!-- <xsl:call-template name="toc"/> -->
        <xsl:apply-templates select="text"/>
    </xsl:template>
  <!--  
    <xsl:template name="toc" mode="toc">
        <xsl:for-each select="list">
            <xsl:element name="a"><xsl:attribute name="href"><xsl:value-of select="../text/@id"/></xsl:attribute>
            <xsl:value-of select="item"/>
            </xsl:element>
            
        </xsl:for-each>
        
        </xsl:template> -->
    
    <xsl:template match="argument"/> <!-- do nothing with argument -->
    
    <xsl:template match="text">
        <xsl:element name="h4"><xsl:value-of select="front//titlePart"/></xsl:element>
    </xsl:template>
   
    <xsl:template match="//body">Debug: Body matched.
        <xsl:element name="p">
        <xsl:apply-templates select="lg"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="epigraph">
        <xsl:element name="p">
            <xsl:attribute name="class">epigraph</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>  <!-- p -->
    </xsl:template>
 
    
    <!-- line  -->
    <!--   Indentation should be specified in format rend="indent#", where # is
        number of spaces to indent.  --> 
    <xsl:template match="l">Debug: in line template
        <!-- retrieve any specified indentation -->
        <xsl:if test="@rend">
            <xsl:variable name="rend">
                <xsl:value-of select="./@rend"/>
            </xsl:variable>
            <xsl:variable name="indent">
                <xsl:choose>
                    <xsl:when test="$rend='indent'">		
                        <!-- if no number is specified, use a default setting -->
                        <xsl:value-of select="$defaultindent"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="substring-after($rend, 'indent')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:call-template name="indent">
                <xsl:with-param name="num" select="$indent"/>
            </xsl:call-template>
        </xsl:if>
        
        <xsl:apply-templates/>
        <xsl:element name="br"/>
    </xsl:template>
    
    <xsl:template match="back">
        <xsl:element name="span">
            <xsl:attribute name="class">byline</xsl:attribute>
            <xsl:value-of select="byline"/>
        </xsl:element>
    </xsl:template>

    <!-- recursive template to indent by inserting non-breaking spaces -->
    <xsl:template name="indent">
        <xsl:param name="num">0</xsl:param>
        <xsl:variable name="space">&#160;</xsl:variable>
        
        <xsl:value-of select="$space"/>
        
        <xsl:if test="$num > 1">
            <xsl:call-template name="indent">
                <xsl:with-param name="num" select="$num - 1"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    
</xsl:stylesheet>
