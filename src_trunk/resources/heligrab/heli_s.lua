--[[ Heligrab - Server ]]--

local root = getRootElement()
local hanging_weight_limit = true

function ToggleHangingWeightLimit(state)
	hanging_weight_limit = state
	triggerClientEvent(root,"ToggleHangingWeightLimit",root,state)
end


addEvent("RequestHangingWeightLimit",true)
addEventHandler("RequestHangingWeightLimit",root,function()
	triggerClientEvent(source,"ToggleHangingWeightLimit",root,hanging_weight_limit)
end)


function SetPlayerGrabbedHeli(player,state,heli,side_,line_percent_)
	if player then
		if state == true then
			-- if we have been given a heli
			if heli and getElementType(heli) == "vehicle" and getVehicleType(heli) == "Helicopter" then
				-- dont want to grab while also in a vehicle
				-- actually, there are too many possible situations to account for so leave it up to the caller to make sure the player is in a suitable state to be attached
				--if not isPedInVehicle(player) then
				
				-- default values
				local side = side_ or "right"
				local line_percent = line_percent_ or 0.5
					
				triggerClientEvent(player,"MakePlayerGrabHeli",player,heli,side,line_percent)
			end
		elseif state == false then
			local player_hanging = getElementData(player,"hanging")
			if player_hanging then
				triggerEvent("PlayerDropFromHeli",player,player_hanging.heli,"requested")
			end		
		end
	end
end


addEventHandler("onElementDestroy",root,function()
	if getElementType(source)=="vehicle" then
		if getVehicleType(source)=="Helicopter" then
			triggerClientEvent(root,"onClientVehicleDestroy",root,source)
		end
	end
end)


-- setting the camera target clientside frequently doesnt work (possible problem with getVehicleOccupant clientside), so do it serverside instead
function PlayerGrabVehicle(vehicle)
	SetCameraToHeliPilot(source,vehicle)
--	outputChatBox("Grabbed vehicle: "..getPlayerName(source))
end
addEvent("PlayerGrabVehicle",true)
addEventHandler("PlayerGrabVehicle",root,PlayerGrabVehicle)



function PlayerDropFromHeli(vehicle,reason)
	setCameraTarget(source,source)
--	outputChatBox("Dropped from heli: "..getPlayerName(source).." ["..reason.."]")
	triggerClientEvent(root,"PlayerDrop",source,reason,vehicle)
end
addEvent("PlayerDropFromHeli",true)
addEventHandler("PlayerDropFromHeli",root,PlayerDropFromHeli)



function SetCameraToHeliPilot(player,heli)
	local heli_driver = getVehicleOccupant(heli,0)
	if heli_driver then
		setCameraTarget(player,heli_driver)
--		outputChatBox("Set camera to heli")
	else
--		outputChatBox("could not set camera to pilot ("..tostring(heli_driver)..")")
	end	
end


-- reset the camera back to the player when the pilot exits the helicopter they are hanging from
addEventHandler("onPlayerVehicleExit",root,function(vehicle,seat)
	if getVehicleType(vehicle)=="Helicopter" and seat == 0 then
		for _,v in ipairs(getElementsByType("player")) do
			local player_hanging = getElementData(v,"hanging")
			if player_hanging and player_hanging.heli == vehicle then
				setCameraTarget(v,v)
			end
		end
	end
end)


-- set the camera on anyone hanging on the helicopter to the new pilot
addEventHandler("onPlayerVehicleEnter",root,function(vehicle,seat)
	if getVehicleType(vehicle)=="Helicopter" and seat == 0 then
		for _,v in ipairs(getElementsByType("player")) do
			local player_hanging = getElementData(v,"hanging")
			if player_hanging and player_hanging.heli == vehicle then
				setCameraTarget(v,source)
			end
		end
	end
end)


addEvent("RemoveHangingPedFromVehicle",true)
addEventHandler("RemoveHangingPedFromVehicle",root,function()
	setElementData(source, "realinvehicle", 0, false)
	removePedFromVehicle(source)
end)



addEventHandler("onResourceStop",getResourceRootElement(getThisResource()),function()
	for _,v in ipairs(getElementsByType("player")) do
		local player_hanging = getElementData(v,"hanging")
		if player_hanging then
			triggerEvent("PlayerDropFromHeli",v,player_hanging.heli,"stopped resource")
		end
	end	
end)


