<?php
	if ( !$_POST["username"] || $_POST["username"] == NULL)
	{
		header('Location: index.php');
		exit;
	}
		
	if (isset($_COOKIE["username"]) && isset($_COOKIE["password"]) && isset($_COOKIE["uid"]))
	{
		header('Location: main.php');
		exit;
	}
?><?php include("config.php"); ?><?php
		function encryptSerial($str)
		{
			$hash = md5($str);
			$rhash = "VGRP" . substr($hash, 17, 3) . substr($hash, 1, 2) . substr($hash, 25, 1) . substr($hash, 21, 2);
			return $rhash;
		}
			
	
		$username = $_POST["username"];
		$password = $_POST["password"];
		$conn = mysql_pconnect($mysql_host, $mysql_user, $mysql_pass);
		
		if (!$conn)
		{
			setcookie("uid", "", time()-3600);
			setcookie("username", "", time()-3600);
			setcookie("password", "", time()-3600);
			header('Location: index.php?errno=2');
		}
		
		$salt = "vgrpkeyscotland";
		$hashpassword = strtoupper(md5($salt . $password));
		
		$escUsername = mysql_real_escape_string($username, $conn);
		$escPassword = mysql_real_escape_string($hashpassword, $conn);
		
		// check the username doesn't already exist
		mysql_select_db("mta", $conn);
		$result = mysql_query("SELECT id FROM accounts WHERE username='" . $escUsername . "' LIMIT 1", $conn);
		
		if (!$result || mysql_num_rows($result)!=0)
		{
			setcookie("uid", "", time()-3600);
			setcookie("username", "", time()-3600);
			setcookie("password", "", time()-3600);
			header('Location: register.php?errno=1');
			exit;
		}
		else // create the account and log them into it
		{

			//$datetime = getdate();
			
			//$day = $datetime[mday];
			//$month = $datetime[mon];
			//$year = $datetime[year];
			
			$country = "SC";
			//$registerdate = $day . "/" . $month . "/" . $year;
			$ip = $_SERVER['REMOTE_ADDR'];
			
			// security key generation
			$keysalt1 = "vg";
			$keysalt2 = "securitykey";
			$securitykey = strtoupper(encryptSerial($keysalt1 . $username . $keysalt2));
			
			$result = mysql_query("INSERT INTO accounts SET username='" . $escUsername . "', password='" . $escPassword . "', securitykey='" . $securitykey . "', registerdate=NOW(), lastlogin=NOW(), ip='" . $ip . "', country='" . $country . "', friendsmessage='Sample Messsage'", $conn);
			
			if ($result)
			{
				setcookie("username", $username, time()+3600);
				setcookie("password", $hashpassword, time()+3600);
				setcookie("uid", mysql_insert_id($conn), time()+3600);
				setcookie("loginattempts", "", time()-3600);	
				header('Location: writeapplication.php');
				exit;
			}
			else
			{
				header('Location: register.php?errno=2');
				exit;
			}
		}
	?>
<html>
	<head>
		<title>ValhallaGaming :: User Control Panel</title>
	</head>
	
	<body>
	</body>
</html>