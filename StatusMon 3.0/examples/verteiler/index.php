<?php

// Version: 2010-11-16 19:35

ob_start();

?><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
       "http://www.w3.org/TR/html4/loose.dtd">

<?php

error_reporting(E_ALL | E_NOTICE);

$monitors = array();

require 'config.inc.php';

?><html>

<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<title>Statusmonitor Verteilerknoten</title>
</head>

<body>
	<h1>Statusmonitor Verteilerknoten</h1>

	<table border="1">
	<tr>
		<td><b>URL</b></td>
		<td><b>Status</b></td>
	</tr>

	<?php

	define('S_OK', '<!-- STATUS: OK -->');
	define('S_WA', '<!-- STATUS: WARNING -->');

	if (count($monitors) == 0) {
		echo '<tr>';
		echo '<td colspan="2">No servers in list.</td>';
		echo '</tr>';
	}

	$c = S_OK;

	foreach ($monitors as $mon) {
		$contents = @file_get_contents($mon);

		echo '<tr>';
		echo '<td><a href="'.$mon.'" target="_blank">'.$mon.'</a></td>';

		$has_ok = strpos($contents, S_OK) !== false;
		$has_wa = strpos($contents, S_WA) !== false;

		if (($has_ok) && (!$has_wa)) {
			$s = '<font color="green">Good</font>';
		} else {
			$c = S_WA;
			if ((!$has_ok) && ($has_wa)) {
				$s = '<font color="red">Bad</font>';
			} else if ($contents === false) {
				$s = '<font color="red">Down / General error</font>';
			} else {
				$s = '<font color="red">Parse-Error</font>';
			}
		}

		echo '<td>'.$s.'</td>';
		echo '</tr>';
	}

	?>
	</table>

	<p>Allgemeiner Status: <?php

	if ($c == S_OK) {
		echo '<font color="green">Good</font>';
		header('X-Status: OK');
	} else {
		echo '<font color="red">Bad</font>';
		header('X-Status: Warning');
	}

	?>.</p>

	<?php echo $c; ?>

</body>

</html><?php

$r = ob_get_contents();
ob_end_clean();

echo $r;

?>