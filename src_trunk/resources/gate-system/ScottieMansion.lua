local Gate = {
	[1] = createObject(971, 284.39593505859, -1318.8131103516, 56.391410827637, 0, 358.75, 34.380004882813),
	[2] = createObject(971, 281.03247070313, -1321.0693359375, 56.31640625, 0, 358.74755859375, 34.376220703125),
}
local GateName = "McReary Gate"
exports.pool:allocateElement(Gate[1])
exports.pool:allocateElement(Gate[2])
local GatePass = "nonoobs"
local open = false


local function ResetOpenState()
	open = false
end

local function closeDoor(thePlayer)
	if (getElementType(thePlayer)) then
		outputChatBox("The " .. GateName .. " is now Closed!", thePlayer, 255, 0, 0)
	end
	moveObject(Gate[1], 1000, 284.39593505859, -1318.8131103516, 56.391410827637, 0, 0, 0)
	moveObject(Gate[2], 1000, 281.03247070313, -1321.0693359375, 56.31640625, 0, 0, 0)
	setTimer(ResetOpenState, 1000, 1)
end


-- Gate code / Using local functions to avoid 
local function useDoor(thePlayer, commandName, ...)
	local password = table.concat({...})
	local x, y, z = getElementPosition(thePlayer)
	local distance = getDistanceBetweenPoints3D(282.205078125, -1319.75390625, 53.851680755615, x, y, z)

	if (distance<=10) and (open==false) then
		if (password == GatePass) then
			outputChatBox("The " .. GateName .. " is now open!", thePlayer, 0, 255, 0)
			moveObject(Gate[1], 1000, 292.42388916016, -1313.7192382813, 56.391410827637, 0, 0, 0)
			moveObject(Gate[2], 1000, 272.58129882813, -1326.4306640625, 56.31640625, 0, 0, 0)
			setTimer(closeDoor, 5000, 1, thePlayer)
		else
			outputChatBox("Invalid Password", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("gate", useDoor)