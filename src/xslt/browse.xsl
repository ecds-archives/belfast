<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:exist="http://exist.sourceforge.net/NS/exist"
    exclude-result-prefixes="exist">
    
    <xsl:output method="xml" omit-xml-declaration="yes"/>

    <xsl:param name="defaultindent">5</xsl:param>	  
    
    <xsl:template match="/"> 
        <xsl:apply-templates/> 
    </xsl:template>
    
    <xsl:template match="TEI/teiHeader"/> <!-- do nothing the header -->

    
    <xsl:template match="group/group">
        <xsl:element name="h2">
            <xsl:value-of select="head" />
        </xsl:element>
        
        <xsl:element name="p"> 
            <xsl:element name="b">
                Workshop Date: </xsl:element>
            <xsl:value-of select="docDate" />
            <xsl:element name="br"/>
            <xsl:element name="b">Poet: </xsl:element>
            <xsl:value-of select="docAuthor"/>
        </xsl:element>
        
        <xsl:apply-templates select="argument"/>
        
        <xsl:apply-templates select="text"/>
        
    </xsl:template>
    
    <xsl:template match="list">
        <xsl:element name="ul">
            <xsl:apply-templates select="item" />
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="list/item">
        <xsl:element name="li">
            <xsl:element name="a">
                <xsl:attribute name="href">#<xsl:call-template name="get-id">
                    <xsl:with-param name="title" select="normalize-space(.)"/> 
                </xsl:call-template>
                </xsl:attribute> 
                <xsl:value-of select="."/>
            </xsl:element> <!-- a -->
        </xsl:element>  <!-- li -->
    </xsl:template>
    
    <xsl:template match="hi">
        <xsl:choose>
            <xsl:when test="@rend = 'bold'">
                <xsl:element name="b">
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="@rend='center'">
                <xsl:element name="center">
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    
    <!-- text = poem -->
    <xsl:template match="text">
        
        <xsl:element name="hr">
            <xsl:attribute name="width">50%</xsl:attribute>
            <xsl:attribute name="align">left</xsl:attribute>
        </xsl:element>
        <xsl:element name="h3">
            <xsl:element name="a">
                <xsl:attribute name="name"><xsl:value-of select="@id"/></xsl:attribute>
                <xsl:value-of select=".//titlePart"/>
            </xsl:element> <!-- a -->
        </xsl:element> <!-- h3 -->
        <xsl:apply-templates select="body"/>
        <xsl:apply-templates select="back"/>
    </xsl:template>
    
    <xsl:template match="epigraph">
        <xsl:element name="p">
            <xsl:element name="i">
                <xsl:apply-templates/>
            </xsl:element> <!-- i -->
        </xsl:element>  <!-- p -->
    </xsl:template>
    
    
    <xsl:template match="head">
        <xsl:choose>
            <xsl:when test="@rend = 'center'">
                <xsl:element name="center">
                    <xsl:element name="b">
                        <xsl:apply-templates/>
                    </xsl:element>  <!-- b -->
                </xsl:element>  <!-- center -->
            </xsl:when>
            <xsl:otherwise>
                <xsl:element name="b">
                    <xsl:apply-templates/>
                </xsl:element>
                <xsl:element name="br"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="lg">
        <xsl:element name="p">
            <xsl:apply-templates />
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="hi">
        <xsl:choose>
            <xsl:when test="@rend = 'bold'">
                <xsl:element name="b">
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="@rend='center'">
                <xsl:element name="center">
                    <xsl:apply-templates/>
                </xsl:element>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <!-- line  -->
    <!--   Indentation should be specified in format rend="indent#", where # is
        number of spaces to indent.  --> 
    <xsl:template match="l">
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
    
    <xsl:template match="add">
        <xsl:element name="span">
            <xsl:attribute name="class">add</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="gap">
        <xsl:element name="span"><xsl:attribute name="class">gap</xsl:attribute>
        <xsl:text>[</xsl:text><xsl:value-of select="@reason"/><xsl:text>]</xsl:text>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="del">
        <xsl:element name="span">
            <xsl:attribute name="class">del</xsl:attribute>
            <xsl:apply-templates/>
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
    
    
    <!-- given a poem's title, return the poem's id -->
    <xsl:template name="get-id">
        <xsl:param name="title"/>
        
        <xsl:variable name="lowercase">abcdefghijklmnopqrstuvwxyz</xsl:variable>
        <xsl:variable name="uppercase">ABCDEFGHIJKLMNOPQRSTUVWXYZ</xsl:variable>
        
        <xsl:variable name="uc_title"><xsl:value-of select="translate($title,
            $lowercase, $uppercase)"/></xsl:variable>
        
        <xsl:for-each select="//text">
            <xsl:if test="normalize-space(front/titlePage/docTitle/titlePart) = $uc_title">
                <xsl:value-of select="@id"/>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>
