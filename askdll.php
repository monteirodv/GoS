<?php
// This just lists all files besides the ones in the $ignore array.
	$ignore = Array("index.php", "js", "css", ".", "..", "loader.exe","error_log", ".ftpquota");
	$files1 = scandir("directory"); // Put the directory to where your files at	
?>

<?php
echo "{"; 
foreach($files1 as $file){
if(!in_array($file, $ignore)){						
	echo '"'. ($file) . '",';					
} }
echo "}"; 
?>