<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">
  <xsl:include href="footnotes.xsl"/> 
  <xsl:param name="sort"/>  <!-- date or name -->
  <xsl:param name="view"/>	<!-- digital editions or all -->

<!--
  <xsl:variable name="img_url">http://beck.library.emory.edu/frenchrevolution/image-content/</xsl:variable>
  <xsl:variable name="thumb_url"><xsl:value-of select="$img_url"/>thumbnails/</xsl:variable>
-->
  <xsl:output method="html"/>

  <xsl:template match="/">
    <xsl:call-template name="footnote-init"/>
    <h3><xsl:apply-templates select="div/head"/></h3>
    <!-- get the count for currently displayed pamphlets, according to mode -->
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
  
  <!--  
      <xsl:apply-templates select="workshop"/>
      <xsl:sort select="name"/>
    </xsl:for-each>-->

     <xsl:for-each select="div/div[@class='workshops']">
       <h4><xsl:apply-templates select="head"/></h4>
       
       <xsl:choose>
       <!-- pamphlets with digital editions (id = link) -->
     <xsl:when test="$view = 'digitaled'">
        <xsl:apply-templates select="//workshop[name/@id]">
          <xsl:sort select="@group"/>
          <xsl:sort select="name"/>
        </xsl:apply-templates>
      </xsl:when>
  <!--    <xsl:when test="$view = 'digitaled' and $sort = 'date'">
        <xsl:apply-templates select="//workshop[name/@id]">
          <xsl:sort select="@group"/>
        </xsl:apply-templates>
      </xsl:when> -->
      <!-- all pamphlets -->
     <xsl:otherwise>
        <xsl:apply-templates select="//workshop">
          <xsl:sort select="@group"/>
          <xsl:sort select="name"/>
        </xsl:apply-templates>
      </xsl:otherwise> 
  <!--    <xsl:when test="$sort = 'date'">
        <xsl:apply-templates select="//workshop">
          <xsl:sort select="@group"/>
        </xsl:apply-templates>
      </xsl:when> -->
<!--       <xsl:otherwise> -->
        <!-- shouldn't ever get here; just in case, display without any sorting -->
<!--        <xsl:apply-templates/>
      </xsl:otherwise>-->
      
    </xsl:choose>
     </xsl:for-each>
    
<!--    <xsl:choose>
      <xsl:when test="$view='digitaled'">
        <xsl:apply-templates select="workshop[name/@id]"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="workshop"/>
      </xsl:otherwise>
    </xsl:choose>-->
    
    <xsl:call-template name="endnotes"/>  
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

  <xsl:template match="name">
    <xsl:element name="b">
    <xsl:apply-templates/>
    </xsl:element>
  </xsl:template>
 
</xsl:stylesheet>
