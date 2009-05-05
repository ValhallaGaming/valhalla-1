function PrepareCheck(sourcePlayer, command, ...)
	if (exports.global:isPlayerAdmin(sourcePlayer)) then
		if not (...) then
			outputChatBox("SYNTAX: /" .. command .. " [Partial Player Name / ID]", sourcePlayer, 255, 194, 14)
		else
			local noob = exports.global:findPlayerByPartialNick(...)
			
			local entry = getPlayerName(noob)
			if(noob) then
				local x,y,z = getElementPosition(noob)
				x = ("%.2f"):format( x )
				y = ("%.2f"):format( y )
				z = ("%.2f"):format( z )
				local ip = getPlayerIP(noob)
				--local serial = getPlayerSerial( noob )
				local health = getElementHealth ( noob )
				health = math.floor(health + 0.5) 
				local armour = getPedArmor ( noob )
				armour = math.floor(armour + 0.5)
				local skin = getElementModel ( noob )
				local weapontype = getPlayerWeapon ( noob )
				local weapon = getWeaponNameFromID( weapontype )
				local teamnumber = getPlayerTeam ( noob )
				if ( teamnumber ~= false) then
					local team = getTeamName ( teamnumber ) 
				end
				local ping = getPlayerPing( noob ) 
				local car = getPedOccupiedVehicle ( noob )
				local carname
				local carid
				if ( car ~= false) then
					carid = getElementModel(getPedOccupiedVehicle( noob )) 
					carname = getVehicleName ( car )
				end
				local loc = getElementZoneName( noob )
				local int = getElementInterior( noob )
				local world = getElementDimension ( noob )
				
				local gameaccountusername = getElementData(noob, "gameaccountusername")
				local money = tonumber(getElementData(noob, "money"))
				local bankmoney = tonumber(getElementData(noob, "bankmoney"))
				local adminreports = tonumber(getElementData(noob, "adminreports"))
				if (getElementData(noob, "loggedin")==1) then
					outputChatBox("Donator Level for " .. getPlayerName(noob) .. " is " .. exports.global:getPlayerDonatorTitle(noob) .. ".", sourcePlayer, 255, 194, 14)
				end
				triggerClientEvent (sourcePlayer,"onCheck", getRootElement(), sourcePlayer, entry, x, y, z , ip, health, armour,skin,weapon,team,ping,carid,carname,loc,int,world,gameaccountusername, money, bankmoney, adminreports)
			else
				outputChatBox("No such player online.", sourcePlayer, 255, 194, 14)
			end
		end
	end
end
addCommandHandler("check", PrepareCheck)

function Check( watcher,noob )
	local name = noob
	noob = getPlayerFromNick ( noob )
	if(noob) then
		local x,y,z = getElementPosition(noob)
		x = ("%.2f"):format( x )
		y = ("%.2f"):format( y )
		z = ("%.2f"):format( z )
		local ip = getPlayerIP(noob)
		local health = getElementHealth ( noob )
		health = math.floor(health + 0.5) 
		local armour = getPedArmor ( noob )
		armour = math.floor(armour + 0.5)
		local skin = getElementModel ( noob )
		local weapontype = getPlayerWeapon ( noob )
		local weapon = getWeaponNameFromID( weapontype )
		local teamnumber = getPlayerTeam ( noob )
		if ( teamnumber ~= false) then
			local team = getTeamName ( teamnumber ) 
		end
		local ping = getPlayerPing( noob ) 
		local car = getPedOccupiedVehicle ( noob )
		local carname
		local carid
		if ( car ~= false) then
			carid = getElementModel(getPedOccupiedVehicle( noob )) 
			carname = getVehicleName ( car )
		end
		local loc = getElementZoneName( noob )
		local int = getElementInterior( noob )
		local world = getElementDimension ( noob )
		local gameaccountusername = getElementData(noob, "gameaccountusername")
		local money = tonumber(getElementData(noob, "money"))
		local bankmoney = tonumber(getElementData(noob, "bankmoney"))
		local adminreports = tonumber(getElementData(noob, "adminreports"))
		triggerClientEvent (watcher, "onCheck", getRootElement(), watcher, name, x, y, z , ip, health, armour,skin,weapon,team,ping,carid,carname,loc,int,world,gameaccountusername, money, bankmoney, adminreports)
		
		
	end
end
addEvent( "onChecking", true )
addEventHandler( "onChecking", getRootElement(), Check )	
	
	