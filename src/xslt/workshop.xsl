<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">
  <xsl:include href="footnotes.xsl"/> 
  <xsl:param name="sort"/>  <!-- date or name; date is default -->
  <xsl:param name="view"/>	<!-- digital editions or all -->

  <xsl:output method="html"/>

  <xsl:template match="/">
    <xsl:call-template name="footnote-init"/>
    <xsl:variable name="count">
      <xsl:choose>
        <!-- digital editions only -->
        <xsl:when test="$view = 'digitaled'">
          <xsl:value-of select="count(//workshop/name[@id])"/>
        </xsl:when>
        <!-- all other modes display all pamphlets -->
        <xsl:otherwise>
          <xsl:value-of select="count(//workshop)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <p>
    Displaying <xsl:value-of select="$count"/> workshops         
    <xsl:if test="$view = 'digitaled'">
      (digital editions only)
    </xsl:if>

    <!-- links for sorting and filtering on digital edition 
         always retain sort or filter when changing the other option
         -->
    <xsl:variable name="viewopt">
      <xsl:if test="$view = 'digitaled'">&amp;view=digitaled</xsl:if>
    </xsl:variable>

    <br/>
    View: 
    <xsl:choose>
      <xsl:when test="$view != 'digitaled'">
        all pamphlets
      </xsl:when>
      <xsl:otherwise>
        <a>
          <xsl:attribute name="href">workshop.php?sort=<xsl:value-of select="$sort"/></xsl:attribute>
          all pamphlets</a>
      </xsl:otherwise>
    </xsl:choose>
	| 
    <xsl:choose>
      <xsl:when test="$view = 'digitaled'">
        digital editions
      </xsl:when>
      <xsl:otherwise>
        <a>
          <xsl:attribute name="href">workshop.php?sort=<xsl:value-of select="$sort"/>&amp;view=digitaled</xsl:attribute>
          digital editions
        </a>
      </xsl:otherwise>
    </xsl:choose>
    <br/>
</p>
    <xsl:apply-templates/>
    <xsl:call-template name="endnotes"/>
  </xsl:template>

  <xsl:template match="div[@class='content']/head">
    <h3><xsl:value-of select="."/></h3>
    </xsl:template>

    <xsl:template match="div[@class='workshops']">
         <xsl:choose>
       <!-- pamphlets with digital editions (id = link) -->
      <xsl:when test="$view = 'digitaled'">
      <h4><xsl:apply-templates select="head"/></h4>
        <xsl:apply-templates select="workshop[name/@id]">
          <xsl:sort select="name"/>
        </xsl:apply-templates> 
      </xsl:when>

      <!-- all pamphlets -->
      <xsl:otherwise>
      <h4><xsl:apply-templates select="head"/></h4>
        <xsl:apply-templates select="workshop | div"/>
      </xsl:otherwise> 
	 </xsl:choose>
    </xsl:template>

   <xsl:template match="workshop">
    <div class="workshop">
      <xsl:choose>
        <xsl:when test="name[@id]">
          <xsl:element name="a">
            <xsl:attribute name="href">browse.php?id=<xsl:value-of select="name/@id"/></xsl:attribute>
            <xsl:apply-templates select="name"/>
          </xsl:element><xsl:text>, </xsl:text><xsl:apply-templates select="titles"/>
      </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="name"/><xsl:text>, </xsl:text><xsl:apply-templates select="titles"/>
        </xsl:otherwise>
      </xsl:choose> 
    </div><br/>
  </xsl:template>

  <xsl:template match="div[@class='img-right']">
 <xsl:element name="div">
      <xsl:attribute name="class"><xsl:value-of select="./@class"/></xsl:attribute>
      <xsl:attribute name="style">width:<xsl:value-of select="//img/@width "/></xsl:attribute>
      <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="a">
    <xsl:copy-of select="."/>
  </xsl:template>

  <xsl:template match="img">
    <xsl:copy-of select="."/>
  </xsl:template>

  <xsl:template match="p">
    <xsl:element name="p">
      <xsl:attribute name="class"><xsl:value-of select="./@class"/></xsl:attribute>
      <xsl:apply-templates/>
    </xsl:element> 
  </xsl:template>

  <xsl:template match="name">
    <xsl:element name="b">
    <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>


</xsl:stylesheet>