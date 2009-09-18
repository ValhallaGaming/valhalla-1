<?php
	if (isset($_COOKIE["username"]) &&isset($_COOKIE["password"]) && isset($_COOKIE["uid"]))
	{
		header('Location: main.php');
		exit;
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
              	if (thisform.username.value==null || thisform.username.value==""  || thisform.username.value.length<3 || thisform.username.value.length>30 )
                {
                	alert("Please ensure you have entered a valid username.\n\n Usernames must be between 3 and 30 characters long.");
					return false;
                }
				else if (thisform.password.value==null || thisform.password.value==""  || thisform.password.value.length<3 || thisform.password.value.length>30 )
                {
                	alert("Please ensure you have entered a valid password.\n\n Passwords must be between 3 and 30 characters long.");
					return false;
                }
             	else
                {
                	return true;
                }
              }
         }
		 
		 

        Event.observe(window, 'load', function() {
          securityPB = new JS_BRAMUS.jsProgressBar($('securitybar'), 0, {animate: true, width:120, height: 12});
		}, false);


		 function hasNumbers(t)
		 {
			var regex = /\d/g;
			return regex.test(t);
		 }
		 
		 function hasSpecialCharacters(t)
		 {
			 var iChars = "!@#$%^&*()+=-[]\\\';,./{}|\":<>?~_"; 
		     for (var i = 0; i < t.length; i++) 
			 {
				if (iChars.indexOf(t.charAt(i)) != -1) 
			  		return true;
		     }
			 return false;
		  }
		 
		 function checkSecurity(field)
		 {
			 var value = field.value
			 var len = value.length
			 
			 if (hasNumbers(value))
			 	len = len * 2
				
			 if (hasSpecialCharacters(value))
			 	len = len * 2
			 
			 len = Math.round((len / 30) * 100, 0)
				
			 securityPB.setPercentage(len, false)
		 }
         //-->
		 </script>

	
		<form action="register2.php" method="post" onSubmit="return validate_form(this)">
		  <div align="center">
		    <p><span class="style15"><strong>Please enter the details for your new account below.</strong></span></p>
		    <table width="623" border="0">
		      <tr>
		        <td width="96"><p><strong>Username:</strong></p></td>
		        <td width="250"><input name="username" type="text" id="username" size="30" maxlength="30"></td>
		        <td width="263">Note: This is not your character name.</td>
		        </tr>
		      <tr>
		        <td><strong>Password:</strong></td>
		        <td><input name="password" type="password" id="password" size="30" maxlength="30" onKeyUp="checkSecurity(this)"></td>
		        <td><strong>Strength:</strong> <div class="percentImage1" id="securitybar"></div>&nbsp;</td>
		        </tr>
		      <tr>
		        <td height="57" colspan="3">
			<?php
			$errno = $_GET["errno"];
			
			if ($errno==1)
				echo "<br><strong><span class='style5'>An account with this username already exists!</span></strong><br><br>";
			elseif ($errno==2)
				echo "<br><strong><span class='style5'>An unknown error occured, please report this on the forums!</span></strong><br><br>";
			?>

<input type="submit" name="register" id="register" value="Register"></td>
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