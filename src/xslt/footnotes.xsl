<?xml version="1.0" encoding="ISO-8859-1"?>  
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
	xmlns:html="http://www.w3.org/TR/REC-html40" 
	xmlns:ino="http://namespaces.softwareag.com/tamino/response2" 
	xmlns:xql="http://metalab.unc.edu/xql/">

<xsl:import href="utils.xsl"/>

<!-- XSLT to handle footnotes.
     Handles both Chadwyck-Healey and TEI style footnotes.

 To use: include this file, and be sure to call the named template
     'endnotes' at the end of your document (or wherever you wish endnotes to display).
 If you wish to use pop-up footnotes, be sure to call the named
     template 'footnote-init' at the beginning of your document.
 For CSS / styling:
     Links to footnotes are tagged with class footnote
     Footnote text, when displayed, are tagged as paragraphs with class footnote
-->

<!-- *** configuration parameters 
	Be sure to set these as appropriate for your documents.
-->

   <!-- Mode for numbering notes. Possible settings:
	   n-attribute : use @n within the note
           generate    : use position and count to generate number
        -->
<xsl:param name="number-mode">n-attribute</xsl:param>  
<!-- Note: in Yeats, there are notes with the n attribute, but this is
     inconsistent (which makes the numbering irregular / unworkable).  
     Using 'generate' number mode. -->

   <!-- Mode for generating note reference in the text.  Possible settings:
          ref	        : use the ref tag
	  note		: use the note tag to generate the reference 
	-->
<xsl:param name="ref-mode">ref</xsl:param>

<!-- Optional configuration for displaying notes following titles or
     headings (rather than displaying them on a separate line).
     For each node where you would like this behavior:
      * add the node name to the next-note-list (below)
      * call the named template 'next-note' at the end of your xslt template for that node 
    Note: use | to delimit node names, so partial node names will not match. 
-->
<!-- <xsl:param name="next-note-list">|caption|head|</xsl:param> -->
<xsl:param name="next-note-list">|caption|head|lg|quote|q|list|</xsl:param>


<!-- use overLib.js to display footnotes as pop-ups (in addition to
     hyperlinking to notes at the bottom of document) -->
<xsl:param name="use-popups">true</xsl:param>
  <!-- parameters used with popups -->
  <xsl:param name="overlib-url">scripts/overlib.js</xsl:param>	<!-- path to overlib -->
  <xsl:param name="popup-captions">false</xsl:param>	<!-- display captions, eg. 'Footnote 1' -->
  <xsl:param name="popup-width">300</xsl:param>	<!--  standard width for pop-up -->
  <xsl:param name="sticky-popups">true</xsl:param>	<!-- make popup stay open : true/false  -->
  <!-- make pop-ups stay (necessary if there are any links within footnotes) -->
  <!-- CSS class names for formatting popup footnotes -->
  <xsl:param name="fgclass">footnotefg</xsl:param>
  <xsl:param name="bgclass">footnotebg</xsl:param>
  <xsl:param name="textfontclass">footnotetext</xsl:param>
  <xsl:param name="captionfontclass">footnotecaption</xsl:param>
  <xsl:param name="closefontclass">closefonttext</xsl:param>	

<!-- do some initialization (needed for popups) -->
<xsl:template name="footnote-init">
  <!-- include the overlib script -->
  <!--  <xsl:element name="script">
    <xsl:attribute name="type">text/javascript</xsl:attribute>
    <xsl:attribute name="src"><xsl:value-of select="$overlib-url"/></xsl:attribute>
    <xsl:comment>overLIB (c) Erik Bosrup</xsl:comment>
  </xsl:element> -->

  <!-- store the footnote text in a javascript variable (so special
  characters & mark-up will display in pop-up version of footnote) -->
  <xsl:if test="//note">
    <xsl:element name="script">
      <xsl:attribute name="type">text/javascript</xsl:attribute>
      <xsl:apply-templates select="//note[not(parent::note)]" mode="javascript"/>
    </xsl:element>
  </xsl:if>

  <!--  <xsl:element name="div">
    <xsl:attribute name="id">overDiv</xsl:attribute>
    <xsl:attribute name="style">position:absolute;visibility:hidden;z-index:1000;</xsl:attribute>
  </xsl:element> -->

</xsl:template>

<!-- Optional template to call inside templates that may have
     following notes but also line breaks (e.g., heads or captions),
     so the note will display on the same line. -->
