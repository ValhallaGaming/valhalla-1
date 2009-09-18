<?php
	setcookie("uid", "", time()-3600);
	setcookie("username", "", time()-3600);
	setcookie("password", "", time()-3600);
	header('Location: index.php?loggedout=1');
	exit;
?>

<html>
	<head>
		<title>ValhallaGaming :: User Control Panel</title>
	</head>
	<body><</body>
</html>