<html>
<head>
   <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
   <title>Belfast Group | Workshop List</title>
   <link rel="stylesheet" type="text/css" href="web/css/belfast.css">
   <script type="text/javascript" src="web/js/overlib.js"><!-- overLIB (c) Erik Bosrup --></script>
</head>
<body>

<?php

include("common_functions.php");
include_once("lib/xmlDbConnection.class.php");
include("web/xml/wkshophead.xml");
include("web/xml/uppernav.xml");
$sort = isset($_REQUEST["sort"]) ? $_REQUEST["sort"] : "";
$view = isset($_REQUEST["view"]) ? $_REQUEST["view"] : "";

if ($sort == "") $sort = "name";	// default sort option
$headtitle = "List";

print "<div class='content'>";

$params = array("sort" => $sort, "view" => $view);
print transform("web/xml/workshop.xml", "xslt/workshop.xsl", $params);


print "</div>";

include("web/xml/lowernav.xml");

?>

</body>
</html>
