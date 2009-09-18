<?php
	if (isset($_COOKIE["username"]) &&isset($_COOKIE["password"]) && isset($_COOKIE["uid"]))
	{
		header('Location: main.php');
		exit;
	}
		
	$errno = $_GET["errno"];
	if ($errno==3)
	{
		// allow 3 tries				
		if (!isset($_COOKIE["loginattempts"]))
			setcookie("loginattempts", "1", time()+900);
		else
			setcookie("loginattempts", $_COOKIE["loginattempts"]+1, time()+900);
	}
?>

<?php include("config.php"); ?>

<html>
	<head>
	<title>ValhallaGaming MTA :: User Control Panel</title>
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
	background-image: url('img/bg.png');
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
	background-color: #313131;
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
	font-family: Verdana;
}
.style20 {
	text-align: center;
	font-family: "Arial Narrow";
	font-size: 10pt;
	color: #FAFAFA;
}
body {
	background-image: url(img/bg.png);
	margin-left: 0px;
	margin-top: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
}
.style14 table tr .style1 form div .style4 .style16 .style8 .style19 strong {
	font-size: 10pt;
	color: #FFF;
}
        .style14 table tr .style1 form div .style8 .style19 strong {
	font-size: 12px;
}
        .style14 table tr .style1 form div .style4 .style16 strong {
	color: #900;
}
        .style14 table tr .style1 form div p .style4 .style16 .style19 strong {
	color: #900;
}
        .Seperator {
	color: #900;
}
        .Seperator {
	font-size: 14px;
}
        .Text {
	color: #FFF;
}
        a:link {
	text-decoration: none;
}
a:visited {
	text-decoration: none;
}
a:hover {
	text-decoration: none;
}
a:active {
	text-decoration: none;
}
</style>
<meta name="keywords" content="valhalla, gaming, mta, ucp">
		<meta name="description" content="Valhalla Gaming MTA UCP">
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
	
	<body text="#FFFFFF" link="#FFFFFF" vlink="#FFFFFF" alink="#FFFFFF" style="background-image: url('img/bg.png')">
