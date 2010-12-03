<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:dc="http://purl.org/dc/elements/1.1/"
		xmlns:dcterms="http://purl.org/dc/terms"
		xmlns:tei="http://www.tei-c.org/ns/1.0"
                version="1.0">
  <!-- This stylesheet creates Dublin core metadata for each workshop page -->
  <xsl:output method="xml" omit-xml-declaration="yes"/>
  <xsl:variable name="baseurl">http://beck.library.emory.edu/</xsl:variable>
  <xsl:variable name="siteurl">BelfastGroup</xsl:variable>

<!-- use to match workshop group and persistent identifier --> 
  <xsl:key name="pid" match="tei:idno" use="@n"/>

  <xsl:template match="/">
    <dc>
      <xsl:apply-templates select="//tei:teiHeader"/> <!-- get everything below this -->
      <xsl:apply-templates select="//tei:group"/>
      <dc:type>Text</dc:type>
    <dc:format>text/xml</dc:format>
    </dc>
  </xsl:template>
<!-- don't need
  <xsl:variable name="issue-id">
    <xsl:apply-templates select="//issue-id/@id"/>
  </xsl:variable>
-->
  <xsl:template match="tei:titleStmt"/><!-- do nothing with this -->
  <xsl:template match="tei:extent"/>
  
  <xsl:template match="tei:fileDesc">
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
  
  <xsl:template match="//tei:group"> <!-- for a workshop -->
    <!-- electronic publication date: Per advice of LA -->
    <xsl:variable name="id" select="@xml:id"/>
    <xsl:element name="dcterms:created">
      <xsl:value-of select="tei:docDate"/>
    </xsl:element>

    <xsl:element name="dcterms:description.tableOfContents">
     <xsl:for-each select="tei:text">
      <xsl:apply-templates select="tei:front//tei:titlePart"/><xsl:text> -- </xsl:text>
     </xsl:for-each>
    </xsl:element>

    <xsl:element name="dc:title">
      <xsl:apply-templates select="tei:head"/>, <xsl:value-of select="tei:docDate"/>
    </xsl:element>

   <xsl:element name="dc:date"><xsl:value-of select="tei:docDate"/></xsl:element>

    <xsl:element name="dc:identifier">
      <xsl:value-of select="$baseurl"/><xsl:value-of
      select="$siteurl"/>/browse.php?id=<xsl:value-of select="./@xml:id"/>      
    </xsl:element>


    <xsl:element name="dc:identifier">
      <xsl:value-of select="key('pid', $id)"/>
    </xsl:element>

    <xsl:element name="dc:creator">
      <xsl:apply-templates select="//tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:author/tei:name/tei:choice/tei:reg"/>
    </xsl:element>

  </xsl:template>
  
 <!-- series : is part of / relation -->
  <xsl:template match="tei:seriesStmt/tei:title">
    <xsl:element name="dc:relation"><xsl:value-of select="."/></xsl:element>

    <xsl:element name="dc:relation">http://beck.library.emory.edu/BelfastGroup/</xsl:element>
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
	  <xsl:for-each select="tei:item">
        <xsl:element name="dcterms:hasPart"> <!-- inserted xml: after browse.php - not sure this is correct -->
      <xsl:value-of select="$baseurl"/><xsl:value-of select="$siteurl"/><xsl:text>/browse.php?xml:id=</xsl:text><xsl:apply-templates select="..//tei:group/@xml:id"/><xsl:text>&amp;doctitle=</xsl:text><xsl:apply-templates select="tei:titlePart"/>
	</xsl:element>
	  </xsl:for-each>
     </xsl:template>



  <!-- keep on one line to avoid #10#9 output -->  
     <xsl:template match="tei:group" mode="toc">
    </xsl:template>

<!-- handle multiple names -->
  <xsl:template match="tei:name">
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
