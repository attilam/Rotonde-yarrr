<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: PUT, GET, POST");
header("Access-Control-Allow-Headers: *");

$f = 'feed.json'; // path to rotonde feed json file

if ( !file_exists($f) || (filectime($f) < (time()-60*60)) ) {
	echo `ruby feedgen.rb`;
}

$feed = json_decode(file_get_contents($f), true);	

echo json_encode($feed, JSON_UNESCAPED_SLASHES);
?>