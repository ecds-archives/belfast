<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:exist="http://exist.sourceforge.net/NS/exist"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="exist">
    
    <xsl:output method="xml" omit-xml-declaration="yes"/>

    <xsl:param name="defaultindent">5</xsl:param>
    <xsl:param name="doctitle"/> <!-- set for poem, not for group -->
    <!-- use key to match id for bookmark -->
    <xsl:key name="pid" match="tei:idno" use="@n"/>
    
    <xsl:template match="/"> 
        <xsl:apply-templates/> 
	<xsl:if test="$doctitle=''">
	<xsl:call-template name="bookmark"/>
	</xsl:if>
    </xsl:template>
    
    <xsl:template match="tei:TEI/tei:teiHeader"/> <!-- do nothing the header -->

    
    <xsl:template match="tei:group/tei:group">
         <xsl:element name="h2">
            <xsl:value-of select="tei:head" />
        </xsl:element>
        
        <xsl:element name="p"> 
            <xsl:element name="b">
                Workshop Date: </xsl:element>
            <xsl:value-of select="tei:docDate" />
            <xsl:element name="br"/>
            <xsl:element name="b">Poet: </xsl:element>
            <xsl:value-of select="tei:docAuthor"/>
        </xsl:element>
        
        <xsl:apply-templates select="tei:argument"/>
        
        <xsl:apply-templates select="tei:text"/>
    </xsl:template>
    
    <xsl:template match="tei:list">
        <xsl:element name="ul">
            <xsl:apply-templates select="tei:item" />
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="tei:list/tei:item">
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
    
    <xsl:template match="tei:hi">
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
    <xsl:template match="tei:text">
        
        <xsl:element name="hr">
            <xsl:attribute name="width">50%</xsl:attribute>
            <xsl:attribute name="align">left</xsl:attribute>
        </xsl:element>
        <xsl:element name="h3">
            <xsl:element name="a">
                <xsl:attribute name="name"><xsl:value-of select="@xml:id"/></xsl:attribute>
                <xsl:value-of select=".//tei:titlePart"/>
            </xsl:element> <!-- a -->
        </xsl:element> <!-- h3 -->
        <xsl:apply-templates select="tei:body"/>
        <xsl:apply-templates select="tei:back"/>
    </xsl:template>
    
    <xsl:template match="tei:epigraph">
        <xsl:element name="p">
            <xsl:element name="i">
                <xsl:apply-templates/>
            </xsl:element> <!-- i -->
        </xsl:element>  <!-- p -->
    </xsl:template>
    
    
    <xsl:template match="tei:head">
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
    
    <xsl:template match="tei:lg">
        <xsl:element name="p">
            <xsl:apply-templates />
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="tei:hi">
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
    <xsl:template match="tei:l">
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
    
    
    <xsl:template match="tei:back">
        <xsl:element name="span">
            <xsl:attribute name="class">byline</xsl:attribute>
            <xsl:value-of select="tei:byline"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="tei:add">
        <xsl:element name="span">
            <xsl:attribute name="class">add</xsl:attribute>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="tei:gap">
        <xsl:element name="span"><xsl:attribute name="class">gap</xsl:attribute>
        <xsl:text>[</xsl:text><xsl:value-of select="@reason"/><xsl:text>]</xsl:text>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="tei:del">
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
            $lowercase, $uppercase)"  disable-output-escaping="yes"/></xsl:variable>
        
        <xsl:for-each select="//tei:text">
            <xsl:if test="normalize-space(tei:front/tei:titlePage/tei:docTitle/tei:titlePart) = $uc_title">
                <xsl:value-of select="@xml:id"/>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

    
    <xsl:template name="bookmark">
      <xsl:variable name="id"><xsl:value-of select="//tei:group/tei:group/@xml:id"/></xsl:variable><xsl:element name="hr"/>
      <xsl:element name="div"><xsl:attribute name="class">bookmark</xsl:attribute>
    <xsl:text>Permanent URL for this workshop: </xsl:text><xsl:element name="a"><xsl:attribute name="rel">bookmark</xsl:attribute><xsl:attribute name="href"><xsl:value-of select="key('pid', $id)"/></xsl:attribute><xsl:value-of select="key('pid', $id)"/></xsl:element>
      </xsl:element> 
    </xsl:template> 
</xsl:stylesheet>
