<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:exist="http://exist.sourceforge.net/NS/exist"
        version="1.0" exclude-result-prefixes="exist">
        
        <xsl:output method="xml" omit-xml-declaration="yes"/>
        
        <xsl:param name="mode"/>	 <!-- search or search-illus -->
        
        <!-- search terms -->
        <xsl:param name="doctitle"/>
        <xsl:param name="auth"/>
        <xsl:param name="keyword"/>
        
        
        <xsl:variable name="url_suffix"><xsl:if test="$keyword">keyword=<xsl:value-of select="$keyword"/></xsl:if><xsl:if test="$doctitle">&amp;doctitle=<xsl:value-of select="$doctitle"/></xsl:if></xsl:variable>
        
        <!-- information about current set of results  -->
        <xsl:variable name="position"><xsl:value-of select="//@exist:start"/></xsl:variable>
        <xsl:param name="max"/>
        <xsl:variable name="total"><xsl:value-of select="//@exist:hits"/></xsl:variable>
    
    
    <xsl:variable name="nl"><xsl:text> 
    </xsl:text></xsl:variable>
    
    
    <xsl:template match="/">
        <xsl:apply-templates/> <!-- get everything -->
    </xsl:template>
    
    <xsl:template match="group">
        <xsl:variable name="grpid"><xsl:value-of select="./@id"></xsl:value-of></xsl:variable>
        <xsl:element name="ul">
           <xsl:for-each select=".">
                <xsl:element name="li"><xsl:text>Workshop: </xsl:text>
                <xsl:element name="a">
                    <xsl:attribute name="href">browse.php?id=<xsl:value-of select="$grpid"/></xsl:attribute>
                    <xsl:apply-templates select="head"/></xsl:element><!-- end a -->
            <xsl:element name="ul">
                <xsl:for-each select="./text">
                    <xsl:element name="li">
                    <xsl:element name="a">
                        <xsl:attribute name="href">browse.php?id=<xsl:value-of select="$grpid"/>&amp;doctitle=<xsl:value-of select="./@id"/></xsl:attribute>
                     <xsl:apply-templates select="front//titlePart"/></xsl:element><!-- end a -->
                    </xsl:element> <!-- end item -->
                    </xsl:for-each>
            </xsl:element> <!-- end poem list -->
            </xsl:element><!-- end workshop list -->
            </xsl:for-each>
        </xsl:element>
    </xsl:template>
        
</xsl:stylesheet>
