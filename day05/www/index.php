<?php
echo "<body style='background-color:pink'>";
$hostname = gethostbyaddr($_SERVER['REMOTE_ADDR']);
echo $hostname;
?>