<table width="1099" align="center">
		<tr>
			<td width="1089"><div id="banner">
			  <table width="1092" border="0" cellpadding="0" cellspacing="0">
			    <tbody>
			      <tr>
			        <td><img src="img/header/spacer.gif" alt="" width="128" height="1"></td>
			        <td><img src="img/header/spacer.gif" alt="" width="165" height="1"></td>
			        <td><img src="img/header/spacer.gif" alt="" width="114" height="1"></td>
			        <td><img src="img/header/spacer.gif" alt="" width="83" height="1"></td>
			        <td><img src="img/header/spacer.gif" alt="" width="86" height="1"></td>
			        <td><img src="img/header/spacer.gif" alt="" width="92" height="1"></td>
			        <td><img src="img/header/spacer.gif" alt="" width="117" height="1"></td>
			        <td><img src="img/header/spacer.gif" alt="" width="51" height="1"></td>
			        <td><img src="img/header/spacer.gif" alt="" width="112" height="1"></td>
			        <td><img src="img/header/spacer.gif" alt="" width="144" height="1"></td>
			        <td><img src="img/header/spacer.gif" alt="" width="1" height="1"></td>
		          </tr>
			      <tr>
			        <td bgcolor="#990099"><a href="http://www.valhallagaming.net/"><img src="img/header/vgBanner_r1_c1.jpg" alt="" name="vgBanner_r1_c1" width="128" height="37" hspace="0" vspace="0" border="0" id="vgBanner_r1_c1"></a></td>
			        <td><a href="http://www.valhallagaming.net/forums/forumdisplay.php?f=110"><img src="img/header/vgBanner_r1_c2.jpg" alt="" name="vgBanner_r1_c2" width="165" height="37" hspace="0" vspace="0" border="0" id="vgBanner_r1_c2"></a></td>
			        <td><a href="http://www.valhallagaming.net/forums/forumdisplay.php?f=446"><img src="img/header/vgBanner_r1_c3.jpg" alt="" name="vgBanner_r1_c3" width="114" height="37" hspace="0" vspace="0" border="0" id="vgBanner_r1_c3"></a></td>
			        <td><a href="http://www.valhallagaming.net/forums/forumdisplay.php?f=339"><img src="img/header/vgBanner_r1_c4.jpg" alt="" name="vgBanner_r1_c4" width="83" height="37" hspace="0" vspace="0" border="0" id="vgBanner_r1_c4"></a></td>
			        <td><a href="http://www.valhallagaming.net/forums/forumdisplay.php?f=216"><img src="img/header/vgBanner_r1_c5.jpg" alt="" name="vgBanner_r1_c5" width="86" height="37" hspace="0" vspace="0" border="0" id="vgBanner_r1_c5"></a></td>
			        <td><a href="http://www.valhallagaming.net/forums/forumdisplay.php?f=503"><img src="img/header/vgBanner_r1_c6.jpg" alt="" name="vgBanner_r1_c6" width="92" height="37" hspace="0" vspace="0" border="0" id="vgBanner_r1_c6"></a></td>
			        <td><a href="http://www.valhallagaming.net/forums/forumdisplay.php?f=408"><img src="img/header/vgBanner_r1_c7.jpg" alt="" name="vgBanner_r1_c7" width="117" height="37" hspace="0" vspace="0" border="0" id="vgBanner_r1_c7"></a></td>
			        <td><a href="http://forum.iv-multiplayer.com/index.php"><img src="img/header/vgBanner_r1_c8.jpg" alt="" name="vgBanner_r1_c8" width="51" height="37" hspace="0" vspace="0" border="0" id="vgBanner_r1_c8"></a></td>
			        <td colspan="2"><img src="img/header/vgBanner_r1_c9.jpg" alt="" name="vgBanner_r1_c9" width="256" height="37" id="vgBanner_r1_c9"></td>
			        <td><img src="img/header/spacer.gif" alt="" width="1" height="37"></td>
		          </tr><tr>
			        <td colspan="9"><img src="img/header/vgBanner_r2_c1.jpg" alt="" name="vgBanner_r2_c1" width="948" height="103" hspace="0" vspace="0" border="0" id="vgBanner_r2_c1"></td>
			        <td><img src="img/header/vgBanner_r2_c10.jpg" alt="" name="vgBanner_r2_c10" width="144" height="103" hspace="0" vspace="0" border="0" id="vgBanner_r2_c10"></td>
			        <td><img src="img/header/spacer.gif" alt="" width="1" height="103"></td>
		          </tr>
		        </tbody>
		      </table>
	      </div></td>
		</tr>
		<tr>
			<td width="1089" height="0" valign="middle" bgcolor="#333333" class="style9" style="height: 20px; font-family: Verdana, Geneva, sans-serif; font-size: 12px;" border="3"><strong><a href="index.php">Home</a></strong></td>
		</tr>
		<tr>
			<td height="274" class="style14" style="height: 40px">
	<table style="width: 70%; height: 100%;" align="center">
			<tr>
				<td class="style1" valign="top" style="height: 246px; font-family: Verdana, Geneva, sans-serif; font-size: 12px; color: #900;">
			
		
	
		<form action="login.php" method="post">
		  <div align="center"><span class="style15"><strong>Please login using your vG MTA account 
		    details to continue.<br>
		    <?php
			$errno = $_GET["errno"];
			$loggedout = $_GET["loggedout"];
			
			if ($errno==2)
				echo "<br><strong><span class='style5'>UCP is currently unavailable!</span></strong><br>";
			elseif ($errno==3)
			{
				echo "<br><strong><span class='style5'>Invalid Username / Password!</span></strong><br>";
			}	
			else if ($errno==4)
				echo "<br><strong><span class='style5'>You have used up your 3 login attempts. You are now locked out for 15 minutes.</span></strong><br>";
			elseif ($loggedout==1)
				echo "<br><strong><span class='style5'>You are now logged out.</span></strong><br>";
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
				$conn = mysql_pconnect($mysql_host, $mysql_user, $mysql_pass);
				
				if (!$conn)
					header('Location: resetpassword.php?errno=2');

				mysql_select_db("mta",$conn);
				$result = mysql_query("SELECT username FROM accounts WHERE securitykey='" . $securitykey . "'", $conn);
				
				
				if (!$result || mysql_num_rows($result)==0)
				{
					header('Location: resetpassword.php?errno=2');
				}
				else
				{
					$username = mysql_result($result, 0);
					$password = generatePassword(9, 4);
					$salt = "vgrpkeyscotland";
						
					$query = mysql_query("UPDATE accounts SET password='" . md5($salt . $password) . "' WHERE username='" . $username . "'", $conn);
					
					echo "<br><stong><span class='style5'>Your username is <i>" . $username . "</i> and your new password is <i>" . $password . ".</i></strong></span><br>"; 
				}
			}
			?>
		    
		    </strong></span><br>
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
		    <p><span class="Text"><a href="resetpassword.php">Forgot Password</a></span> <strong>|</strong> <span class="Text"><a href="register.php">Register</a><br>
		      </span><span class="style4"><span class="style16"><span class="style19"><br>
		      </span></span>
		      </span>
		      <span class="style16"><font size="3"><span class="style19">
		        <input type="submit" value="Login" style="width: 116px; height: 25px" />
		        </span></font></span><br>
		      </p>
          </div>
        </form>
				</td>
			</tr>
			<tr>
				<td height="14" valign="top" class="style20">
		<strong>Copyright © 2009 Valhalla Gaming.</strong></td>
			</tr>
		</table>
			</td>
		</tr>
</table>	</body>
</html>