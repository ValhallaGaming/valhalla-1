local objGatef = createObject(3089, 240.659375, 197.2541015625, 1008.171875, 0, 0, 270)
exports.pool:allocateElement(objGatef)
setElementInterior(objGatef, 3)
setElementDimension(objGatef, 1)


local objGatef2 = createObject(3089, 240.659375, 194.3541015625, 1008.171875, 0, 0, 90)
exports.pool:allocateElement(objGatef2)
setElementInterior(objGatef2, 3)
setElementDimension(objGatef2, 1)

-- side rafters
local object1 = createObject(3089, 240.659375, 197.23, 1008.171875, 0, 0, 90)
exports.pool:allocateElement(object1)
setElementInterior(object1, 3)
setElementDimension(object1, 1)

local object2 = createObject(3089, 240.659375, 194.37, 1008.171875, 0, 0, 270)
exports.pool:allocateElement(object2)
setElementInterior(object2, 3)
setElementDimension(object2, 1)

-- roof rafters
local object3 = createObject(2395, 240.59, 194.37, 1012.271875, 0, 180, 270)
exports.pool:allocateElement(object3)
setElementInterior(object3, 3)
setElementDimension(object3, 1)

local object4 = createObject(2395, 240.8, 197.37, 1012.271875, 0, 180, 90)
exports.pool:allocateElement(object4)
setElementInterior(object4, 3)
setElementDimension(object4, 1)

local open = false

-- Gate code
function usePDDoor6(thePlayer)
	local team = getPlayerTeam(thePlayer)
	
	if (team==getTeamFromName("Las Venturas Metropolitan Police Department")) then
		local x, y, z = getElementPosition(thePlayer)
		local distance = getDistanceBetweenPoints3D(240.459375, 197.2541015625, 1008.171875, x, y, z)

		if (distance<=5) and (open==false) then
			open = true
			outputChatBox("LVMPD Door is now Open!", thePlayer, 0, 255, 0)
			moveObject(objGatef, 1000, 240.659375, 197.2541015625, 1008.171875, 0, 0, 90)
			moveObject(objGatef2, 1000, 240.659375, 194.3541015625, 1008.171875, 0, 0, -90)
			setTimer(closePDDoor6, 5000, 1, thePlayer)
		end
	end
end
addCommandHandler("gate", usePDDoor6)

function closePDDoor6(thePlayer)
	if (getElementType(thePlayer)) then
		outputChatBox("LVMPD Door is now Closed!", thePlayer, 255, 0, 0)
	end
	
	setTimer(resetState6, 1000, 1)
	moveObject(objGatef, 1000, 240.659375, 197.2541015625, 1008.171875, 0, 0, -90)
	moveObject(objGatef2, 1000, 240.659375, 194.3541015625, 1008.171875, 0, 0, 90)
end

function resetState6()
	open = false
end