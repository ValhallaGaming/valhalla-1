<?php
	if (!isset($_COOKIE["username"]) || !isset($_COOKIE["password"]) || !isset($_COOKIE["uid"]))
	{
		header('Location: index.php');
		exit;
	}
		
	if (!$_GET["id"])
	{
		header('Location: main.php');
		exit;
	}
?>

<?php include("config.php"); ?>

<?php 
	$conn = mysql_pconnect($mysql_host, $mysql_user, $mysql_pass);
	$userid = mysql_real_escape_string($_COOKIE["uid"], $conn);
	
	mysql_select_db("mta", $conn);
	$result = mysql_query("SELECT username, admin FROM accounts WHERE id='" . $userid . "' LIMIT 1", $conn);

	if (!$result || mysql_num_rows($result)==0)
	{
		setcookie("uid", "", time()-3600);
		setcookie("username", "", time()-3600);
		setcookie("password", "", time()-3600);		
		header('Location: index.php');
		exit;
	}
	$username = mysql_result($result, 0, 0);
	$admin = mysql_result($result, 0, 1);
	
	if ($admin < 1)
	{
		header('Location: main.php');
		exit;
	}
?>

<html>
<head>
	<title>ValhallaGaming MTA :: User Control Panel</title>
	<style type="text/css">
		.style9 {
	background-image: url('img/bg.png');
}
.style14 {
	background-color: #313131;
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
.style14 table tr td table .style14 td {
	font-weight: bold;
	text-align: right;
}
        .style14 table tr td table {
	font-size: 9px;
}
        .style14 table tr td table {
	font-size: 12px;
	text-align: left;
}
        .style14 table tr td table .style14 td {
	text-align: left;
}
        .style14 table tr td table .style14 td {
	text-align: right;
}
        td {
	text-align: left;
}
        .style15 table tr td table tr td {
	font-size: 10px;
}
        .style15 table tr td table {
	font-weight: bold;
}
        .style14 table tr td table tr td {
	text-align: center;
}
        .style114 table tr td table tr td {
	text-align: left;
}
    </style>
<meta name="keywords" content="valhalla, gaming, mta, ucp">
		<meta name="description" content="Valhalla Gaming MTA UCP">
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
	
	<body text="#FFFFFF" link="#FFFFFF" vlink="#FFFFFF" alink="#FFFFFF" style="background-image: url('img/bg.png')">
<table align="center">
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
			<td width="1089" height="23" valign="middle" bgcolor="#333333" class="style9" style="height: 20px; font-family: Verdana, Geneva, sans-serif; font-size: 12px;" border="3"><table width="1094" border="0">
		      <tr>
			      <td width="160"><span class="style9" style="height: 20px; font-family: Verdana, Geneva, sans-serif; font-size: 12px;"><strong><a href="index.php">Home</a></strong>
			          </div>
			      </span></td>
			      <td width="760"><span class="style9" style="height: 20px; font-family: Verdana, Geneva, sans-serif; font-size: 12px;"><strong>
		          <div align="center">Logged in as <?php echo $username ?></div></td>
			      <td width="160"><div align="right"><span class="style9" style="height: 20px; font-family: Verdana, Geneva, sans-serif; font-size: 12px;"><strong><a href="logout.php">Logout</a></strong>
		          </span></div></td>
	          </tr>
          </table></td>
  </tr>
		<tr>
			<td height="274" class="style14" style="height: 40px; text-align: center; font-family: Verdana; font-size: xx-small;"><table width="1094" height="154" border="1">
			  <tr>
			    <td width="15%">&nbsp;</td>
			    <td width="70%"><table width="389" border="0" align="center">
			      <tr>
			        <td width="383" colspan="2"><p>
                    
                    <?php 
						$conn = mysql_pconnect($mysql_host, $mysql_user, $mysql_pass);
						$userid = $_GET["id"];
						
						mysql_select_db("mta", $conn);
						$result = mysql_query("SELECT username, appstate, admin FROM accounts WHERE id='" . $userid . "' LIMIT 1", $conn);
					
						if (!$result || mysql_num_rows($result)==0)
						{	
							echo "Account with ID: " . $userid . " was not found.";
						}
						else
						{
							$username = mysql_result($result, 0, 0);
							$appstate = mysql_result($result, 0, 1);
							$admin = mysql_result($result, 0, 2);
							
							if ($appstate != 3)
							{
								echo "This account can not be deactivated as it is not active.";
							}
							elseif ($admin > 0)
							{
								echo "This account can not be deactivated as it is an administrator account.";
							}
							else
							{
								mysql_query("UPDATE accounts SET appstate=0 WHERE id='" . $userid . "' LIMIT 1", $conn);
								echo "'" . $username . "' is now deactivated.";
							}
						}
					?>
                    &nbsp;</p>
<p><strong><a href="main.php">&lt; Go Home</a></strong></p></td>
		          </tr>
		        </table></td>
			    <td width="15%">&nbsp;</td>
		      </tr>
	      </table></td>
		</tr>
</table>	</body>
</html>