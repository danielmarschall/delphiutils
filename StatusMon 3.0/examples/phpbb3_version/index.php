<?php

// Version: 2010-11-16 19:35

error_reporting(E_ALL | E_NOTICE);

require 'config.inc.php';

ob_start();

echo '<h1>phpBB-Version-Monitor</h1>';

$good = false;

foreach ($phpbb_dirs as $phpbb_dir) {
	check_phpbb($phpbb_dir);
}

function check_phpbb($phpbb_dir) {
	global $good;

	echo '<h2>System: '.$phpbb_dir.'</h2>';

	define('IN_PHPBB', '');
	$table_prefix = '';
	include($phpbb_dir.'includes/constants.php');
	$version = PHPBB_VERSION;

	$latest_ver = get_latest_ver(false);

	echo '<p>phpBB-Version: ';
	if ($version == $latest_ver) {
		$good = true;
		echo '<font color="green">Aktuell</font>';
	} else {
		echo '<font color="red">Veraltet</font>';
	}
	echo ' ('.$version.' vs. '.$latest_ver.')</p>';
}

// Overal status

$c = ob_get_contents();
ob_end_clean();

if ($good) {
	header('X-Status: OK');
	echo $c;
	echo '<!-- STATUS: OK -->';
} else {
	header('X-Status: Warning');
	echo $c;
	echo '<!-- STATUS: WARNING -->';
}

// Functions

function get_latest_ver($qa = false) {
	if ($qa) {
		$url = 'http://www.phpbb.com/updatecheck/30x_qa.txt';
	} else {
		$url = 'http://www.phpbb.com/updatecheck/30x.txt';
	}

	$content = @file_get_contents($url);

	$ary = explode("\n", $content);

	$version = $ary[0];

	return $version;
}

?>