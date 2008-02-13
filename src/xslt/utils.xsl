<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<!-- utility functions
    * space-to-nbsp     : convert normal spaces to non-breaking spaces
    * insert-nbsp       : insert a specified number of non-breaking spaces
    * replace-string    : replace all occurrences of one string with another in a specified string
    * javascript-escape : escape characters javascript regards as 'special'
    * string-after-last : return string after last occurrence of specified delimeter string
    * min		: return the smaller of two numbers
 -->

  <!-- template to convert normal spaces to  non-breaking spaces -->
  <xsl:template name="space-to-nbsp">
    <xsl:param name="str"/>
    <xsl:variable name="space">&#160;</xsl:variable>
 
    <xsl:choose>
      <xsl:when test="contains($str, ' ')">
      <xsl:value-of select="substring-before($str, ' ')"/>
       <xsl:variable name="num"><xsl:value-of
	select="string-length(translate($str, translate($str, ' ', ''),''))"/></xsl:variable>
	  <xsl:call-template name="insert-nbsp">
       	    <xsl:with-param name="num" select="$num"/>
	  </xsl:call-template>
       <xsl:value-of select="substring-after($str, ' ')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$str"/>
      </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!-- recursive template to insert non-breaking spaces -->
<xsl:template name="insert-nbsp">
  <xsl:param name="num">0</xsl:param>
  <xsl:variable name="space">&#160;</xsl:variable>

  <xsl:value-of select="$space"/>

  <xsl:if test="$num > 1">
    <xsl:call-template name="insert-nbsp">
       <xsl:with-param name="num" select="$num - 1"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>


<!-- Recursive template to replace all occurrences of one string
     ('from') with another ('to').
  (with thanks to Jeni Tennison & her XSLT  & XPath on the Edge)  -->
<xsl:template name="replace-string">
  <xsl:param name="string"/>		<!-- string in which to do replacing -->
  <xsl:param name="from"/>		<!-- string to replace -->
  <xsl:param name="to"/>		<!-- string to replace 'from' string with -->

  <xsl:choose>
    <!-- if string contains 'from' -->
    <xsl:when test="contains($string, $from)">
      <!-- output substring before 'from' string -->
      <xsl:value-of select="substring-before($string, $from)"/>
      <!-- output replacement text ('to') -->
      <xsl:value-of select="$to"/>
      <!-- recurse on substring after 'from' -->
      <xsl:call-template name="replace-string">
        <xsl:with-param name="string" select="substring-after($string, $from)"/>
        <xsl:with-param name="from" select="$from"/>
        <xsl:with-param name="to" select="$to"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <!-- string does not contain from; output unchanged -->
      <xsl:value-of select="$string"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- escape text for use with javascript; uses replace-string template (above) -->
<xsl:template name="javascript-escape">
  <xsl:param name="string"/>	<!-- string to escape -->

  <!-- replace \ with \\  
       note: this step must be done first
       (otherwise, it doubles the other escape slashes) -->
  <xsl:variable name="slash"><xsl:text>\</xsl:text></xsl:variable>
  <xsl:variable name="doubleslash"><xsl:text>\\</xsl:text></xsl:variable>
  <xsl:variable name="step1">
    <xsl:call-template name="replace-string"> 
      <xsl:with-param name="string" select="$string"/>
      <xsl:with-param name="from" select="$slash"/>
      <xsl:with-param name="to" select="$doubleslash"/>
    </xsl:call-template>
  </xsl:variable> 

  <!-- replace ' with \' -->
  <xsl:variable name="squote">&apos;</xsl:variable>
  <xsl:variable name="esc-squote"><xsl:text>\</xsl:text>&apos;</xsl:variable>
  <xsl:variable name="step2">
    <xsl:call-template name="replace-string">
      <xsl:with-param name="string" select="$step1"/>	<!-- use modified string from step1 -->
      <xsl:with-param name="from" select="$squote"/>
      <xsl:with-param name="to" select="$esc-squote"/>
    </xsl:call-template>
  </xsl:variable>

  <!-- replace " with \" -->
  <xsl:variable name="quote">&quot;</xsl:variable>
  <xsl:variable name="esc-quote"><xsl:text>\</xsl:text>&quot;</xsl:variable>
  <xsl:variable name="step3">
    <xsl:call-template name="replace-string">
      <xsl:with-param name="string" select="$step2"/>	<!-- use modified version from step2 -->
      <xsl:with-param name="from" select="$quote"/>
      <xsl:with-param name="to" select="$esc-quote"/>
    </xsl:call-template>
  </xsl:variable>

  <!-- return string with all replacements made -->
  <xsl:value-of select="normalize-space($step3)"/>	<!-- normalize to handle line breaks -->
  
</xsl:template>


  <!-- recursive template string-after-last;
       returns substring after LAST instance of specified delimiter string -->
  <xsl:template name="string-after-last">
    <xsl:param name="str"/>	<!-- input string -->
    <xsl:param name="after"/>	<!-- delimiter string -->

    <xsl:choose>
      <xsl:when test="contains($str, $after)">
        <xsl:call-template name="string-after-last">
          <xsl:with-param name="str" select="substring-after($str, $after)"/>
          <xsl:with-param name="after" select="$after"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$str"/>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>


<!-- return the smaller of two numbers -->
<xsl:template name="min">
  <xsl:param name="num1"/>
  <xsl:param name="num2"/>

  <xsl:choose>
    <xsl:when test="$num1 > $num2">
      <xsl:value-of select="$num2"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$num1"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- return the larger of two numbers -->
<xsl:template name="max">
  <xsl:param name="num1"/>
  <xsl:param name="num2"/>
  <xsl:choose>
    <xsl:when test="number($num1) > number($num2)">
      <xsl:value-of select="$num1"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$num2"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


</xsl:stylesheet>
