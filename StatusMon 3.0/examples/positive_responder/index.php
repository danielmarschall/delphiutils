<?php

// Version: 2010-11-16 19:35

error_reporting(E_ALL | E_NOTICE);

$good = true;

if ($good) {
	header('X-Status: OK');
	echo '<!-- STATUS: OK -->';
} else {
	header('X-Status: Warning');
	echo '<!-- STATUS: WARNING -->';
}

?>