<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:dc="http://purl.org/dc/elements/1.1/"
		xmlns:dcterms="http://purl.org/dc/terms"
		xmlns:tei="http://www.tei-c.org/ns/1.0"
                version="1.0">
  <!-- This stylesheet creates Dublin core metadata for each poem when only the poem is presented, as in a search result. -->
  <xsl:output method="xml" omit-xml-declaration="yes"/>
  <xsl:variable name="baseurl">http://beck.library.emory.edu/</xsl:variable>
  <xsl:variable name="siteurl">BelfastGroup</xsl:variable>

  <xsl:template match="/">
    <dc>
      <xsl:apply-templates select="//tei:TEI"/> <!-- get everything below this -->
      <dc:type>Text</dc:type>
    <dc:format>text/xml</dc:format>
    </dc>
  </xsl:template>

  <xsl:template match="tei:titleStmt"/><!-- do nothing with this -->
  <xsl:template match="tei:extent"/>
  
  <xsl:template match="tei:fileDesc">
    <xsl:element name="dc:creator">
      <xsl:apply-templates select="tei:titleStmt/tei:author/tei:name/@reg"/>
    </xsl:element>
        <xsl:element name="dc:contributor">
      <xsl:text>Lewis H. Beck Center</xsl:text>
    </xsl:element>
    <xsl:element name="dc:publisher">
      <xsl:apply-templates select="tei:publicationStmt/tei:publisher"/>
    </xsl:element>
    <xsl:element name="dcterms:issued">
      <xsl:apply-templates select="tei:publicationStmt/tei:date"/>
    </xsl:element>
    <xsl:element name="dc:rights">
      <xsl:apply-templates select="tei:publicationStmt/tei:availability/tei:p"/>
    </xsl:element>
    
    <xsl:element name="dcterms:isPartOf">
      <xsl:apply-templates select="tei:seriesStmt/tei:title"/>
    </xsl:element>
    <xsl:element name="dcterms:isPartOf">
      <xsl:value-of select="$baseurl"/><xsl:value-of
        select="$siteurl"/>      
    </xsl:element>
    
    <xsl:element name="dc:source">
      <!-- only one element here. -->
      <xsl:apply-templates select="tei:sourceDesc/tei:bibl"/>
      <!-- in case source is in plain text, without tags -->
      <!--  <xsl:apply-templates select="text()"/> -->
    </xsl:element>
    
  </xsl:template>
  
  <xsl:template match="tei:docDate"> <!-- for a poem -->
    <!-- electronic publication date: Per advice of LA -->
    <xsl:element name="dcterms:created">
      <xsl:value-of select="."/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="tei:group">  <!-- for a poem -->
    <xsl:element name="dc:title">
      <xsl:apply-templates select="//tei:titlePart"/>
    </xsl:element>

    <xsl:element name="dc:identifier">
      <xsl:value-of select="$baseurl"/><xsl:value-of
      select="$siteurl"/>/browse.php?id=<xsl:value-of select="./@xml:id"/>      
    </xsl:element>


  </xsl:template>
  
<!-- normalize space in titles -->
  <xsl:template match="tei:head">
    <xsl:value-of select="normalize-space(.)"/>
  </xsl:template>

<!-- add a space after titles in the head -->
  <xsl:template match="tei:head/tei:title">
    <xsl:apply-templates/><xsl:text> </xsl:text>
  </xsl:template>

<!-- handle <lb/> in head -->
   <xsl:template match="tei:lb">
      <xsl:apply-templates/><xsl:text> </xsl:text>
   </xsl:template>


  <!-- ignore these: encoding specific information -->
  <xsl:template match="tei:encodingDesc/tei:projectDesc"/>
  <xsl:template match="tei:encodingDesc/tei:tagsDecl"/>
  <xsl:template match="tei:encodingDesc/tei:refsDecl"/>
  <xsl:template match="tei:encodingDesc/tei:editorialDecl"/>
  <xsl:template match="tei:revisionDesc"/>

  <!-- normalize space for all text nodes -->
  <xsl:template match="text()">
    <xsl:value-of select="normalize-space(.)"/>
  </xsl:template>

</xsl:stylesheet>
