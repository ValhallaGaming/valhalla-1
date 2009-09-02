help_menu =
{
	name = "Help",
	camera = { { matrix = { 1480, -1620, 13.8, 1480, -1623, 14.5 }, interior = 0, dimension = 20 } },
	
	-- when a window is going to be created, this function is called to fill it
	window = {
		text = "Welcome to the Help System\n\nJust select the topic that interests you in the menu on the left.\n\nIf this help didn't help you any further, You can always ask online admins for help by using /report (F2)"
	},
	{
		name = "Getting Started"
	},
	{
		name = "Rules"
	},
	{
		name = "Jobs",
		camera = {
			{ matrix = { 383, 174, 1009.7, 380, 174, 1009.6 }, interior = 3, dimension = 125 },
			{ matrix = { 1485, -1620, 72, 1485, -1720, 72 },   interior = 0, dimension = 0 },
			{ matrix = { 1483, -1710, 13.4, 1483, -1805, 44 }, interior = 0, dimension = 0 }
		},
		window = {
			text = "You can get all legal jobs from the City Hall.\n\nJust walk up to the Employee on the middle desk and choose what you want to do.\n\nIf you want to take illegal jobs, you need to find the person who's offering it."
		},
		{
			name = "Delivery Driver",
			multi = true,
			-- page one: depot (start)
			{
				name = "Delivery Driver",
				camera = {
					{ matrix = { -96, -1130, 25, -31, -1119, -50 }, interior = 0, dimension = 0 },
					{ matrix = { -92, -1090, 14, -41, -1175, -1 },  interior = 0, dimension = 0 }
				},
				window = {
					bottom = true,
					text = "\nOnce you've signed up for the Delivery Job, you can take a Truck from RS Haul, which is located just West of Los Santos.\n\nIf no Trucks are available, you may need to wait for one to come back, or look for another job."
				}
			},
			
			-- page two: checkpoints
			{
				name = "Delivery Driver II",
				camera = {
					{ matrix = { 1811, -1830, 22, 1886, -1873, -28 }, interior = 0, dimension = 20 }
				},
				window = {
					bottom = true,
					text = "As soon as you enter the truck, a blip will appear on the radar indicating your target location, and a marker will hint the drop-off spot to you.\n\nSimply wait at that spot for a couple of seconds, and drive to the next one.\n\nThe wage depends on the Truck's health."
				},
				onInit =
					function( )
						marker = createMarker( 1826.69140625, -1845.1533203125, 13.578125, "checkpoint", 4, 255, 200, 0, 150 )
						setElementDimension( marker, 20 )
						
						vehicle = createVehicle( 414,  1826, -1845, 13.6, 0, 0, 30 )
						setElementDimension( vehicle, 20 )
					end,
				onExit =
					function( )
						destroyElement( marker )
						marker = nil
						
						destroyElement( vehicle )
						vehicle = nil
					end
			},
			
			-- page three: depot
			{
				name = "Delivery Driver III",
				camera = {
					{ matrix = { -96, -1130, 25, -31, -1119, -50 }, interior = 0, dimension = 20 },
					{ matrix = { -92, -1090, 14, -41, -1175, -1 },  interior = 0, dimension = 20 }
				},
				window = {
					bottom = true,
					text = "\nWhen you think you've collected enough money from your trucking runs, head back to the Depot to collect your wage.\n\nEven if you quit during delivery job, your wage will be paid to you nevertheless."
				},
				onInit =
					function( )
						marker = createMarker(-69.087890625, -1111.1103515625, 0.64266717433929, "checkpoint", 4, 255, 0, 0, 150)
						setElementDimension( marker, 20 )
						setMarkerIcon( marker, "finish" )
					end,
				onExit =
					function( )
						destroyElement( marker )
						marker = nil
					end
			}
		},
		{
			name = "Taxi Driver"
		},
		{
			name = "Bus Driver"
		},
		{
			name = "City Maintenance"
		},
		{
			name = "Mechanic"
		},
		{
			name = "Locksmith"
		},
		{
			name = "Illegal Jobs"
		},
		{
			name = "Police Department",
			requirement =
				function( )
					return getElementData( localPlayer, "faction" ) ~= 1
				end
		},
		{
			name = "Emergency Services",
			requirement =
				function( )
					return getElementData( localPlayer, "faction" ) ~= 2
				end
		}
	},
	{
		name = "Vehicles",
	},
	{
		name = "Admin Help",
		requirement =
			function( )
				return getElementData( localPlayer, "adminlevel" ) and getElementData( localPlayer, "adminlevel" ) >= 1
			end
	}
}