<?xml version="1.0" encoding="ISO-8859-1"?> 

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:html="http://www.w3.org/TR/REC-html40" version="1.0"
	xmlns:ino="http://namespaces.softwareag.com/tamino/response2" 
	xmlns:xql="http://metalab.unc.edu/xql/" >

<!-- shared templates for more than one stylesheet -->


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

<xsl:template match="l">
<!-- FIXME: could this be pulled into the rend template? -->
  <xsl:if test="@rend != ''">
  <xsl:variable name="rend">
    <xsl:value-of select="./@rend"/>
  </xsl:variable>
  <xsl:variable name="indent">
     <xsl:value-of select="substring-after($rend, 'indent')"/>
  </xsl:variable>
   <xsl:call-template name="indent">
     <xsl:with-param name="num" select="$indent"/>
   </xsl:call-template>
 </xsl:if>

  <xsl:apply-templates/>
  <xsl:element name="br"/>
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


<!-- recursive template to insert non-breaking spaces -->
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


</xsl:stylesheet>
