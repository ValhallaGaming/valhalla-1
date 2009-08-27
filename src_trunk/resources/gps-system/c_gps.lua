local localPlayer = getLocalPlayer()
local iMap = nil

function displayGPS()
	if (iMap) then
		hideGUI()
	else
		showGUI()
	end
end
addEvent("displayGPS", true)
addEventHandler("displayGPS", getRootElement(), displayGPS)

function hideGUI()
	showCursor(false)
	
	destroyElement(iMap)
	iMap = nil
	
	call(getResourceFromName("realism-system"), "showSpeedo")
end

function showGUI()
	local width, height = 700, 700
	local scrWidth, scrHeight = guiGetScreenSize()
	local x = scrWidth/2 - (width/2)
	local y = scrHeight/2 - (height/2)

	iMap = guiCreateStaticImage(x, y, width, height, "map.jpg", false) -- Map
	
	call(getResourceFromName("realism-system"), "hideSpeedo")
	
	addEventHandler("onClientGUIClick", iMap, calculateRouteOnClick, false)
	showCursor(true)
end

function calculateRouteOnClick(button, state, absx, absy)
	tx, ty, tz = convert2DMapCoordToWorld(absx, absy)
	
	local x, y, z = getElementPosition(getLocalPlayer())
	local route = calculatePathByCoords(tx, ty, tz, x, y, z)
	
	if (route) then
		triggerEvent("drawGPS", getLocalPlayer(), route, tx, ty, tz)
	end
	
	hideGUI()
end

function updateRoute()
	local x, y, z = getElementPosition(getLocalPlayer())

	if (tx) and (ty) and (tz) then
		local node = findNodeClosestToPoint(vehicleNodes, x, y, z)
		if (node~=startnode) then
			local route = calculatePathByCoords(tx, ty, tz, x, y, z)
			
			if (route) then
				triggerEvent("drawGPS", getLocalPlayer(), route)
			end
		end
	end
end
--setTimer(updateRoute, 1000, 0)

function convert2DMapCoordToWorld(relX, relY)
	local scrWidth, scrHeight = guiGetScreenSize()
	local relX, relY, wx, wy, wz = getCursorPosition()

	local ax, ay = guiGetPosition( iMap, true )
	local bx, by = guiGetSize( iMap, true )
	local cx, cy = getCursorPosition()
	cxr = ( cx - ax ) / bx
	cyr = ( cy - ay ) / by
	
	local x = cxr*6000 - 3000
	local y = 3000 - cyr*6000
	
	local z = getGroundPosition(x, y, 1500)
	return x, y, z
end