<xsl:template name="next-note">
  <xsl:choose>
    <xsl:when test="following::*[1][name() = 'note']">
      <xsl:apply-templates select="following::*[1][name() = 'note']">
        <xsl:with-param name="mode">next-note</xsl:with-param>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:when test="following::*[1][name() = 'ref']">
      <xsl:apply-templates select="following::*[1][name() = 'ref']">
        <xsl:with-param name="mode">next-note</xsl:with-param>
      </xsl:apply-templates>
    </xsl:when>
  </xsl:choose>
</xsl:template>


<xsl:key name="note-by-id" match="//note" use="@id"/>

<!-- some texts are tagged with refs where the note should go, and some are not -->
<xsl:template match="ref">
  <xsl:param name="mode">normal</xsl:param>	<!-- also possible: next-note -->

  <xsl:variable name="prev"><xsl:value-of select="name(preceding-sibling::*[1])"/></xsl:variable>

  <!-- add | before and after - delimiters of node-names within next-note-list -->
  <xsl:variable name="prev-match"><xsl:text>|</xsl:text><xsl:value-of select="$prev"/><xsl:text>|</xsl:text></xsl:variable>

  <xsl:if test="$ref-mode = 'ref' and 
                ($prev = '') or (not(contains($next-note-list, $prev-match))) or ($mode = 'next-note')">
    <a> 
     <xsl:attribute name="name"><xsl:value-of select="concat('notelink-', @target)"/></xsl:attribute>
     <xsl:attribute name="href"><xsl:value-of select="concat('#', @target)"/></xsl:attribute>
     <xsl:attribute name="class">footnote</xsl:attribute>
     <xsl:if test="$use-popups = 'true'">
      <xsl:apply-templates select="key('note-by-id', ./@target)" mode="ref"/>
     </xsl:if>
     <xsl:apply-templates/>
  </a>
  </xsl:if>
</xsl:template>

<!-- ignore notes in normal mode -->
<xsl:template match="note"/>


<xsl:template match="note" mode="ref">
  <xsl:param name="mode">normal</xsl:param>	<!-- also possible: next-note -->
  <!-- Check the previous sibling; if using next-note and
       next-note-list, use sibling name to determine if we should not
       display the note (already displayed using next-note) -->
  <xsl:variable name="prev"><xsl:value-of select="name(preceding-sibling::*[1])"/></xsl:variable>

  <!-- add | before and after - delimiters of node-names within next-note-list -->
  <xsl:variable name="prev-match"><xsl:text>|</xsl:text><xsl:value-of select="$prev"/><xsl:text>|</xsl:text></xsl:variable>

  <xsl:choose>
      <!-- If the previous node is blank, is not in the next-note-list, or if
           next-note mode is set, process normally.  -->
      <xsl:when test="($prev = '') or (not(contains($next-note-list, $prev-match))) or ($mode = 'next-note')">
  <!-- number of the current note - use @n if defined, or else generate via count -->
  <xsl:variable name="number">
    <xsl:choose>
      <!-- config parameter set to use n attribute for note number -->
      <xsl:when test="$number-mode = 'n-attribute'"><xsl:value-of select="@n"/></xsl:when>
      <!-- config parameter set to generate note number -->
      <xsl:when test="$number-mode = 'generate'">
        <xsl:value-of select="count(preceding::note|ancestor-or-self::note)"/>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>


     <!-- define popup settings for use in multiple cases -->

  <!-- Assign css class names in order to style popups 
       Note: must be all on one line.			-->
    <xsl:variable name="cssopts">
      <xsl:text>,CSSCLASS, FGCLASS, '</xsl:text><xsl:value-of select="$fgclass"/><xsl:text>', BGCLASS, '</xsl:text><xsl:value-of select="$bgclass"/><xsl:text>', TEXTFONTCLASS, '</xsl:text><xsl:value-of select="$textfontclass"/><xsl:text>', CAPTIONFONTCLASS, '</xsl:text><xsl:value-of select="$captionfontclass"/><xsl:text>', CLOSEFONTCLASS, '</xsl:text><xsl:value-of select="$closefontclass"/><xsl:text>'</xsl:text>
    </xsl:variable>

    <xsl:variable name="STICKY">
      <xsl:choose>
        <xsl:when test="$sticky-popups = 'true'">
          <xsl:text>, STICKY</xsl:text>
        </xsl:when>
        <xsl:otherwise><xsl:text></xsl:text></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <!-- If pop-up footnotes are enabled, create overlib function call.
	 Note: this must be all one line (it is a javascript function call).  -->

  <xsl:choose>
    <xsl:when test="$ref-mode = 'ref' and $use-popups = 'true'">
      <xsl:attribute name="onMouseOver">
        <xsl:text>overlib(</xsl:text><xsl:apply-templates select="@id" mode="jsid"/><xsl:text>, </xsl:text><xsl:if test="$popup-captions = 'true'"><xsl:text>CAPTION, 'Footnote </xsl:text><xsl:value-of select="$number"/></xsl:if><xsl:text>', WIDTH, </xsl:text><xsl:value-of select="$popup-width"/><xsl:value-of select="$cssopts"/><xsl:value-of select="$STICKY"/><xsl:text>);</xsl:text> 
      </xsl:attribute>
      <xsl:attribute name="onMouseOut">
        <xsl:text>nd();</xsl:text>
      </xsl:attribute>
    </xsl:when>
    <xsl:when test="$ref-mode = 'note'">
      <a> 
      <xsl:attribute name="name"><xsl:value-of select="concat('notelink-', @id)"/></xsl:attribute>
      <xsl:attribute name="href"><xsl:value-of select="concat('#', @id)"/></xsl:attribute>
      <xsl:attribute name="class">footnote</xsl:attribute>
      <xsl:if test="$use-popups = 'true'">
        <xsl:attribute name="onMouseOver">
          <xsl:text>overlib(</xsl:text><xsl:apply-templates select="@id" mode="jsid"/><xsl:text>, </xsl:text><xsl:if test="$popup-captions = 'true'"><xsl:text>CAPTION, 'Footnote', '</xsl:text><xsl:value-of select="$number"/></xsl:if><xsl:text>', WIDTH, </xsl:text><xsl:value-of select="$popup-width"/><xsl:value-of select="$cssopts"/><xsl:value-of select="$STICKY"/><xsl:text>);</xsl:text> 
        </xsl:attribute>
        <xsl:attribute name="onMouseOut">
          <xsl:text>nd();</xsl:text>
        </xsl:attribute>
    </xsl:if>	<!-- end if $use-popups = true -->
  <xsl:value-of select="$number"/>
  </a>
      
    </xsl:when>
  </xsl:choose>
    </xsl:when>
    <xsl:otherwise/>    <!-- don't display the footnote here-->
  </xsl:choose>

