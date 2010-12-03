<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:dc="http://purl.org/dc/elements/1.1/"
		xmlns:dcterms="http://purl.org/dc/terms"
		xmlns:tei="http://www.tei-c.org/ns/1.0"
                version="1.0">

  <xsl:output method="xml" omit-xml-declaration="yes"/>

  <xsl:template match="/">
    <xsl:element name="link">
      <xsl:attribute name="rel">schema.DC</xsl:attribute>
      <xsl:attribute name="href">http://purl.org/dc/elements/1.1/</xsl:attribute>
    </xsl:element>
    <xsl:element name="link">
      <xsl:attribute name="rel">schema.DCTERMS</xsl:attribute>
      <xsl:attribute name="href">http://purl.org/dc/terms/</xsl:attribute>
    </xsl:element>
    <xsl:apply-templates select="//dc"/>
  </xsl:template>

  <xsl:template match="dc">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="dc:*">
    <xsl:element name="meta">
      <xsl:attribute name="name">
        <xsl:value-of select="concat('DC.', local-name())"/> <!-- should tei: precede concat? -->
      </xsl:attribute>
      <xsl:choose>
        <xsl:when test="local-name() = 'format'">
          <xsl:attribute name="scheme">DCTERMS.IMT</xsl:attribute>
        </xsl:when>
        <xsl:when test="local-name() = 'type'">
          <xsl:attribute name="scheme">DCTERMS.DCMIType</xsl:attribute>
        </xsl:when>
      </xsl:choose>
      <xsl:attribute name="content"><xsl:value-of select="."/></xsl:attribute>
    </xsl:element>
  </xsl:template>

  <xsl:template match="dcterms:*">
    <xsl:element name="meta">
      <xsl:attribute name="name">
        <xsl:value-of select="concat('DCTERMS.', local-name())"/>
      </xsl:attribute>
     <xsl:attribute name="content"><xsl:value-of select="."/></xsl:attribute>
    </xsl:element>
  </xsl:template>


</xsl:stylesheet>
