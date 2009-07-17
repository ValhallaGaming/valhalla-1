<?php
	if (!isset($_COOKIE["username"]) || !isset($_COOKIE["password"]) || !isset($_COOKIE["uid"]))
		header('Location: index.php');
?>

<html>
	<head>
		<title>ValhallaGaming :: User Control Panel</title>
		<style type="text/css">
.style1 {
	margin-bottom: 382px;
	background-color: #B3D9FF;
}
.style5 {
	font-size: 10pt;
}
.style6 {
	text-align: center;
}
.style7 {
	border-width: 0;
	background-color: #FFFFFF;
	text-align: left;
}
.style9 {
	text-align: left;
}
.style10 {
	background-color: #B3D9FF;
}
.style11 {
	text-align: center;
	font-size: 12pt;
	color: #CC0000;
}
a:visited {
	color: #CC0000;
}
a:active {
	color: #CC0000;
}
a:hover {
	color: #CC0000;
}
.style12 {
	text-decoration: none;
}
a {
	color: #CC0000;
}
.style13 {
	text-align: left;
	font-size: 10pt;
}
</style>
	</head>
	
	<body style="margin: 0">
	<table style="width: 971px" class="style1" align="center">
		<tr>
			<td style="width: 189px; height: 64px" class="style10"></td>
			<td style="width: 618px; height: 64px" class="style6">
		<img alt="Valhalla Gaming Logo" src="http://i230.photobucket.com/albums/ee144/OwzAJ/vG5Logo.png?t=1230312326" width="251" height="97"><br>
		<strong><span class="style5">Valhalla Gaming MTA ::&nbsp; User Control 
		Panel<br>
			<?php 
				$darray = getdate(date("U"));
				echo $darray[hours] . ":" . $darray[minutes] . " - " . $darray[weekday] . ", " . $darray[mday] . "/" . $darray[month] . "/" . $darray[year];
			?>
			</span></strong></td>
			<td style="height: 64px; width: 189px;" class="style10"></td>
		</tr>
		<tr>
			<td style="height: 29px" class="style10"></td>
			<td style="width: 618px; height: 29px" class="style11">
		<strong>[ <a href="main.php" class="style12">Home</a> | 
		<a href="main.php?page=characters" class="style12">Characters</a> |
		<a class="style12" href="main.php?page=achievements">Achievements</a> | <a href="logout.php" class="style12">Log 
		Out</a> ]</strong></td>
			<td style="height: 29px; width: 189px;" class="style10"></td>
		</tr>
		<tr>
			<td style="height: 351px" valign="top" class="style13">
			<table style="width: 100%">
				<tr>
					<td class="style5" style="width: 71px"><strong>Username:</strong></td>
					<td>
					<?php 
					$username = $_COOKIE["username"];
					$username =  strtoupper(substr($username, 0, 1)) . substr($username, 1, strlen($username)-1);
					echo "<span class='style5'>" . $username . "</span>";
					?>
					</td>
				</tr>
				<tr>
					<td class="style5" style="width: 71px">&nbsp;</td>
					<td>
					</td>
				</tr>
				<tr>
					<td style="width: 71px">&nbsp;</td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td style="width: 71px">&nbsp;</td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td style="width: 71px">&nbsp;</td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td style="width: 71px">&nbsp;</td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td style="width: 71px">&nbsp;</td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td style="width: 71px">&nbsp;</td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td style="width: 71px">&nbsp;</td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td style="width: 71px">&nbsp;</td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td style="width: 71px">&nbsp;</td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td style="width: 71px">&nbsp;</td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td style="width: 71px">&nbsp;</td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td style="width: 71px">&nbsp;</td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td style="width: 71px">&nbsp;</td>
					<td>&nbsp;</td>
				</tr>
			</table>
			</td>
			<td style="width: 618px; height: 351px" class="style7" valign="top">
			
			<!--- PAGES GO HERE -->
			<?php
				$page = $_GET["page"];
				
				if (!$page)
					// main page
					echo "Coming Soon";
				else if ($page=="achievements")
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

			</td>
			<td style="height: 351px; width: 189px;" valign="top" class="style9">
			<table style="width: 100%">
				<tr>
					<td class="style5" style="width: 87px"><strong>Characters <?php
					$uid = $_COOKIE["uid"];
					$conn = mysql_connect("67.210.235.106", "phil", "mta1884ac");
					mysql_select_db("mta",$conn);
					$result = mysql_query("SELECT COUNT(id) FROM characters WHERE account='" . $uid . "'", $conn);
					mysql_close($conn);
					echo "<strong><span class='style5'>" . mysql_result($result, 0) . "</strong></span>";?>):</strong></td>
					<td rowspan="2" valign="top" class="style9"><?php 
					$uid = $_COOKIE["uid"];
					
					$conn = mysql_connect("67.210.235.106", "phil", "mta1884ac");
					mysql_select_db("mta",$conn);
					$result = mysql_query("SELECT charactername FROM characters WHERE account='" . $uid . "'", $conn);
					mysql_close($conn);
					
					for ($i=0; $i<mysql_num_rows($result); $i++)
						echo "<span class='style5'>" . str_ireplace("_", " ", mysql_result($result, $i)) . "</span><br>";
					?></td>
				</tr>
				<tr>
					<td style="width: 87px"></td>
				</tr>
			</table>
			</td>
		</tr>
	</table>
	</body>
</html>