</xsl:template>

<!-- inline note : display in the text  -->
<xsl:template match="note[@place='inline']">
  <xsl:element name="p">
    <xsl:attribute name="class">inline-note</xsl:attribute>
    <xsl:choose>
      <xsl:when test="contains(@resp, 'transcr')">
        <xsl:element name="span">
          <xsl:attribute name="class">editorial</xsl:attribute>
          <xsl:apply-templates/>        
        </xsl:element>
      </xsl:when>
      <xsl:otherwise>
         <xsl:apply-templates/>        
      </xsl:otherwise>
    </xsl:choose>
  </xsl:element>
</xsl:template>

<!-- in normal mode, do nothing : only process notes at end 
<xsl:template match="note"/> -->

<!-- generate the actual text of the notes -->
<!-- Note: this template MUST be explicitly called, after the main text is
     processed -->
<xsl:template name="endnotes">
<!-- only display endnote div if there actually are notes -->
  <xsl:if test="count(//note) > 0">
    <xsl:element name="div">
      <xsl:attribute name="class">endnote</xsl:attribute>
      <xsl:element name="h2">Notes</xsl:element>
      <xsl:apply-templates select="//note[not(parent::note)]" mode="end"/>
    </xsl:element>

   <!-- if we are using popups, give credit for using overLib -->
   <xsl:if test="$use-popups = 'true'">
     <!-- link / image to give credit for using overLib -->
  
     <xsl:element name="div">
       <xsl:attribute name="class">poweredby</xsl:attribute>
       <a href="http://www.bosrup.com/web/overlib/">
         <img src="web/images/overLib.gif" width="88" height="31" alt="Popups by overLIB" border="0"/></a> 
       <!-- link / image from overLib website -->
     </xsl:element>
      <!-- FIXME: permanent location for this image? -->
   </xsl:if>

 </xsl:if>    

</xsl:template>

<!-- note, endnote mode : display number/symbol and content of note; 
     link back to ref in the text 
     (do not handle inline notes here)
