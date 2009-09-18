<?php
	if (!isset($_COOKIE["username"]) || !isset($_COOKIE["password"]) || !isset($_COOKIE["uid"]))
	{
		header('Location: index.php');
		exit;
	}
?>

<?php include("config.php"); ?>

<?php 
	$conn = mysql_pconnect($mysql_host, $mysql_user, $mysql_pass);
	$userid = mysql_real_escape_string($_COOKIE["uid"], $conn);
	
	mysql_select_db("mta", $conn);
	$result = mysql_query("SELECT username, admin, donator, appstate, apphandler, appreason, banned, securitykey FROM accounts WHERE id='" . $userid . "' LIMIT 1", $conn);

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
	$donator = mysql_result($result, 0, 2);
	$appstate = mysql_result($result, 0, 3);
	$apphandler = mysql_result($result, 0, 4);
	$appreason = mysql_result($result, 0, 5);
	$banned = mysql_result($result, 0, 6);
	$securitykey = mysql_result($result, 0, 7);
?>

<?php 
	function getAdminTitleFromIndex($index)
	{
		$ranks = array("No", "Trial Admin", "Administrator", "Super Admin", "Lead Admin", "Head Admin", "Owner");
		return $ranks[$index];
	}
	
	function getDonatorTitleFromIndex($index)
	{
		$ranks = array("No", "Bronze" ,"Silver", "Gold", "Platinum", "Pearl", "Diamond", "Godly");
		return $ranks[$index];
	}
	
	function getStandingFromIndex($index)
	{
		$ranks = array("<em><font color='#66FF00'>In Good Standing</font></em>", "<em><font color='#FF0000'>Banned</font></em>");
		return $ranks[$index];
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
	text-align: right;
}
        .style114 table tr td table tr td {
	text-align: left;
}
    .style14 table tr td {
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
			    <td width="20%" valign="top">
                <?php
					if ($admin > 0)
					{
						// new applications
						$result = mysql_query("SELECT COUNT(*) FROM accounts WHERE appstate=1");
						$num = mysql_result($result, 0, 0);
						echo "<font size='1'><a href='applications.php?show=1'> > New Applications (" . $num . ")</a></font><br>";
						
						// accepted
					 	$result = mysql_query("SELECT COUNT(*) FROM accounts WHERE appstate=3");
						$num = mysql_result($result, 0, 0);
						echo "<font size='1'><a href='applications.php?show=4'>> Accepted Applications (" . $num . ")</a></font><br>";
						
						// declined
						$result = mysql_query("SELECT COUNT(*) FROM accounts WHERE appstate=2");
						$num = mysql_result($result, 0, 0);
						echo "<font size='1'><a href='applications.php?show=2'>> Declined Applications (" . $num . ")</a></font><br>";
						
						// accounts without applications
						$result = mysql_query("SELECT COUNT(*) FROM accounts WHERE appstate=0");
						$num = mysql_result($result, 0, 0);
						echo "<font size='1'><a href='applications.php?show=3'>> Application-less Accounts (" . $num . ")</a></font><br>";
						
						// bans
						$result = mysql_query("SELECT COUNT(*) FROM accounts WHERE banned>0");
						$num = mysql_result($result, 0, 0);
						echo "<font size='1'><a href='applications.php?show=5'>> Banned Accounts (" . $num . ")</a></font><br>";
					}
				?>
                
                &nbsp;</td>
			    <td width="60%">
                <center>
                <?php
					if ($appstate == 3)
					{
						echo "<em><font color='#66FF00'>Your application was Accepted! (Handler: " . $apphandler . ").<br><br></font></em>";
					}
					elseif ($appstate == 2)
					{
						echo "<em><font color='#FF0000'>Your application was Denied! (Handler: " . $apphandler . ").<br><br>Reason: " . $appreason . "<br><br></font></em>";
					}
					?>
                <table width="322" border="0" align="center">
			      <tr>
			        <td colspan="2"><center>
			          <strong>Account Information</strong>
			        </center></td>
		          </tr>
			      <tr>
			        <td align="right">Application Status:</td>
			        <td align="left">
                    
                    <?php
						if ($appstate == 0)
							echo "<em><a href='writeapplication.php'><font color='#FF9900' align='left'>Click here to write one</font></a></em>";
						elseif ($appstate == 1)
							echo "<em><font color='#FF9900' align='left'>Pending Review</font></em>";
						elseif ($appstate == 2)
							echo "<em><a href='writeapplication.php'<font color='#FF0000'>Denied - Click here to write a new application.</a></font></em>";
						elseif ($appstate == 3)
							echo "<em><font color='#66FF00'>Accepted</font></em>";
					?>
                    
                    </td>
		          </tr>
			      <tr class="">
			        <td width="165" align="right">Administrator:</td>
			        <td width="147" align="left"><em><?php echo getAdminTitleFromIndex($admin) ?></em></td>
		          </tr>
			      <tr>
			        <td>Donator:</td>
			        <td align="left"><em><?php echo getDonatorTitleFromIndex($donator) ?></em></td>
		          </tr>
			      <tr>
			        <td>Account Standing:</td>
			        <td align="left"><em><?php echo getStandingFromIndex($banned) ?></em></td>
		          </tr>
			      <tr>
			        <td>Security Key:</td>
			        <td align="left"><?php echo $securitykey; ?>&nbsp;</td>
		          </tr>
		        </table></td>
			    <td width="20%">&nbsp;</td>
		      </tr>
	      </table></td>
		</tr>
</table>	</body>
</html>