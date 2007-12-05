<?php

include_once("config.php");
include_once("lib/xmlDbConnection.class.php");
include("common_functions.php");


$exist_args{"debug"} =  true;
$xmldb = new xmlDbConnection($exist_args);
$xsl    = "xslt/browse.xsl";

$id = $_REQUEST["id"];


// construct xquery
$xquery = 'for $a in /TEI.2/text/group/group[@id="' . "$id" . '"]
return <group>
{$a}
</group>';
 

html_head("Workshop Poems");

include("web/xml/searchhead.xml");
include("web/xml/uppernav.xml");

print '<div class="content"> 
          <h2>Workshop Poems</h2>';


// run the query
$xmldb->xquery($xquery); 

 $xsl_params = array ('id' => $id);
  $xmldb->xslTransform($xsl, $xsl_params);
  $xmldb->printResult();
  
  
print "<hr>";  
print "</div>";  
include("web/xml/lowernav.xml"); 
?>


</body>
</html>