-->
<xsl:template match="note" mode="end">
  <div>
    <xsl:if test="@resp">
      <xsl:attribute name="class"><xsl:value-of select="@resp"/></xsl:attribute>
    </xsl:if>
  <xsl:variable name="number">
    <xsl:choose>
      <!-- config parameter set to use n attribute for note number -->
      <xsl:when test="$number-mode = 'n-attribute'"><xsl:value-of select="@n"/></xsl:when>
      <!-- config parameter set to generate note number -->
      <xsl:when test="$number-mode = 'generate'">
        <xsl:value-of select="position()"/>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>

  <!-- note: retrieving  & displaying the page number where a footnote occurs;
 (Many of the genre fiction texts number footnotes by page starting
 from 1 on each page, so there may be many footnotes numbered '1' in a
 given section or chapter).  
 Also note: because of the preceding pb outside the returned div,
 needs a little extra logic to ensure the first page # displayed is correct. --> 

  <xsl:variable name="pb"><xsl:value-of select="preceding::pb[1]/@n"/></xsl:variable>
  <xsl:variable name="next-pb"><xsl:value-of select="following::pb[1]/@n"/></xsl:variable>

  <!-- convert preceding & following page number strings to numbers -->
  <xsl:variable name="prev-pnum">
    <xsl:choose>
      <xsl:when test="contains($pb, ' ')">
        <xsl:value-of select="substring-before($pb, ' ')"/>
      </xsl:when>
      <xsl:when test="contains($pb, '[')">	<!-- format could be [#] -->
        <xsl:value-of select="substring-before(substring-after($pb, '['),']')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$pb"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="next-pnum">
    <xsl:choose>
      <xsl:when test="contains($next-pb, ' ')">
        <xsl:value-of select="substring-before($next-pb, ' ')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$next-pb"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!-- compare the next & following page numbers to make sure we display the right one -->
  <xsl:variable name="pagenum">
    <xsl:choose>
      <xsl:when test="$prev-pnum = ($next-pnum - 1)">
        <xsl:value-of select="$prev-pnum"/>
      </xsl:when>
      <xsl:when test="contains($prev-pnum, '[')">	<!-- format : [#] -->
        <xsl:value-of select="substring-before(substring-after($prev-pnum, '['),']')"/>
      </xsl:when>
      <xsl:when test="$next-pnum != ''">	<!-- if next-pnum is defined & != to prev-pnum, then prev-pnum must be wrong -->
	<xsl:value-of select="$next-pnum - 1"/>		<!-- generate page number based on the math -->
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$prev-pnum"/>	<!-- if next-pnum is not defined, use the preceding page number -->
      </xsl:otherwise>
    </xsl:choose>    
  </xsl:variable>
  
  <xsl:element name="p">
    <xsl:attribute name="class">footnote</xsl:attribute>

    <xsl:if test="$pagenum != '' and $pagenum != 'NaN'">	<!-- neither blank nor "Not a Number" -->
      <span class="fn-pagen"><a><xsl:attribute name="href">#page<xsl:value-of select="$pagenum"/></xsl:attribute>
    	  Page  <xsl:value-of select="$pagenum"/></a> 
      </span>
    </xsl:if>

    <!-- only output the dash separator if both page number & id are used. -->
    <xsl:if test="$pagenum != '' and $pagenum != 'NaN' and @id">
      <xsl:text> - </xsl:text>
    </xsl:if>

  <xsl:choose>
    <!-- in some rare cases, there is no id: just a footnote with no specified place. -->
    <xsl:when test="@id">
      <xsl:element name="a">
        <xsl:attribute name="name"><xsl:value-of select="@id"/></xsl:attribute>
        <xsl:attribute name="href"><xsl:value-of select="concat('#','notelink-', @id)"/></xsl:attribute>
        <xsl:attribute name="title">Return to text</xsl:attribute>
        <xsl:value-of select="$number"/> 
      </xsl:element>. <!-- a -->
      
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>. </xsl:text>
    </xsl:otherwise>
  </xsl:choose>
 
  <xsl:apply-templates mode="endnote"/>

  <!-- special case: properly display poetry within a note -->
  <xsl:if test="count(.//l) > 0">
   <table border="0">
      <tr><td>
        <xsl:apply-templates select="l"/>
      </td></tr>
    </table>
  </xsl:if>    
  </xsl:element> <!-- p -->
</div>
</xsl:template>

<xsl:template match="note/note" mode="endnote">
  <span>
    <xsl:attribute name="class"><xsl:value-of select="@resp"/></xsl:attribute>
    <xsl:apply-templates mode="endnote"/>
  </span>
</xsl:template>

<xsl:template match="note/p" mode="endnote">
   <xsl:apply-templates/><br/>
</xsl:template> 

<!-- handle poetry lines within a note separately -->
<xsl:template match="note/l" mode="endnote">
</xsl:template>

<xsl:template match="note/caption" mode="endnote">
  <xsl:element name="span">
    <xsl:attribute name="class">endnote-caption</xsl:attribute>
    <xsl:apply-templates/> 
  </xsl:element>
<xsl:text> </xsl:text>
</xsl:template>

<!-- endnote mode: convert turn a ref inside a note into a link -->
<xsl:template match="note/ref" mode="endnote">
  <xsl:element name="a">
    <xsl:attribute name="href">content.php?level=div&amp;id=<xsl:value-of select="@target"/></xsl:attribute>
    <xsl:attribute name="target">_top</xsl:attribute>
    <xsl:apply-templates/>
  </xsl:element>
</xsl:template>

<!-- if a hi tag occurs at the note level (not inside a p or l), explicitly call the normal mode hi template -->
<!--<xsl:template match="note/hi" mode="endnote">
  <xsl:apply-templates select="."/>
</xsl:template> -->

<!-- javascript modes: convert turn a ref inside a note into a link
     (note: space disappears before link; put one in.) -->
<xsl:template match="note/ref" mode="javascript">
  <xsl:text> </xsl:text><xsl:element name="a">
    <xsl:attribute name="href">cti-tgfwfw-<xsl:value-of select="@target"/></xsl:attribute>
    <xsl:attribute name="target">_top</xsl:attribute>
    <xsl:apply-templates/>
  </xsl:element>
</xsl:template>


<xsl:template match="note/hi" mode="endnote">
 <span>
   <xsl:attribute name="class"><xsl:value-of select="@rend"/></xsl:attribute>
   <xsl:apply-templates/>
 </span>
</xsl:template>

<xsl:template match="title" mode="endnote">
  <xsl:apply-templates select="."/>
</xsl:template>

<xsl:template match="title" mode="javascript">
  <span class="title"><xsl:apply-templates mode="javascript"/></span>
</xsl:template>


  <!-- enclose text in a javascript variable -->
  <xsl:template match="note" mode="javascript">
    var <xsl:apply-templates select="@id" mode="jsid"/> = '<xsl:apply-templates mode="javascript"/>';
  </xsl:template>

  <!-- escape any single quotes so it doesn't mess up the javascript string -->
  <xsl:template match="text()" mode="javascript">

    <!-- preserve leading space -->
    <xsl:if test="starts-with(., ' ')">
      <xsl:text> </xsl:text>
    </xsl:if>

  <xsl:variable name="squote">&apos;</xsl:variable>
  <xsl:variable name="esc-squote"><xsl:text>\</xsl:text>&apos;</xsl:variable>
    <xsl:call-template name="replace-string">
      <xsl:with-param name="string" select="normalize-space(.)"/>
      <xsl:with-param name="from" select="$squote"/>
      <xsl:with-param name="to" select="$esc-squote"/>
    </xsl:call-template>

    <!-- preserve ending space -->
    <xsl:if test="substring(., string-length(.), .)">
      <xsl:text> </xsl:text>
    </xsl:if>
  </xsl:template>

<!-- note: for some reason, was losing spacing before & after text -->
<xsl:template match="hi" mode="javascript">
 <xsl:text> </xsl:text>
 <xsl:element name="span">
   <xsl:attribute name="class"><xsl:value-of select="@rend"/></xsl:attribute>
   <xsl:apply-templates mode="javascript"/>
 </xsl:element>
  <xsl:text> </xsl:text>
</xsl:template>


<!-- convert id string to a valid javascript variable name
	currently handles:  . - 
-->
<xsl:template match="@id" mode="jsid">

  <!-- starting value of id string -->
  <xsl:variable name="string"><xsl:value-of select="."/></xsl:variable>

  <!-- replace . with _ -->
  <xsl:variable name="period"><xsl:text>.</xsl:text></xsl:variable>
  <xsl:variable name="underscore"><xsl:text>_</xsl:text></xsl:variable>
  <xsl:variable name="step1">
    <xsl:call-template name="replace-string"> 
      <xsl:with-param name="string" select="$string"/>
      <xsl:with-param name="from" select="$period"/>
      <xsl:with-param name="to" select="$underscore"/>
    </xsl:call-template>
  </xsl:variable> 

  <!-- replace - with _ -->
  <xsl:variable name="dash"><xsl:text>-</xsl:text></xsl:variable>
  <xsl:variable name="step2">
    <xsl:call-template name="replace-string"> 
      <xsl:with-param name="string" select="$step1"/>
      <xsl:with-param name="from" select="$dash"/>
      <xsl:with-param name="to" select="$underscore"/>
    </xsl:call-template>
  </xsl:variable> 

  <!-- if more replacements are needed, add more step variables & output final step -->

  <xsl:value-of select="$step2"/>
</xsl:template>


</xsl:stylesheet>