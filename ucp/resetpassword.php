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
			
		
	
		<form action="index.php" method="post">
		<span class="style15"><strong>Please enter your vG.MTA Security Key 
		below.<br>
							
		<?php
			$errno = $_GET["errno"];
			
			if ($errno==1)
				echo "<strong><span class='style5'>UCP is currently unavailable!</span></strong>";
			elseif ($errno==2)
				echo "<strong><span class='style5'>Invalid Security Key!</span></strong>";		?>
</strong></span>
		<br>
		<table>
			<tr>
				<td style="width: 25%" class="style15">&nbsp;</td>
				<td style="width: 97px" class="style6">
		<strong><span class="style15">Security Key:</span></strong></td>
				<td style="width: 135px" class="style17">
		<font size="3"><span class="style19">
		<!--webbot bot="Validation" b-value-required="TRUE" i-minimum-length="3" i-maximum-length="32" -->
		<input type="text" name="securitykey" style="height: 20px; width: 128px;" maxlength="32" /></span></font></td>
				<td style="width: 33%" class="style15">&nbsp;</td>
			</tr>
			</table>
		<span class="style4"><span class="style16"><span class="style19"><br>
		</span></span>
		</span>
		<span class="style16"><font size="3"><span class="style19">
		<input type="submit" value="Reset Password" style="width: 116px; height: 25px" /></span></font></span><br>
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