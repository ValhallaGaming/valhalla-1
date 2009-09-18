<?php
	if (isset($_COOKIE["username"]) && isset($_COOKIE["password"]) && isset($_COOKIE["uid"]))
	{
		header('Location: main.php');
		exit;
	}
		
		include("config.php");
		
		$username = $_POST["username"];
		$password = $_POST["password"];
		$salt = "vgrpkeyscotland";
		$hashpassword = md5($salt . $password);
		$conn = mysql_pconnect($mysql_host, $mysql_user, $mysql_pass);
		if (!$conn)
		{
			setcookie("uid", "", time()-3600);
			setcookie("username", "", time()-3600);
			setcookie("password", "", time()-3600);
			header('Location: index.php?errno=2');
			exit;
		}
		else if (!$username || !$password)
		{			
			setcookie("uid", "", time()-3600);
			setcookie("username", "", time()-3600);
			setcookie("password", "", time()-3600);		
			header('Location: index.php');
			exit;
		}
		else if (isset($_COOKIE["loginattempts"]) && $_COOKIE["loginattempts"]>=3)
		{
			setcookie("uid", "", time()-3600);
			setcookie("username", "", time()-3600);
			setcookie("password", "", time()-3600);		
			header('Location: index.php?errno=4');
			exit;
		}
		else
		{
			$escUsername = mysql_real_escape_string($username, $conn);
			$escPassword = mysql_real_escape_string($hashpassword, $conn);
			mysql_select_db("mta", $conn);
			$result = mysql_query("SELECT id FROM accounts WHERE username='" . $escUsername . "' AND password='" . $escPassword . "' LIMIT 1", $conn);
			if (!$result || mysql_num_rows($result)==0)
			{
				setcookie("uid", "", time()-3600);
				setcookie("username", "", time()-3600);
				setcookie("password", "", time()-3600);
				header('Location: index.php?errno=3');
				exit;
			}
			else
			{
				setcookie("username", $username, time()+3600);
				setcookie("password", $hashpassword, time()+3600);
				setcookie("uid", mysql_result($result, 0), time()+3600);
				setcookie("loginattempts", "", time()-3600);	
				header('Location: main.php');
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