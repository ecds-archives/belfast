<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:dc="http://purl.org/dc/elements/1.1/"
		xmlns:dcterms="http://purl.org/dc/terms"
                version="1.0">
  <!-- This stylesheet creates Dublin core metadata for each workshop page -->
  <xsl:output method="xml" omit-xml-declaration="yes"/>
  <xsl:variable name="baseurl">http://beck.library.emory.edu/</xsl:variable>
  <xsl:variable name="siteurl">belfast</xsl:variable>

  <xsl:template match="/">
    <dc>
      <xsl:apply-templates select="//TEI"/> <!-- get everything below this -->
      <dc:type>Text</dc:type>
    <dc:format>text/xml</dc:format>
    </dc>
  </xsl:template>
<!-- don't need
  <xsl:variable name="issue-id">
    <xsl:apply-templates select="//issue-id/@id"/>
  </xsl:variable>
-->
  <xsl:template match="titleStmt"/><!-- do nothing with this -->
  <xsl:template match="extent"/>
  
  <xsl:template match="fileDesc">
    <xsl:element name="dc:contributor">
      <xsl:text>Lewis H. Beck Center</xsl:text>
    </xsl:element>
    <xsl:element name="dc:publisher">
      <xsl:apply-templates select="publicationStmt/publisher"/>
    </xsl:element>
    <xsl:element name="dcterms:issued">
      <xsl:apply-templates select="publicationStmt/date"/>
    </xsl:element>
    <xsl:element name="dc:rights">
      <xsl:apply-templates select="publicationStmt/availability/p"/>
    </xsl:element>
    
    <xsl:element name="dcterms:isPartOf">
      <xsl:apply-templates select="seriesStmt/title"/>
    </xsl:element>
    <xsl:element name="dcterms:isPartOf">
      <xsl:value-of select="$baseurl"/><xsl:value-of
        select="$siteurl"/>      
    </xsl:element>
    
    <xsl:element name="dc:source">
      <!-- only one element here. -->
      <xsl:apply-templates select="sourceDesc/bibl"/>
      <!-- in case source is in plain text, without tags -->
      <!--  <xsl:apply-templates select="text()"/> -->
    </xsl:element>
    
  </xsl:template>
  
  <xsl:template match="//group/group"> <!-- for a workshop -->
    <!-- electronic publication date: Per advice of LA -->
    <xsl:element name="dcterms:created">
      <xsl:value-of select="docDate"/>
    </xsl:element>

    <xsl:element name="dcterms:description.tableOfContents">
     <xsl:for-each select="text">
      <xsl:apply-templates select="front//titlePart"/><xsl:text> -- </xsl:text>
     </xsl:for-each>
    </xsl:element>

    <xsl:element name="dc:title">
      <xsl:apply-templates select="head"/>, <xsl:value-of select="docDate"/>
    </xsl:element>

    <xsl:element name="dc:identifier">
      <xsl:value-of select="$baseurl"/><xsl:value-of
      select="$siteurl"/>/browse.php?id=<xsl:value-of select="./@id"/>      
    </xsl:element>

    <xsl:element name="dc:creator">
      <xsl:apply-templates select="docAuthor"/>
    </xsl:element>

  </xsl:template>
  

  <!-- formatting for bibl elements, to generate a nice citation. -->
 <!-- not needed
  <xsl:template match="bibl/title"><xsl:apply-templates/>. </xsl:template>
  <xsl:template match="bibl/pubPlace">
          <xsl:apply-templates/>:  </xsl:template>
  <xsl:template match="bibl/publisher">
      <xsl:apply-templates/>, </xsl:template>
  <xsl:template
      match="bibl/biblScope[@type='volume']"><xsl:apply-templates/>, </xsl:template>
  <xsl:template
      match="bibl/biblScope[@type='issue']"><xsl:apply-templates/>, </xsl:template>
  <xsl:template match="bibl/date"><xsl:apply-templates/>. </xsl:template>
-->
  <!-- format AACR2-like list for ToC -->

<!-- create ToC list and url ids for "hasPart" -->
  <xsl:template name="hasPart">
	  <xsl:for-each select="item">
        <xsl:element name="dcterms:hasPart">
      <xsl:value-of select="$baseurl"/><xsl:value-of select="$siteurl"/><xsl:text>/browse.php?id=</xsl:text><xsl:apply-templates select="..//group/@id"/><xsl:text>&amp;doctitle=</xsl:text><xsl:apply-templates select="titlePart"/>
	</xsl:element>
	  </xsl:for-each>
     </xsl:template>



  <!-- keep on one line to avoid #10#9 output -->  
     <xsl:template match="group" mode="toc">
    </xsl:template>

<!-- handle multiple names -->
  <xsl:template match="name">
    <xsl:choose>
      <xsl:when test="position() = 1"></xsl:when>
  <xsl:when test="position() = last()">
        <xsl:text> and </xsl:text>
      </xsl:when>
    <xsl:otherwise>
	<xsl:text>, </xsl:text>
      </xsl:otherwise>
  </xsl:choose>
  <xsl:apply-templates/>
  </xsl:template>

<!-- normalize space in titles -->
  <xsl:template match="head">
    <xsl:value-of select="normalize-space(.)"/>
  </xsl:template>

<!-- add a space after titles in the head -->
  <xsl:template match="head/title">
    <xsl:apply-templates/><xsl:text> </xsl:text>
  </xsl:template>

<!-- handle <lb/> in head -->
   <xsl:template match="lb">
      <xsl:apply-templates/><xsl:text> </xsl:text>
   </xsl:template>

<!-- is this doing anything?
  <xsl:template match="result/div2">
    <xsl:element name="dc:title">
      <xsl:value-of select="head"/>
    </xsl:element>
    <xsl:element name="dc:creator">
	<xsl:apply-templates select="byline//name"/>
    </xsl:element>
    <xsl:element name="dc:identifier">
      <xsl:value-of select="$baseurl"/><xsl:value-of
      select="$siteurl"/><xsl:text>article.php?id=</xsl:text><xsl:apply-templates select="@id"/>
    </xsl:element>
  </xsl:template> -->

  <!-- ignore these: encoding specific information -->
  <xsl:template match="encodingDesc/projectDesc"/>
  <xsl:template match="encodingDesc/tagsDecl"/>
  <xsl:template match="encodingDesc/refsDecl"/>
  <xsl:template match="encodingDesc/editorialDecl"/>
  <xsl:template match="revisionDesc"/>

  <!-- normalize space for all text nodes -->
  <xsl:template match="text()">
    <xsl:value-of select="normalize-space(.)"/>
  </xsl:template>

</xsl:stylesheet>
