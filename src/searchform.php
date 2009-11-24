<?php

include_once("config.php");
include_once("lib/xmlDbConnection.class.php");
include("common_functions.php");

html_head("Search", false);
print '</head>';
include("web/xml/searchhead.xml");
include("web/xml/uppernav.xml");
include("searchoptions.php");
include("xml/lowernav.xml");
include_once("web/xml/google-trackbelfast.xml");
?>

</body>
</html>
