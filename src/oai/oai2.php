<?php

  //$argArray{"debug"} = false;
  //$oai = new xmldbConnection($argArray);

include("xmldbOAI/xmldbOAI.class.php");

$oai = new xmldbOAI();
$oai->provide();

?>