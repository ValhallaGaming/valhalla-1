local Gate = createObject(1967, 371.269, 166.618, 1008.52, 0, 0, 89.95)
setElementInterior(Gate, 3)
setElementDimension(Gate, 9126)
local GateName = "Yakuza Gate 2"
exports.pool:allocateElement(Gate)
local GatePass = "DSDCKRF"
local open = false


local function ResetOpenState()
	open = false
end

local function closeDoor(thePlayer)
	if (getElementType(thePlayer)) then
		outputChatBox("The " .. GateName .. " is now Closed!", thePlayer, 255, 0, 0)
	end
	moveObject(Gate, 1000, 371.269, 166.618, 1008.52)
	setTimer(ResetOpenState, 1000, 1)
end


-- Gate code / Using local functions to avoid 
local function useDoor(thePlayer, commandName, ...)
	local password = table.concat({...})
	local x, y, z = getElementPosition(thePlayer)
	local distance = getDistanceBetweenPoints3D(371.269, 166.620, 1008.52, x, y, z)

	if distance <= 10 and open == false and getElementInterior(Gate) == getElementInterior(thePlayer) and getElementDimension(Gate) == getElementDimension(thePlayer) then
		if (password == GatePass) then
			outputChatBox("The " .. GateName .. " is now open!", thePlayer, 0, 255, 0)
			moveObject(Gate, 1000, 372.800, 166.607, 1008.52)
			setTimer(closeDoor, 5000, 1, thePlayer)
		else
			outputChatBox("Invalid Password", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("gate", useDoor)
