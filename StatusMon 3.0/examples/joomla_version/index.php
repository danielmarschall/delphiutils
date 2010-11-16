<?php

// Version: 2010-11-16 19:35

error_reporting(E_ALL | E_NOTICE);

$cms_dirs = array();

require 'config.inc.php';

ob_start();

echo '<h1>Joomla-Version-Monitor</h1>';

$good = false;

foreach ($cms_dirs as $cms_dir) {
	check_cms($cms_dir);
}

function check_cms($cms_dir) {
	global $good;

	echo '<h2>CMS: '.$cms_dir.'</h2>';

	define('MD5_OLD', 'f371370fe72af1db2b939d2c3ed8bbab');
	define('MD5_NEW', '0f2f9ac773a64af2f75a7fee9c30df47');

	// 1. Joomla Core

	define('JPATH_BASE', '');
	include ($cms_dir . 'libraries/joomla/version.php');
	$v = new JVersion;
	$version = $v->getShortVersion();
	$url = 'http://versioncheck.jgerman.de/core/'.$version.'/middle';
	$xxx = file_get_contents($url);
	$md5 = md5($xxx);
	echo '<p>Joomla-Core: ';
	if ($md5 == MD5_NEW) {
		$good = true;
		echo '<font color="green">Aktuell</font>';
	} else {
		if ($md5 == MD5_OLD) {
			echo '<font color="red">Veraltet</font>';
		} else {
			echo '<font color="red">Pr&uuml;fsumme <a href="'.$url.'" target="_blank">'.$md5.'</a> unbekannt.</font>';
		}
	}
	echo ' ('.$version.')</p>';

	// 2. Backend

	$content = file_get_contents($cms_dir . 'administrator/language/de-DE/de-DE.xml');
	preg_match ('@<version>(.+?)</version>@is', $content, $matches);
	$version = $matches[1];
	$url = 'http://versioncheck.jgerman.de/lang/'.$version.'/middle';
	$xxx = file_get_contents($url);
	$md5 = md5($xxx);
	echo '<p>Backend: ';
	if ($md5 == MD5_NEW) {
		$good = true;
		echo '<font color="green">Aktuell</font>';
	} else {
		if ($md5 == MD5_OLD) {
			echo '<font color="red">Veraltet</font>';
		} else {
			echo '<font color="red">Pr&uuml;fsumme <a href="'.$url.'" target="_blank">'.$md5.'</a> unbekannt.</font>';
		}
	}
	echo ' ('.$version.')</p>';

	// 3. Frontend

	$content = file_get_contents($cms_dir . 'language/de-DE/de-DE.xml');
	preg_match ('@<version>(.+?)</version>@is', $content, $matches);
	$version = $matches[1];
	$url = 'http://versioncheck.jgerman.de/lang/'.$version.'/middle';
	$xxx = file_get_contents($url);
	$md5 = md5($xxx);
	echo '<p>Frontend: ';
	if ($md5 == MD5_NEW) {
		$good = true;
		echo '<font color="green">Aktuell</font>';
	} else {
		if ($md5 == MD5_OLD) {
			echo '<font color="red">Veraltet</font>';
		} else {
			echo '<font color="red">Pr&uuml;fsumme <a href="'.$url.'" target="_blank">'.$md5.'</a> unbekannt.</font>';
		}
	}
	echo ' ('.$version.')</p>';
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

?>