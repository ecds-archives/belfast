<?php

/* Configuration settings for entire site */
$in_production = true;

// set level of php error reporting -- turn off warnings when in production
if ($in_production) { 
error_reporting(E_ERROR);	// for production
 } else { error_reporting(E_ERROR | E_PARSE);
 }

// root directory and url where the website resides
if ($in_production) {
// root directory and url where the website resides
// production version
$basedir = "/home/httpd/html/beck/BelfastGroup";
$server = "beck.library.emory.edu";
$base_path = "BelfastGroup";
 }
 else {
$server = "wilson.library.emory.edu";
$base_path = "/~ahickco/belfast";
$basedir = "/home/ahickco/public_html/belfast"; 
 }
$base_url = "http://$server$base_path"; 


// add basedir to the php include path (for header/footer files and lib directory)
//set_include_path(get_include_path() . ":" . $basedir . ":" . "$basedir/lib");


//shorthand for link to main css file
$cssfile = "web/css/belfast.css";
$csslink = "<link rel='stylesheet' type='text/css' href='$base_url/$cssfile'>";
if ($in_production) {
  $port = "7080";
 } else {
  $port = "8080";}
$db = "belfast";

/*exist settings*/
$exist_args = array('host'   => $server,
	      	    'port'   => $port,
		        'db'     => $db,
		        'dbtype' => "exist");


?>
