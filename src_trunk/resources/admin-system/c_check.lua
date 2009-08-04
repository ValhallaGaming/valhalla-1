function CreateCheckWindow()
	triggerEvent("cursorShow", getLocalPlayer())
	Button = {}
	--Image = {}
	Window = guiCreateWindow(28,271,454,248,"Player check.",false)
	--Button[1] = guiCreateButton(0.3524,0.8387,0.2026,0.0968,"Recon player.",true,Window)
	--addEventHandler( "onClientGUIClick", Button[1], ReconPlayer)
	--Button[2] = guiCreateButton(0.5705,0.8387,0.2026,0.0968,"Freeze player.",true,Window)
	--addEventHandler( "onClientGUIClick", Button[2], FreezePlayer)
	Button[3] = guiCreateButton(0.7885,0.8387,0.1894,0.0968,"Close window.",true,Window)
	addEventHandler( "onClientGUIClick", Button[3], CloseCheck )
	Label = {
		guiCreateLabel(0.0529,0.1331,0.9524,0.0887,"Name: N/A",true,Window),
		guiCreateLabel(0.0529,0.2056,0.3524,0.0887,"IP: N/A",true,Window),
		guiCreateLabel(0.0529,0.3823,0.9524,0.0887,"Money: N/A",true,Window),
		guiCreateLabel(0.0529,0.4556,0.2093,0.0806,"Health: N/A",true,Window),
		guiCreateLabel(0.2621,0.4516,0.2093,0.0806,"Armour: N/A",true,Window),
		guiCreateLabel(0.0529,0.5323,0.2093,0.0806,"Skin: N/A",true,Window),
		guiCreateLabel(0.2621,0.5242,0.2093,0.0806,"Weapon: N/A",true,Window),
		guiCreateLabel(0.0529,0.6048,0.4531,0.0806,"Faction: N/A",true,Window),
		guiCreateLabel(0.0529,0.6773,0.2093,0.0806,"Ping: N/A",true,Window),
		guiCreateLabel(0.0529,0.804,0.2093,0.0806,"Vehicle: N/A",true,Window),
		guiCreateLabel(0.0529,0.8806,0.2093,0.0806,"Vehicle ID: N/A",true,Window),
		guiCreateLabel(0.5441,0.4435,0.4031,0.0766,"Location: N/A",true,Window),
		guiCreateLabel(0.5441,0.5323,0.4031,0.0766,"X:",true,Window),
		guiCreateLabel(0.5441,0.6169,0.4031,0.0766,"Y: N/A",true,Window),
		guiCreateLabel(0.5441,0.7056,0.4031,0.0766,"Z: N/A",true,Window),
		guiCreateLabel(0.6674,0.129,0.2907,0.0806,"Interior: N/A",true,Window),
		guiCreateLabel(0.6674,0.1935,0.2907,0.0806,"Dimension: N/A",true,Window),
		guiCreateLabel(0.5441,0.36035,0.4031,0.0766,"Admin Reports: N/A",true,Window),
		guiCreateLabel(0.0529,0.2850,0.9524,0.0887,"Donator Level: N/A",true,Window)
	}
	--Image[1] = guiCreateStaticImage(0.4758,0.1089,0.1278,0.2177,"search.png",true,Window)
	guiSetVisible(Window, false)
end

addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()),
	function ()
		CreateCheckWindow()
	end
)


function OpenCheck( ip, adminreports, donatorlevel )
	player = source

	guiSetText ( Label[2], "IP: " .. ip )
	guiSetText ( Label[18], "Admin Reports: " .. adminreports )
	guiSetText ( Label[19], "Donator Level: " .. donatorlevel )

	if not guiGetVisible( Window ) then
		guiSetVisible(Window, true)
	end
end

addEvent( "onCheck", true )
addEventHandler( "onCheck", getRootElement(), OpenCheck )


addEventHandler( "onClientRender", getRootElement(),
	function()
		if guiGetVisible(Window) then
			guiSetText ( Label[1], "Name: " .. getPlayerName(player) .. " (" .. getElementData( player, "gameaccountusername" ) .. ")")
			
			local x, y, z = getElementPosition(player)
			guiSetText ( Label[13], "X: " .. x )
			guiSetText ( Label[14], "Y: " .. y )
			guiSetText ( Label[15], "Z: " .. z )
			guiSetText ( Label[3], "Money: $" .. getElementData( player, "money" ) .. " (Bank: $" .. getElementData( player, "bankmoney" ) .. ")")
			guiSetText ( Label[4], "Health: " .. math.ceil( getElementHealth( player ) ) )
			guiSetText ( Label[5], "Armour: " .. math.ceil( getPedArmor( player ) ) )
			guiSetText ( Label[6], "Skin: " .. getElementModel( player ) )
			guiSetText ( Label[7], "Weapon: " .. getWeaponNameFromID( getPedWeapon( player ) ) )
			local team = getPlayerTeam(player)
			if team then
				guiSetText ( Label[8], "Faction: " .. getTeamName(team) )
			else
				guiSetText ( Label[8], "Faction: N/A")
			end
			guiSetText ( Label[9], "Ping: " .. getPlayerPing( player ) )
			
			local vehicle = getPedOccupiedVehicle( player )
			if vehicle then
				guiSetText ( Label[10], "Vehicle: " .. getVehicleName( vehicle ) )
				guiSetText ( Label[11], "Vehicle ID: " .. getElementData( vehicle, "dbid" ) )
			else
				guiSetText ( Label[10], "Vehicle: N/A")
				guiSetText ( Label[11], "Vehicle ID: N/A")
			end
			guiSetText ( Label[12], "Location: " .. getZoneName( x, y, z ) )
			guiSetText ( Label[16], "Interior: " .. getElementInterior( player ) )
			guiSetText ( Label[17], "Dimension: " .. getElementDimension( player ) )
		end
	end
)

function CloseCheck(sourcePlayer, command)
	triggerEvent("cursorHide", getLocalPlayer())
	guiSetVisible( Window, false )
	player = nil
end

