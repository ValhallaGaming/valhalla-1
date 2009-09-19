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
	
	$userid = $_GET["id"];
	$result = mysql_query("SELECT username, appgamingexperience, appcountry, applanguage, apphow, appwhy, appexpectations, appdefinitions, appfirstcharacter, appclarifications, appreason FROM accounts WHERE id='" . $userid . "' limit 1", $conn);
	
	$targetusername = mysql_result($result, 0, 0);
	$gamingexperience = mysql_result($result, 0, 1);
	$country = mysql_result($result, 0, 2);
	$language = mysql_result($result, 0, 3);
	$how = mysql_result($result, 0, 4);
	$why = mysql_result($result, 0, 5);
	$expectations = mysql_result($result, 0, 6);
	$definitions = mysql_result($result, 0, 7);
	$firstcharacter = mysql_result($result, 0, 8);
	$clarifications = mysql_result($result, 0, 9);
	$adminreason = mysql_result($result, 0, 9);
	if (strlen($adminreason) == 0)
	{
		$adminreason = "Write the reason why the person is denied here. This does not have any effect if you are accepting the application.";
	}
	

?>

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
	text-align: right;
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
        .style14 table tr .style1 form div table tr td p strong {
	font-size: small;
	text-align: right;
}
        .style14 table tr .style1 form div table tr td {
	font-size: xx-small;
	text-align: center;
}
        .style14 table tr .style1 form div table tr td strong {
	font-size: small;
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
				<td class="style1" valign="top" style="height: 246px; font-family: Verdana, Geneva, sans-serif; font-size: x-small; color: #900;">
		
        <script type="text/javascript" src="js/prototype/prototype.js"></script>
    	<script type="text/javascript" src="js/bramus/jsProgressBarHandler.js"></script>
        <script type="text/javascript">
		<!--
		function validate_form(thisform)
		{
            with (thisform)
              {
				var notcomplete = false;
				var field = "None";
				
              	if (thisform.accept.value==null || thisform.accept.value=="" || thisform.accept.value==null || thisform.accept.value=="")
				{
                	alert("You have not picked an option.");
					return false;
				}
				else if (thisform.deny.value  == true && (thisform.reason.value == null || thisform.reason.value == "" || thisform.reason.value.length < 10))
                {
                	notcomplete = true;
					field = "Country";
				}
					
				return true;
              }
         }
		 
		 function doCheck(thisform)
		 {
			 
		 }
		 
		 function doCheck2(thisform)
		 {

		 }
         //-->
		 </script>

	
		<form action="creviewapp.php" method="post" onSubmit="return validate_form(this)">
		  <div align="center">
		    <p><span class="style15"><strong>Application for:  <em><?php echo $targetusername; ?></strong></span></p>
		    <table width="450" border="0">
		      <tr>
		        <td width="225">Account ID:</td>
		        <td width="215"><input name="targetid" type="text" id="targetid" value="<?php echo $userid ?>" readonly="readonly"></td>
		        </tr>
		      <tr>
		        <td>Account Username:</td>
		        <td><input name="targetusername" type="text" id="targetusername" value="<?php echo $targetusername ?>" readonly="readonly"></td>
		        </tr>
		      <tr>
		        <td>&nbsp;</td>
		        <td>&nbsp;</td>
		        </tr>
		      <tr>
		        <td height="23" colspan="2">Tell us about your gaming Experience:</td>
		        </tr>
		      <tr>
		        <td colspan="2"><textarea name="gamingexperience" cols="45" rows="5" readonly="readonly" id="gamingexperience"><?php echo $gamingexperience ?></textarea></td>
		      </tr>
		    </table>
		    <table width="450" border="0">
		      <tr>
		        <td width="209">&nbsp;</td>
		        <td width="225">&nbsp;</td>
		        </tr>
		      <tr>
		        <td>Country of Residence:</td>
		        <td><input name="country" type="text" id="country" value="<?php echo $country ?>" readonly="readonly"></td>
		        </tr>
		      <tr>
		        <td>Primary Language:
		          	</td>
		        <td><input name="language" type="text" id="language" readonly="readonly"value="<?php echo $language ?>"></td>
		        </tr>
		      <tr>
		        <td>&nbsp;</td>
		        <td>&nbsp;</td>
		        </tr>
		      <tr>
		        <td colspan="2">How did you get into Grand Theft Auto Roleplay?</td>
		        </tr>
		      <tr>
		        <td colspan="2"><textarea name="how" cols="45" rows="5" readonly="readonly" id="how"><?php echo $how ?></textarea></td>
		        </tr>
		      <tr>
		        <td colspan="2">&nbsp;</td>
		        </tr>
		      <tr>
		        <td colspan="2">Why did you choose the Valhalla Gaming MTA Roleplay server over others?</td>
		        </tr>
		      <tr>
		        <td colspan="2"><textarea name="why" cols="45" rows="5" readonly="readonly" id="why"><?php echo $why ?></textarea></td>
		        </tr>
		      <tr>
		        <td colspan="2">&nbsp;</td>
		        </tr>
		      <tr>
		        <td colspan="2">What are your expectations of this server and what do you hope to get out of the server?</td>
		        </tr>
		      <tr>
		        <td colspan="2"><textarea name="expectations" cols="45" rows="5" readonly="readonly" id="expectations"><?php echo $expectations ?></textarea></td>
		        </tr>
		      <tr>
		        <td colspan="2">&nbsp;</td>
		        </tr>
		      <tr>
		        <td colspan="2">Write a brief definition of Metagaming and Powergaming</td>
		        </tr>
		      <tr>
		        <td colspan="2"><textarea name="definitions" cols="45" rows="5" readonly="readonly" id="definitions"><?php echo $definitions ?></textarea></td>
		        </tr>
		      <tr>
		        <td colspan="2">&nbsp;</td>
		        </tr>
		      <tr>
		        <td colspan="2">Finally, briefly tell us about your first character. <br>
		          (
		          Try to be original but overall be realistic. )</td>
		        </tr>
		      <tr>
		        <td colspan="2"><textarea name="firstcharacter" cols="45" rows="5" readonly="readonly" id="firstcharacter"><?php echo $firstcharacter ?></textarea></td>
		        </tr>
		      <tr>
		        <td colspan="2">&nbsp;</td>
		        </tr>
		      <tr>
		        <td colspan="2">Is there anything else you would like to add, ask or otherwise clarify?</td>
		        </tr>
		      <tr>
		        <td colspan="2"><textarea name="clarifications" cols="45" rows="5" readonly="readonly" id="clarifications"><?php echo $clarifications ?></textarea></td>
		        </tr>
		      <tr>
		        <td colspan="2"><p>
		          <br>
		          <br>
<br>
		          <br>
		          <br>
<input type="radio" name="accept" id="accept" value="accept"onClick="doCheck2(this)">
		          Accept<br>
		          <input type="radio" name="deny" id="deny" value="deny" onClick="doCheck(this)"> 
		          Deny
                  <br>
                  <textarea name="reason" cols="45" rows="5" id="reason"><?php echo $adminreason; ?></textarea>
                  <br>
		            <br>		          
		            <input type="submit" name="submit" id="submit" value="Submit">
		            </p></td>
		        </tr>
		      </table>
		    <p><span class="style15"><strong><br>
		      </strong></span><br>
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