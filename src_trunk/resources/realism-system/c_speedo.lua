fuellessVehicle = { [594]=true, [537]=true, [538]=true, [569]=true, [590]=true, [606]=true, [607]=true, [610]=true, [590]=true, [569]=true, [611]=true, [584]=true, [608]=true, [435]=true, [450]=true, [591]=true, [472]=true, [473]=true, [493]=true, [595]=true, [484]=true, [430]=true, [453]=true, [452]=true, [446]=true, [454]=true, [497]=true, [592]=true, [577]=true, [511]=true, [548]=true, [512]=true, [593]=true, [425]=true, [520]=true, [417]=true, [487]=true, [553]=true, [488]=true, [563]=true, [476]=true, [447]=true, [519]=true, [460]=true, [469]=true, [513]=true, [509]=true, [510]=true, [481]=true }

enginelessVehicle = { [510]=true, [509]=true, [481]=true }
local active = true

function drawSpeedo()
	if active and not isPlayerMapVisible() then
		local vehicle = getPedOccupiedVehicle(getLocalPlayer())
		if (vehicle) then
			speedx, speedy, speedz = getElementVelocity(vehicle)
			speed = ((speedx^2 + speedy^2 + speedz^2)^(0.5)*100)
			local width, height = guiGetScreenSize()
			local x = width
			local y = height
			
			dxDrawImage(x-210, y-275, 200, 200, "disc.png", 0, 0, 0, tocolor(255, 255, 255, 200), false)
			--outputChatBox(tostring(speed))
			speed = speed - 100
			nx = x + math.sin(math.rad(-(speed)-150)) * 90
			ny = y + math.cos(math.rad(-(speed)-150)) * 90
			dxDrawLine(x-110, y-175, nx-110, ny-175, tocolor(255, 0, 0, 255), 2, true)
		end
	end
end

function drawFuel()
	if active and not isPlayerMapVisible() then
		local vehicle = getPedOccupiedVehicle(getLocalPlayer())
		if (vehicle) then
			local fuel = getElementData(vehicle, "fuel")	
			
			local width, height = guiGetScreenSize()
			local x = width
			local y = height
				
			dxDrawImage(x-265, y-165, 100, 100, "fueldisc.png", 0, 0, 0, tocolor(255, 255, 255, 200), false)	
			movingx = x + math.sin(math.rad(-(fuel)-50)) * 50
			movingy = y + math.cos(math.rad(-(fuel)-50)) * 50
			dxDrawLine(x-215, y-115, movingx-210, movingy-115, tocolor(255, 0, 0, 255), 2, true)
		end
	end
end

-- Check if the vehicle is engineless or fuelless when a player enters. If not, draw the speedo and fuel needles.
function onVehicleEnter(thePlayer, seat)
	if (thePlayer==getLocalPlayer()) then
		if (seat<2) then
			local id = getElementModel(source)
			if not (fuellessVehicle[id]) then
				addEventHandler("onClientRender", getRootElement(), drawFuel)
			end
			if not (enginelessVehicle[id]) then
				addEventHandler("onClientRender", getRootElement(), drawSpeedo)
			end
		end		
	end
end
addEventHandler("onClientVehicleEnter", getRootElement(), onVehicleEnter)

-- Check if the vehicle is engineless or fuelless when a player exits. If not, stop drawing the speedo and fuel needles.
function onVehicleExit(thePlayer, seat)
	if (thePlayer==getLocalPlayer()) then
		if (seat<2) then
			local id = getElementModel(source)
			if not (fuellessVehicle[id]) then
				removeEventHandler("onClientRender", getRootElement(), drawFuel)
			end
			if not(enginelessVehicle[id]) then
				removeEventHandler("onClientRender", getRootElement(), drawSpeedo)
			end
		end
	end
end
addEventHandler("onClientVehicleStartExit", getRootElement(), onVehicleExit)

function hideSpeedo()
	removeEventHandler("onClientRender", getRootElement(), drawSpeedo)
	removeEventHandler("onClientRender", getRootElement(), drawFuel)
end

function showSpeedo()
	local source = getPedOccupiedVehicle(getLocalPlayer())
	if source then
		if getVehicleOccupant( source ) == getLocalPlayer() then
			onVehicleEnter(getLocalPlayer(), 0)
		elseif getVehicleOccupant( source, 1 ) == getLocalPlayer() then
			onVehicleEnter(getLocalPlayer(), 1)
		end
	end
end

-- If player is not in vehicle stop drawing the speedo needle.
function removeSpeedo()
	if not (isPedInVehicle(getLocalPlayer())) then
		hideSpeedo()
	end
end
setTimer(removeSpeedo, 1000, 0)

addCommandHandler( "togglespeedo",
	function( )
		local source = getPedOccupiedVehicle(getLocalPlayer())
		if source then
			active = not active
			if active then
				outputChatBox( "Speedo is now on.", 0, 255, 0 )
			else
				outputChatBox( "Speedo is now off.", 255, 0, 0 )
			end
		end
	end
)

addEventHandler( "onClientResourceStart", getResourceRootElement(), showSpeedo )