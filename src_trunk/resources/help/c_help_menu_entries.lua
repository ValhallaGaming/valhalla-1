help_menu =
{
	name = "Help",
	camera = { { matrix = { 1480, -1620, 13.8, 1480, -1623, 14.5 }, interior = 0 } },
	
	-- when a window is going to be created, this function is called to fill it
	window = {
		func =
			function( window )
				local label = guiCreateLabel( 0.1, 0.15, 0.8, 0.75, "Welcome to the Help System\n\nJust select the topic that interests you in the menu on the left.\n\nIf this help didn't help you any further, You can always ask online admins for help by using /report (F2)", true, window )
				guiLabelSetHorizontalAlign( label, "center", true )
			end
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
			{ matrix = { 383, 174, 1009.7, 380, 174, 1009.6 }, interior = 3 },
			{ matrix = { 1485, -1620, 72, 1485, -1720, 72 },   interior = 0 },
			{ matrix = { 1483, -1710, 13.4, 1483, -1805, 44 }, interior = 0 }
		},
		window = {
			func = function( window )
				local label = guiCreateLabel( 0.1, 0.15, 0.8, 0.75, "You can get all legal jobs from the City Hall.\n\nJust walk up to the Employee on the middle desk and choose what you want to do.\n\nIf you want to take illegal jobs, you need to find the person who's offering it.", true, window )
				guiLabelSetHorizontalAlign( label, "center", true )
			end
		},
		{
			name = "Delivery Driver"
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