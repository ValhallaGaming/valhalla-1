local cooldown = false

function checkSpeedHacks()
	local vehicle = getPedOccupiedVehicle(getLocalPlayer())
	
	if (vehicle) and not (cooldown) then
		local speedx, speedy, speedz = getElementVelocity(vehicle)
		local actualspeed = math.ceil(((speedx^2 + speedy^2 + speedz^2)^(0.5)*100))
		if (actualspeed>150) then
			cooldown = true
			setTimer(resetCD, 5000, 1)
			triggerServerEvent("alertAdminsOfSpeedHacks", getLocalPlayer(), actualspeed)
		end
	end
end
addEventHandler("onClientRender", getRootElement(), checkSpeedHacks)

function resetCD()
	cooldown = false
end

local timer = false
local kills = 0
function checkDM(killer)
	if (killer==getLocalPlayer()) then
		kills = kills + 1
		
		if (kills>=3) then
			triggerServerEvent("alertAdminsOfDM", getLocalPlayer(), kills)
		end
		
		if not (timer) then
			timer = true
			setTimer(resetDMCD, 120000, 1)
		end
	end
end
addEventHandler("onClientPlayerWasted", getRootElement(), checkDM)

function resetDMCD()
	kills = 0
	timer = false
end