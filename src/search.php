<?php

include_once("config.php");
include_once("lib/xmlDbConnection.class.php");
include_once("common_functions.php");


$exist_args{"debug"} =  true;
$xmldb = new xmlDbConnection($exist_args);
$xsl    = "xslt/belfast.xsl";

$kw = $_REQUEST["keyword"];
$doctitle = $_REQUEST["doctitle"];
$auth = $_REQUEST["auth"];

$pos = $_REQUEST["position"];
$max = $_REQUEST["max"];

if ($pos == '') $pos = 1;
if ($max == '') $max = 20;



$options = array();
if ($kw) 
  array_push($options, "text &= '$kw'");
if ($doctitle)
  array_push($options, "text/@id &= '$doctitle'");
if ($auth)
  array_push($options, "docAuthor &= '$auth'");


// there must be at least one search parameter for this to work
if (count($options)) {
  $searchfilter = "[" . implode(" and ", $options) . "]"; 
   // print("DEBUG: Searchfilter is $searchfilter\n");

// construct xquery
$xquery = "for \$a in /TEI.2/text/group/group$searchfilter
let \$matchcount := text:match-count(\$a)
order by \$matchcount descending
return <group>
{\$a/@id}
{\$a/head}
{\$a/text}
";
if ($kw)
  $xquery .= "<hits>{\$matchcount}</hits>";
$xquery .= "</group>";
 }
html_head("Search Results");

include("web/xml/searchhead.xml");
include("web/xml/uppernav.xml");

print '<div class="content"> 
          <h2>Search Results</h2>';


// only execute the query if there are search terms
if (count($options)) {
// run the query
$xmldb->xquery($xquery, $pos, $max); 


  print "<p><b>Search results for texts where:</b></p>
 <ul class='searchopts'>";
  if ($kw) 
    print "<li>document contains keyword(s) '$kw'</li>";
  if ($doctitle)
    print "<li>title matches '$doctitle'</li>";
  if ($auth)
    print "<li>author matches '$auth'</li>";
 
  print "</ul>";
  
  if ($xmldb->count == 0) {
    print "<p><b>No matches found.</b>
You may want to broaden your search or consult the search tips for suggestions.</p>\n";
    include("searchoptions.php");
  }

  $xsl_params = array ('mode' => "search", 'keyword' => $kw, 'doctitle' => $doctitle, 'date' => $date, 'type' => "article", 'max' => $max);
  $xmldb->xslTransform($xsl, $xsl_params);
  $xmldb->printResult();
  
} else {
  // no search terms - handle gracefully  
  print "<p><b>Error!</b> No search terms were specified.</p>";
}

print "<hr>";  
print "</div>";  
include("web/xml/lowernav.xml"); 
?>


</body>
</html>
