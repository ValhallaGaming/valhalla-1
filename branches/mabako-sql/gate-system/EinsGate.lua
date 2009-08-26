local Gate = createObject(971, 264.52899780273, -1334.2608642578, 55.889999389648, 0, 0, 215.40502929688)
local GateName = "Private Property Gate"
exports.pool:allocateElement(Gate)
local GatePass = "ohayena123"
local open = false


local function ResetOpenState()
	open = false
end

local function closeDoor(thePlayer)
	if (getElementType(thePlayer)) then
		outputChatBox("The " .. GateName .. " is now Closed!", thePlayer, 255, 0, 0)
	end
	moveObject(Gate, 1000, 264.52899780273, -1334.2608642578, 55.889999389648, 0, 0, 0)
	setTimer(ResetOpenState, 1000, 1)
end


-- Gate code / Using local functions to avoid 
local function useDoor(thePlayer, commandName, ...)
	local password = table.concat({...})
	local x, y, z = getElementPosition(thePlayer)
	local distance = getDistanceBetweenPoints3D(263.4873046875, -1332.388671875, 53.242164611816, x, y, z)

	if (distance<=10) and (open==false) then
		if (password == GatePass) then
			outputChatBox("The " .. GateName .. " is now open!", thePlayer, 0, 255, 0)
			moveObject(Gate, 1000, 257.61117553711, -1339.328125, 55.889999389648, 0, 0, 0)
			setTimer(closeDoor, 5000, 1, thePlayer)
		else
			outputChatBox("Invalid Password", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("gate", useDoor)
