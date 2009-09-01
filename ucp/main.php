<?php
	if (!isset($_COOKIE["username"]) || !isset($_COOKIE["password"]) || !isset($_COOKIE["uid"]))
		header('Location: index.php');
?>

<html>
	<head>
		<title>ValhallaGaming :: User Control Panel</title>
		<style type="text/css">
.style1 {
	text-align: center;
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
.style20 {
	text-align: center;
	font-family: "Arial Narrow";
	font-size: 10pt;
	color: #FAFAFA;
}
.style21 {
	font-family: "Arial Narrow";
	font-size: 16pt;
	color: #FAFAFA;
}
.style22 {
	font-size: 10pt;
	color: #FAFAFA;
	text-align: center;
}
.style25 {
	font-size: 10pt;
	color: #FAFAFA;
	text-align: right;
}
</style>
		<meta name="keywords" content="valhalla, gaming, mta, ucp">
		<meta name="description" content="Valhalla Gaming MTA UCP">
	</head>
	
	<body style="margin: 0; background-image: url('img/FORUMBG.gif')">
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
		<span class="style21">Welcome <?php 
					$username = $_COOKIE["username"];
					$username =  strtoupper(substr($username, 0, 1)) . substr($username, 1, strlen($username)-1);
					echo "<span class='style5'>" . $username . "</span>";
					?>
.<strong><br>
		<span class="style15">
		<?php 
				$darray = getdate(date("U"));
				echo $darray[hours] . ":" . $darray[minutes] . " - " . $darray[weekday] . ", " . $darray[mday] . "/" . $darray[month] . "/" . $darray[year];
			?><br>
								
		<br>
			<!--- PAGES GO HERE -->
			<?php
				$page = $_GET["page"];
				
				if (!$page)
				{
					
				}
			?>
		<table style="width: 100%">
			<tr>
				<td class="style22" style="width: 254px">&nbsp;</td>
				<td class="style25" style="width: 53px"><strong>Username:</strong></td>
				<td style="width: 103px" class="style15">"
<?php 
					$username = $_COOKIE["username"];
					$username =  strtoupper(substr($username, 0, 1)) . substr($username, 1, strlen($username)-1);
					echo $username . "</span>";
					?>
</td>
				<td style="width: 208px" class="style15">&nbsp;</td>
			</tr>
			<tr>
				<td class="style22" style="width: 254px">&nbsp;</td>
				<td class="style25" style="width: 53px"><strong>
				<span class="style22">
				Characters:</span></td>
				<td style="width: 103px" class="style22"><?php
					$uid = $_COOKIE["uid"];
					$conn = mysql_connect("67.210.235.106", "phil", "mta1884ac");
					mysql_select_db("mta",$conn);
					$result = mysql_query("SELECT COUNT(id) FROM characters WHERE account='" . $uid . "'", $conn);
					mysql_close($conn);
					echo  mysql_result($result, 0) . "</strong></span>";?>&nbsp;</td>
				<td style="width: 208px">&nbsp;</td>				else if ($page=="achievements")
				{
					echo "
					<table style='width: 100%'>
						<tr>
							<td>
								<span class='style5'><strong><center>Achievements:</center></strong></span>
							</td>
						</tr>
					</table>
					<table style='width: 100%'>
						<tr>
							<td style='width: 15%'>
								<span class='style5'><strong><center>Points</center></strong></span>
							</td>
							<td style='width: 25%'>
								<span class='style5'><strong><center>Name</center></strong></span>
							</td>
							<td style='width: 60%'>
								<span class='style5'><strong><center>Description</center></strong></span>
							</td>
							<td style='width: 15%'>
								<span class='style5'><strong><center></center></strong></span>
							</td>
							<td style='width: 25%'>
								<span class='style5'><strong><center></center></strong></span>
							</td>
							<td style='width: 60%'>
								<span class='style5'><strong><center></center></strong></span>
							</td>

						</tr><br>";
						
						$uid = $_COOKIE["uid"];
					
						$conn = mysql_connect("67.210.235.106", "phil", "mta1884ac");
						mysql_select_db("mta",$conn);
						$result = mysql_query("SELECT achievementid FROM achievements WHERE account='" . $uid . "'", $conn);
						
						
						for ($i=0; $i<mysql_num_rows($result); $i++)
						{
							$result2 = mysql_query("SELECT points, name, description FROM achievementslist WHERE id='" . mysql_result($result, $i, 0) . "'", $conn);
							$achievements[$i][0] = mysql_result($result2, 0, 0);
							$achievements[$i][1] = mysql_result($result2, 0, 1);
							$achievements[$i][2] = mysql_result($result2, 0, 2);
						}
						mysql_close($conn);
						
						for ($i=0; $i<count($achievements); $i++)
						{
							echo "<tr>
							<td style='width: 15%'>
								<span class='style5'><strong><center>" . $achievements[$i][0] . "</center></strong></span>
							</td>
							<td style='width: 35%'>
								<span class='style5'><strong><center>" . $achievements[$i][1] . "</center></strong></span>
							</td>
							<td style='width: 50%'>
								<span class='style5'><strong><center>" . $achievements[$i][2] . "</center></strong></span>
							</td>
							</tr>";
						}
					echo "</table>";
				}
			?>
</tr>
		</table>
								
		</span><br>
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