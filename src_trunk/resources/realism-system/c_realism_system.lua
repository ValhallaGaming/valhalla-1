function realisticWeaponSounds(weapon)
	local x, y, z = getElementPosition(getLocalPlayer())
	local tX, tY, tZ = getElementPosition(source)
	local distance = getDistanceBetweenPoints3D(x, y, z, tX, tY, tZ)
	
	if (distance<25) and (weapon>=22 and weapon<=34) then
		local randSound = math.random(27, 30)
		playSoundFrontEnd(randSound)
	end
end
addEventHandler("onClientPlayerWeaponFire", getRootElement(), realisticWeaponSounds)

------/////////////////////// Vice strippers ///////////////////////------
-- Stripper Isla View
local islaView = createPed (152, 1216.30, -6.45, 1000.32)
setElementInterior (islaView, 2)
setElementDimension (islaView, 294)
setPedAnimation ( islaView, "STRIP", "STR_C1", -1, true, false, false)
local islaDanceNumber = 1

-- Isla Dance Cycle
function islaDance()
	if (islaDanceNumber == 1) then
		setPedAnimation ( islaView, "STRIP", "STR_Loop_C", -1, true, false, false)
		islaDanceNumber = islaDanceNumber + 1
	elseif (islaDanceNumber == 2) then
		setPedAnimation ( islaView, "STRIP", "strip_D", -1, true, false, false)
		islaDanceNumber = islaDanceNumber + 1
	elseif (islaDanceNumber == 3) then
		setPedAnimation ( islaView, "STRIP", "STR_C1", -1, true, false, false)
		islaDanceNumber = islaDanceNumber - 2 -- reset to 1
	end
end
islaTimer = setTimer ( islaDance, 15000, 0)

-- Stripper Angel Rain	
local angelRain = createPed (257, 1208.12, -6.05, 1000.32)
setPedAnimation ( angelRain, "STRIP", "STR_C2", -1, true, false, false)
setElementInterior (angelRain, 2)
setElementDimension (angelRain, 294)
local angelDanceNumber = 1

-- Angel Dance Cycle
function angelDance()
	if (angelDanceNumber == 1) then
		setPedAnimation ( angelRain, "STRIP", "Strip_Loop_B", -1, true, false, false)
		angelDanceNumber = angelDanceNumber + 1
	elseif (angelDanceNumber == 2) then
		setPedAnimation ( angelRain, "STRIP", "STR_Loop_A", -1, true, false, false)
		angelDanceNumber = angelDanceNumber + 1
	elseif (angelDanceNumber == 3) then
		setPedAnimation ( angelRain, "STRIP", "STR_C2", -1, true, false, false)
		angelDanceNumber = angelDanceNumber - 1 -- reset to 1
	end
end
angelTimer = setTimer ( angelDance, 12000, 0)

------/////////////////////// Dragon Lady strippers ///////////////////////------
-- Stripper 1
local DrgStrip1 = createPed (140, 1216.30, -6.45, 1000.32)
setElementInterior (DrgStrip1, 2)
setElementDimension (DrgStrip1, 685)
setPedAnimation ( DrgStrip1, "STRIP", "STR_C1", -1, true, false, false)
local DrgStrip1DanceNumber = 1

-- Stripper 1 Cycle
function DrgStrip1Dance()
	if (DrgStrip1DanceNumber == 1) then
		setPedAnimation ( DrgStrip1, "STRIP", "STR_C1", -1, true, false, false)
		DrgStrip1DanceNumber = DrgStrip1DanceNumber + 1
	elseif (DrgStrip1DanceNumber == 2) then
		setPedAnimation ( DrgStrip1, "STRIP", "strip_D", -1, true, false, false)
		DrgStrip1DanceNumber = DrgStrip1DanceNumber + 1
	elseif (DrgStrip1DanceNumber == 3) then
		setPedAnimation ( DrgStrip1, "STRIP", "strip_G", -1, true, false, false)
		DrgStrip1DanceNumber = DrgStrip1DanceNumber - 2 -- reset to 1
	end
end
DrgStrip1Timer = setTimer ( DrgStrip1Dance, 15000, 0)

-- Stripper 2	
local DrgStrip2 = createPed (63, 1208.12, -6.05, 1000.32)
setPedAnimation ( DrgStrip2, "STRIP", "STR_Loop_A", -1, true, false, false)
setElementInterior (DrgStrip2, 2)
setElementDimension (DrgStrip2, 685)
local DrgStrip2DanceNumber = 1

-- Stripper 2 Cycle
function DrgStrip2Dance()
	if (DrgStrip2DanceNumber == 1) then
		setPedAnimation ( DrgStrip2, "STRIP", "Strip_Loop_B", -1, true, false, false)
		DrgStrip2DanceNumber = DrgStrip2DanceNumber + 1
	elseif (DrgStrip2DanceNumber == 2) then
		setPedAnimation ( DrgStrip2, "STRIP", "STR_Loop_A", -1, true, false, false)
		DrgStrip2DanceNumber = DrgStrip2DanceNumber + 1
	elseif (DrgStrip2DanceNumber == 3) then
		setPedAnimation ( DrgStrip2, "STRIP", "STR_C2", -1, true, false, false)
		DrgStrip2DanceNumber = DrgStrip2DanceNumber - 1 -- reset to 1
	end
end
DrgStrip2Timer = setTimer ( DrgStrip2Dance, 12000, 0)