-- Bind Keys required
addEventHandler("onResourceStart", getResourceRootElement(),
	function ()
		for _, player in ipairs(getElementsByType("player")) do
			if not isKeyBound(player, "p", "down", toggleFlashers) then
				bindKey(player, "p", "down", toggleFlashers)
			end
		end
	end
)

addEventHandler("onPlayerJoin", getRootElement(),
	function ()
		bindKey(source, "p", "down", toggleFlashers)
	end
)

local governmentVehicle = { [416]=true, [427]=true, [490]=true, [528]=true, [407]=true, [544]=true, [523]=true, [596]=true, [597]=true, [598]=true, [599]=true, [601]=true, [428]=true }

local flasherVehicles = { }
local flashTimer

function toggleFlashers(player)
	local veh = getPedOccupiedVehicle(player)
	
	if (veh) then
		if (governmentVehicle[getElementModel(veh)]) or exports.global:doesVehicleHaveItem(veh, 61) then -- governmentVehicle or Emergency Light Becon
			local lights = getVehicleOverrideLights(veh)
			
			if (lights==2) then
				if flasherVehicles[veh] then
					setVehicleLightState(veh, 0, 0)
					setVehicleLightState(veh, 1, 0)
					setVehicleHeadLightColor(veh, 255, 255, 255)
					flasherVehicles[veh] = nil
					if table.size(flasherVehicles) == 0 then
						if isTimer(flashTimer) then
							killTimer(flashTimer)
							flashTimer = nil
						end
					end
				else
					setVehicleHeadLightColor(veh, 255, 0, 0)
					setVehicleLightState(veh, 0, 1)
					setVehicleLightState(veh, 1, 0)
					flasherVehicles[veh] = true
					if not flashTimer then 
						flashTimer = setTimer(doFlashes, 250, 0)
					end
				end
			end
		end
	end
end

function doFlashes()
	for veh, state in pairs(flasherVehicles) do
		local state1 = getVehicleLightState(veh, 0)
		local state2 = getVehicleLightState(veh, 1)
		
		if (state1 == 0) then
			setVehicleHeadLightColor(veh, 0, 0, 255)
		else
			setVehicleHeadLightColor(veh, 255, 0, 0)
		end
		
		setVehicleLightState(veh, 0, state2)
		setVehicleLightState(veh, 1, state1)
	end
end

function table.size(tab)
    local length = 0
    if tab then
        for _ in pairs(tab) do
            length = length + 1
        end
    end
    return length
end