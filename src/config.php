<?php

/* Configuration settings for entire site */

// set level of php error reporting -- turn off warnings when in production
  error_reporting(E_ERROR | E_PARSE);
//error_reporting(E_ERROR);	// for production

// root directory and url where the website resides
$server = "wilson.library.emory.edu";
$base_path = "/~ahickco/belfast";
$basedir = "/home/ahickco/public_html/belfast"; 
$base_url = "http://$server$base_path"; 

// root directory and url where the website resides
// production version
/* $basedir = "/home/httpd/html/beck/BelfastGroup";
$server = "beck.library.emory.edu";
$base_path = "BelfastGroup";
$base_url = "http://$server$base_path/";
*/

// add basedir to the php include path (for header/footer files and lib directory)
//set_include_path(get_include_path() . ":" . $basedir . ":" . "$basedir/lib");


//shorthand for link to main css file
$cssfile = "web/css/belfast.css";
$csslink = "<link rel='stylesheet' type='text/css' href='$base_url/$cssfile'>";

$port = "8080";
$db = "belfast";

/*exist settings*/
$exist_args = array('host'   => $server,
	      	    'port'   => $port,
		        'db'     => $db,
		        'dbtype' => "exist");


?>
