<html>
	<head>
		<title>ValhallaGaming :: User Control Panel</title>
	</head>
	
	<body>
		<?php
		
		include( "mta_sdk.php" );
		$mtaServer = new mta("localhost", 22004);
		
		$resource = $mtaServer->getResource("ucp");
		$retn = $resource->call("getPlayersInfo");
		
		$playercount = $retn[0];
		$maxplayers = $retn[1];
		
		echo "Player Count: ", playercount , "/", maxplayers;
		?>
	</body>
</html>