<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.openarchives.org/OAI/2.0/"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  xmlns:xq="http://metalab.unc.edu/xql"
  xmlns:ino="http://namespaces.softwareag.com/tamino/response2" 
  xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/"
  version="1.0">

  <xsl:output method="xml" omit-xml-declaration="yes"/>
  <xsl:param name="prefix"/>

  <xsl:include href="xmldbOAI/xsl/response.xsl"/>

  <!-- match the top-level element in a tamino response & jump to the
  relevant portion (in order to skip tamino messages & cursor
  information) -->
  <!-- not using tamino
  <xsl:template match="ino:response" mode="ListIdentifiers">
    <xsl:apply-templates select="//div2" mode="ListIdentifiers"/>
  </xsl:template>

  <xsl:template match="ino:response">
    <xsl:apply-templates select="//div2"/>
  </xsl:template>
-->
  <!-- list identifiers : header information only -->
  <xsl:template match="TEI" mode="ListIdentifiers">
    <xsl:call-template name="header"/>
  </xsl:template>

  <!-- get or list records : full information (header & metadata) -->
  <xsl:template match="TEI">
    <record>
      <xsl:call-template name="header"/>
      <metadata>
        <oai_dc:dc>
          <xsl:apply-templates/>

          <dc:type>Text</dc:type>
          <dc:format>text/xml</dc:format>
        </oai_dc:dc>
      </metadata>
    </record>
  </xsl:template>

  <xsl:template name="header">
    <xsl:element name="header">            
    <xsl:element name="identifier">
      <!-- identifier prefix is passed in as a parameter; should be defined in config file -->
      <xsl:value-of select="concat($prefix, @id)" /> 
    </xsl:element>
    <xsl:element name="datestamp">
      <xsl:value-of select="LastModified"/>
    </xsl:element>
    
    <!-- get setSpec names (must match what is in config.xml) -->
    <!-- type : article or illustration -->
    <!-- FIXME: make sure case of type is set correctly? -->
    <setSpec><xsl:value-of select="concat(@type, 's')"/></setSpec>
    <!-- volume # -->
    <xsl:apply-templates select="group" mode="set"/>

  </xsl:element>
</xsl:template>


<!-- convert volume # from biblScope into correct setSpec -->
<!--
  <xsl:template match="biblScope[@type='volume']" mode="set">
  <xsl:variable name="num">
    <xsl:choose>
      <xsl:when test="contains(., ' ')">
        <xsl:value-of select="substring-after(., 'vol. ')"/>        
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="substring-after(., 'vol.')"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:call-template name="setSpec">
    <xsl:with-param name="name" select="concat('Volume ', $num)"/>
  </xsl:call-template>
</xsl:template>
-->
<!-- workshop title -->
<xsl:template match="group/head">
  <xsl:element name="dc:title"><xsl:value-of select="."/></xsl:element>
</xsl:template>

<!-- source = original publication information -->
<xsl:template match="TEI//sourceDesc">
  <xsl:element name="dc:source">
    <xsl:value-of select="."/></xsl:element>
    <!-- pick up the date --><!-- Date is not in sourceDesc, but in each workshop -->
    <xsl:apply-templates select="//group/docDate"/> 

    <!-- pick up the ark -->
    <xsl:apply-templates select="idno"/> 

  </xsl:template>


  <!-- workshop date -->
  <xsl:template match="group/docDate">
    <xsl:element name="dc:date"><xsl:value-of select="."/></xsl:element>
  </xsl:template>

  <!-- contributor -->
  <xsl:template match="titleStmt/respStmt">
    <xsl:element name="dc:contributor"><xsl:value-of select="concat(resp, ' ', name)"/></xsl:element>
  </xsl:template>

  <!-- publisher -->
  <xsl:template match="publicationStmt">
    <xsl:element name="dc:publisher">  <xsl:value-of select="publisher"/>, <xsl:value-of
    select="pubPlace"/>. <xsl:value-of select="date"/>: <xsl:value-of
    select="address/addrLine"/>.</xsl:element>
    <!-- pick up rights statement -->
    <xsl:apply-templates/>
  </xsl:template>

  <!-- rights -->
  <xsl:template match="availability">
    <xsl:element name="dc:rights"><xsl:value-of select="p"/></xsl:element>
  </xsl:template>

  <!-- series : is part of / relation -->
  <xsl:template match="seriesStmt/title">
    <xsl:element name="dc:relation"><xsl:value-of select="."/></xsl:element>

    <xsl:element name="dc:relation">http://beck.library.emory.edu/belfast/</xsl:element>
  </xsl:template>

  <!-- description -->
 <!-- <xsl:template name="description">
    <xsl:variable name="figure_count"><xsl:value-of select="count(figure)"/></xsl:variable>
    <xsl:element name="dc:description"><xsl:value-of
    select="bibl/extent"/> <xsl:if test="$figure_count > 0">,
    <xsl:value-of select="$figure_count"/> illustration<xsl:if
    test="$figure_count > 1">s</xsl:if>: <xsl:apply-templates select="figure" mode="description"/></xsl:if>.</xsl:element>

  </xsl:template> -->

  <!-- mode = description : only output figure titles in list for description -->
<!--  <xsl:template match="figure" mode="description">
    "<xsl:value-of select="head"/>"<xsl:if
  test="following-sibling::figure">, </xsl:if>
</xsl:template> -->

<!-- identifier -->
<!-- Note: this url is not yet firmly in place, but eventually it should be ... -->
<xsl:template name="identifier">
  <xsl:element
    name="dc:identifier">http://beck.library.emory.edu/belfast/browse.php?id=<xsl:value-of select="@id"/></xsl:element>
</xsl:template>

  <!-- ark identifier -->
<xsl:template match="idno[@type='ark']">
  <xsl:element name="dc:identifier">
    <xsl:value-of select="."/>
  </xsl:element>
</xsl:template>


<!-- default: ignore anything not explicitly selected (but do process child nodes) -->
<xsl:template match="node()">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="text()|@*"/>


<!-- hide tamino messages -->
<xsl:template match="xq:result|message|cursor"/>



</xsl:stylesheet>
