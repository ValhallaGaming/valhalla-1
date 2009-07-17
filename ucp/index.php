<?php
	if (isset($_COOKIE["username"]) &&isset($_COOKIE["password"]) && isset($_COOKIE["uid"]))
		header('Location: main.php');
?>

<html>
	<head>
		<title>ValhallaGaming :: User Control Panel</title>
		<style type="text/css">
.style1 {
	text-align: center;
}
.style4 {
	font-size: 12pt;
}
.style6 {
	text-align: right;
}
.style8 {
	text-decoration: none;
}
.style9 {
	background-image: url('img/navbarBG.png');
}
.style10 {
	font-family: Verdana;
	font-size: 10pt;
}
.style11 {
	font-family: Verdana;
	font-size: 10pt;
	text-align: right;
	color: #FFFFFF;
}
.style12 {
	font-family: Verdana;
	font-size: 10pt;
	color: #FFFFFF;
}
.style13 {
	color: #FFFFFF;
}
.style14 {
	background-image: url('img/mainBG.jpg');
}
.style15 {
	font-family: "Arial Narrow";
	font-size: 12pt;
	color: #FAFAFA;
}
.style16 {
	font-family: "Arial Narrow";
}
.style17 {
	font-size: x-small;
	font-family: "Arial Narrow";
}
.style19 {
	color: #FAFAFA;
}
.style20 {
	text-align: center;
	font-family: "Arial Narrow";
	font-size: 10pt;
	color: #FAFAFA;
}
</style>
		<meta name="keywords" content="valhalla, gaming, mta, ucp">
		<meta name="description" content="Valhalla Gaming MTA UCP">
	</head>
	
	<body style="background-image: url('img/FORUMBG.gif')">
	<table align="center">
		<tr>
			<td>
			<img alt="UCP Banner" src="img/ucpBanner.jpg" width="791" height="272"></td>
		</tr>
		<tr>
			<td class="style9" style="height: 40px">
			<table style="width: 100%; height: 29px">
				<tr>
					<td class="style12"><strong>
					<a href="index.php" class="style8"><span class="style13">
					Home</span></a></strong></td>
					<td class="style10">&nbsp;</td>
					<td class="style10">&nbsp;</td>
					<td class="style10">&nbsp;</td>
					<td class="style10">&nbsp;</td>
					<td class="style11"><strong>
					<a href="http://www.valhallagaming.net/forums" class="style8">
					<span class="style13">Forums</span></a></strong></td>
				</tr>
			</table>
			</td>
		</tr>
		<tr>
			<td class="style14" style="height: 40px">
	<table style="width: 70%; height: 100%;" align="center">
			<tr>
				<td class="style1" valign="top" style="height: 246px">
			
		
	
		<form action="login.php" method="post">
		<span class="style15"><strong>Please login using your vG.MTA account 
		details to continue.<br>
		<?php
			$errno = $_GET["errno"];
			$loggedout = $_GET["loggedout"];
			
			if ($errno==2)
				echo "<strong><span class='style5'>UCP is currently unavailable!</span></strong>";
			elseif ($errno==3)
			{
				// allow 3 tries				
				if (!isset($_COOKIE["loginattempts"]))
					setcookie("loginattempts", "1", time()+900);
				else
					setcookie("loginattempts", $_COOKIE["loginattempts"]+1, time()+900);

					echo "<strong><span class='style5'>Invalid Username / Password!</span></strong>";
			}	
			else if ($errno==4)
				echo "<strong><span class='style5'>You have used up your 3 login attempts. You are now locked out for 15 minutes.</span></strong>";
			elseif ($loggedout==1)
				echo "<strong><span class='style5'>You are now logged out.</span></strong>";
		?>
		
		<?php
			function generatePassword($length=9, $strength=0) {
				$vowels = 'aeuy';
				$consonants = 'bdghjmnpqrstvz';
				if ($strength & 1) {
					$consonants .= 'BDGHJLMNPQRSTVWXZ';
				}
				if ($strength & 2) {
					$vowels .= "AEUY";
				}
				if ($strength & 4) {
					$consonants .= '23456789';
				}
				if ($strength & 8) {
					$consonants .= '@#$%';
				}
			 
				$password = '';
				$alt = time() % 2;
				for ($i = 0; $i < $length; $i++) {
					if ($alt == 1) {
						$password .= $consonants[(rand() % strlen($consonants))];
						$alt = 0;
					} else {
						$password .= $vowels[(rand() % strlen($vowels))];
						$alt = 1;
					}
				}
				return $password;
			}

		
			$securitykey = $_POST["securitykey"];

			if ($securitykey) // was reset password
			{
				$conn = mysql_connect("67.210.235.106", "phil", "mta1884ac");
				
				if (!$conn)
					header('Location: resetpassword.php?errno=1');

				mysql_select_db("mta",$conn);
				$result = mysql_query("SELECT username FROM accounts WHERE securitykey='" . $securitykey . "'", $conn);
				
				
				if (!$result || mysql_num_rows($result)==0)
				{
					mysql_close($conn);
					header('Location: resetpassword.php?errno=2');
				}
				else
				{
					$username = mysql_result($result, 0);
					$password = generatePassword(9, 4);
					$salt = "vgrpkeyscotland";
						
					$query = mysql_query("UPDATE accounts SET password='" . md5($salt . $password) . "' WHERE username='" . $username . "'", $conn);
					
					mysql_close($conn);
					echo "<stong><span class='style5'>Your username is <i>" . $username . "</i> and your new password is <i>" . $password . ".</i></strong></span>"; 
				}
			}
			?>
					
		</strong></span>
		<br>
		<table>
			<tr>
				<td style="width: 33%" class="style15">&nbsp;</td>
				<td style="width: 80px" class="style6">
		<strong><span class="style15">Username:</span></strong></td>
				<td style="width: 135px" class="style17">
		<font size="3"><span class="style19">
		<!--webbot bot="Validation" b-value-required="TRUE" i-minimum-length="3" i-maximum-length="32" -->
		<input type="text" name="username" style="height: 20px; width: 128px;" maxlength="32" /></span></font></td>
				<td style="width: 33%" class="style15">&nbsp;</td>
			</tr>
			<tr>
				<td style="width: 33%" class="style15">&nbsp;</td>
				<td style="width: 80px" class="style6"><strong>
				<span class="style15">Password: </span></strong>
				</td>
				<td style="width: 135px" class="style17"> 
		<font size="3"><span class="style19">
		<!--webbot bot="Validation" b-value-required="TRUE" i-minimum-length="3" i-maximum-length="32" --> 
		<input type="password" name="password" style="height: 20px; width: 128px;" maxlength="32" /></span></font></td>
				<td style="width: 33%" class="style15">&nbsp;</td>
			</tr>
		</table>
		<span class="style4"><span class="style16"><a href="resetpassword.php" class="style8">
		<span class="style19">Forgotten Password?</span></a><span class="style19"><br>
		</span></span>
		</span>
		<span class="style16"><font size="3"><span class="style19">
		<input type="submit" value="Login" style="width: 116px; height: 25px" /></span></font></span><br>
		</form>
				</td>
			</tr>
			<tr>
				<td class="style20" valign="top">
			
	
		<strong>Copyright © 2009 Valhalla Gaming.</strong></td>
			</tr>
		</table>
			</td>
		</tr>
	</table>	</body>
</html>