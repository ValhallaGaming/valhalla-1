function CreateCheckWindow()
	triggerEvent("cursorShow", getLocalPlayer())
	Button = {}
	--Image = {}
	Window = guiCreateWindow(28,271,400,285,"Player check.",false)
	--Button[1] = guiCreateButton(0.3524,0.8387,0.2026,0.0968,"Recon player.",true,Window)
	--addEventHandler( "onClientGUIClick", Button[1], ReconPlayer)
	--Button[2] = guiCreateButton(0.5705,0.8387,0.2026,0.0968,"Freeze player.",true,Window)
	--addEventHandler( "onClientGUIClick", Button[2], FreezePlayer)
	Button[3] = guiCreateButton(0.85,0.86,0.12, 0.125,"Close",true,Window)
	addEventHandler( "onClientGUIClick", Button[3], CloseCheck )
	Label = {
		guiCreateLabel(0.03,0.07,0.66,0.0887,"Name: N/A",true,Window),
		guiCreateLabel(0.03,0.12,0.66,0.0887,"IP: N/A",true,Window),
		guiCreateLabel(0.03,0.34,0.66,0.0887,"Money: N/A",true,Window),
		guiCreateLabel(0.03,0.39,0.17,0.0806,"Health: N/A",true,Window),
		guiCreateLabel(0.20,0.39,0.30,0.0806,"Armour: N/A",true,Window),
		guiCreateLabel(0.03,0.44,0.17,0.0806,"Skin: N/A",true,Window),
		guiCreateLabel(0.20,0.44,0.30,0.0806,"Weapon: N/A",true,Window),
		guiCreateLabel(0.03,0.49,0.66,0.0806,"Faction: N/A",true,Window),
		guiCreateLabel(0.03,0.27,0.66,0.0806,"Ping: N/A",true,Window),
		guiCreateLabel(0.03,0.56,0.66,0.0806,"Vehicle: N/A",true,Window),
		false,
		guiCreateLabel(0.6,0.43,0.4031,0.0766,"Location: N/A",true,Window),
		guiCreateLabel(0.6,0.12,0.4031,0.0766,"X:",true,Window),
		guiCreateLabel(0.6,0.17,0.4031,0.0766,"Y: N/A",true,Window),
		guiCreateLabel(0.6,0.24,0.4031,0.0766,"Z: N/A",true,Window),
		guiCreateLabel(0.6,0.31,0.2907,0.0806,"Interior: N/A",true,Window),
		guiCreateLabel(0.6,0.36,0.2907,0.0806,"Dimension: N/A",true,Window),
		guiCreateLabel(0.03,0.17,0.66,0.0887,"Admin Level: N/A", true,Window),
		guiCreateLabel(0.03,0.22,0.66,0.0887,"Donator Level: N/A",true,Window),
		guiCreateLabel(0.6,0.5,0.4093,0.0806,"Hours Ingame: N/A",true,Window),
	}
	
	-- player notes
	memo = guiCreateMemo(0.03, 0.7, 0.8, 0.27, "", true, Window)
	addEventHandler( "onClientGUIClick", Window,
		function( button, state )
			if button == "left" and state == "up" then
				if source == memo then
					guiSetInputEnabled( true )
				else
					guiSetInputEnabled( false )
				end
			end
		end
	)
	Button[4] = guiCreateButton(0.85,0.7,0.12, 0.14,"Save\nNote",true,Window)
	addEventHandler( "onClientGUIClick", Button[4], SaveNote )

	--Image[1] = guiCreateStaticImage(0.4758,0.1089,0.1278,0.2177,"search.png",true,Window)
	guiSetVisible(Window, false)
end

addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()),
	function ()
		CreateCheckWindow()
	end
)

local levels = { "Trial Admin", "Admin", "Super Admin", "Lead Admin", "Head Admin", "Owner" }
function OpenCheck( ip, adminreports, donatorlevel, note )
	player = source

	guiSetText ( Label[2], "IP: " .. ip )
	guiSetText ( Label[18], "Admin Level: " .. ( levels[getElementData(player, "adminlevel") or 0] or "Player" ) .. " (" .. adminreports .. " Reports)" )
	guiSetText ( Label[19], "Donator Level: " .. donatorlevel )
	guiSetText ( memo, note )

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
			guiSetText ( Label[3], "Money: $" .. exports.global:getMoney( player ) .. " (Bank: $" .. getElementData( player, "bankmoney" ) .. ")")
			guiSetText ( Label[4], "Health: " .. math.ceil( getElementHealth( player ) ) )
			guiSetText ( Label[5], "Armour: " .. math.ceil( getPedArmor( player ) ) )
			guiSetText ( Label[6], "Skin: " .. getElementModel( player ) )
			
			local weapon = getPedWeapon( player )
			if weapon then 
				weapon = getWeaponNameFromID( weapon )
			else
				weapon = "N/A"
			end
			guiSetText ( Label[7], "Weapon: " .. weapon )

			local team = getPlayerTeam(player)
			if team then
				guiSetText ( Label[8], "Faction: " .. getTeamName(team) )
			else
				guiSetText ( Label[8], "Faction: N/A")
			end
			guiSetText ( Label[9], "Ping: " .. getPlayerPing( player ) )
			
			local vehicle = getPedOccupiedVehicle( player )
			if vehicle then
				guiSetText ( Label[10], "Vehicle: " .. getVehicleName( vehicle ) .. " (" ..getElementData( vehicle, "dbid" ) .. ")" )
			else
				guiSetText ( Label[10], "Vehicle: N/A")
			end
			guiSetText ( Label[12], "Location: " .. getZoneName( x, y, z ) )
			guiSetText ( Label[16], "Interior: " .. getElementInterior( player ) )
			guiSetText ( Label[17], "Dimension: " .. getElementDimension( player ) )
			guiSetText ( Label[20], "Hours Ingame: " .. ( getElementData( player, "hoursplayed" ) or 0 ) )
		end
	end
)

function CloseCheck( button, state )
	if source == Button[3] and button == "left" and state == "up" then
		triggerEvent("cursorHide", getLocalPlayer())
		guiSetVisible( Window, false )
		guiSetInputEnabled( false )
		player = nil
	end
end

function SaveNote( button, state )
	if source == Button[4] and button == "left" and state == "up" then
		local text = guiGetText(memo)
		if text then
			triggerServerEvent("savePlayerNote", getLocalPlayer(), player, text)
		end
	end
end

