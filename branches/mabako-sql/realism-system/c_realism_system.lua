copCars = {
[427] = true,
[490] = true,
[528] = true,
[523] = true,
[596] = true,
[597] = true,
[598] = true,
[599] = true,
[601] = true }

function onCopCarEnter(thePlayer, seat)
	if (seat < 2) and (thePlayer==getLocalPlayer()) then
		local model = getElementModel(source)
		if (copCars[model]) then
			setRadioChannel(0)
		end
	end
end
addEventHandler("onClientVehicleEnter", getRootElement(), onCopCarEnter)

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

----------------------------------------------------
------------------- STRIPPER PEDS ------------------
----------------------------------------------------

------/////////////////////// Pig Pen Strippers ///////////////////////------
local pigpenDancer1=createPed(152,1216.30,-6.45,1000.32)
setElementInterior(pigpenDancer1,2)
setElementDimension(pigpenDancer1,1197)
setPedAnimation(pigpenDancer1,"STRIP","STR_C1",-1,true,false,false)

local pigpenDancer2=createPed (257,1208.12,-6.05,1000.32)
setPedAnimation(pigpenDancer2,"STRIP","STR_C2",-1,true,false,false)
setElementInterior(pigpenDancer2,2)
setElementDimension(pigpenDancer2,1197)

------/////////////////////// East Beach Strippers ///////////////////////------
local eastBeachDancer1=createPed(152,1216.30,-6.45,1000.32)
setElementInterior(eastBeachDancer1,2)
setElementDimension(eastBeachDancer1,1301)
setPedAnimation(eastBeachDancer1,"STRIP","STR_C1",-1,true,false,false)

local eastBeachDancer2=createPed(257,1208.12,-6.05,1000.32)
setPedAnimation(eastBeachDancer2,"STRIP","STR_C2",-1,true,false,false)
setElementInterior(eastBeachDancer2,2)
setElementDimension(eastBeachDancer2,1301)

------/////////////////////// Ganton Strippers ///////////////////////------
local gantonDancer1=createPed(152,1215.7,-33,1000.32)
setElementInterior(gantonDancer1,3)
setElementDimension(gantonDancer1,1350)
setPedAnimation(gantonDancer1,"STRIP","STR_C1",-1,true,false,false)

local gantonDancer2=createPed(257,1209.12,-36,1000.32)
setPedAnimation(gantonDancer2,"STRIP","STR_C2",-1,true,false,false)
setElementInterior(gantonDancer2,3)
setElementDimension(gantonDancer2,1350)

------/////////////////////// bewbz night club ///////////////////////------
local bewbzNClub1=createPed(87,-2677.560546875, 1410.3486328125, 907.5703125)
setElementInterior(bewbzNClub1,3)
setElementDimension(bewbzNClub1,1355)
setPedAnimation(bewbzNClub1,"STRIP","STR_C1",-1,true,false,false)

local bewbzNClub2=createPed(87, -2670.599609375, 1410.4853515625, 907.5703125)
setElementInterior(bewbzNClub2,3)
setElementDimension(bewbzNClub2,1355)
setPedAnimation(bewbzNClub2,"STRIP","STR_C2",-1,true,false,false)

local DancerOneDanceNumber=1
local DancerTwoDanceNumber=1



-- Dancer 1 Cycle
function dancerOneLoop()
	if(DancerOneDanceNumber==1)then
		setPedAnimation(pigpenDancer1,"STRIP","STR_Loop_C",-1,true,false,false)
		setPedAnimation(eastBeachDancer1,"STRIP","STR_Loop_C",-1,true,false,false)
		setPedAnimation(gantonDancer1,"STRIP","STR_Loop_C",-1,true,false,false)
		setPedAnimation(bewbzNClub1,"STRIP","STR_Loop_C",-1,true,false,false)
		DancerOneDanceNumber=DancerOneDanceNumber+1
	elseif(DancerOneDanceNumber==2)then
		setPedAnimation(pigpenDancer1,"STRIP","strip_D",-1,true,false,false)
		setPedAnimation(eastBeachDancer1,"STRIP","strip_D",-1,true,false,false)
		setPedAnimation(gantonDancer1,"STRIP","strip_D",-1,true,false,false)
		setPedAnimation(bewbzNClub1,"STRIP","strip_D",-1,true,false,false)
		DancerOneDanceNumber=DancerOneDanceNumber+1
	elseif(DancerOneDanceNumber==3)then
		setPedAnimation(pigpenDancer1,"STRIP","STR_C1",-1,true,false,false)
		setPedAnimation(eastBeachDancer1,"STRIP","STR_C1",-1,true,false,false)
		setPedAnimation(gantonDancer1,"STRIP","STR_C1",-1,true,false,false)
		setPedAnimation(bewbzNClub1,"STRIP","STR_C1",-1,true,false,false)
		DancerOneDanceNumber=1
	end
end
local dancerOneTimer=setTimer(dancerOneLoop,15000,0)

-- Dancer 2 Cycle
function dancerTwoLoop()
	if (DancerTwoDanceNumber == 1) then
		setPedAnimation(pigpenDancer2,"STRIP","Strip_Loop_B",-1,true,false,false)
		setPedAnimation(eastBeachDancer2,"STRIP","Strip_Loop_B",-1,true,false,false)
		setPedAnimation(gantonDancer2,"STRIP","Strip_Loop_B",-1,true,false,false)
		setPedAnimation(bewbzNClub2,"STRIP","Strip_Loop_B",-1,true,false,false)
		DancerTwoDanceNumber=DancerTwoDanceNumber+1
	elseif(DancerTwoDanceNumber==2)then
		setPedAnimation(pigpenDancer2,"STRIP","STR_Loop_A",-1,true,false,false)
		setPedAnimation(eastBeachDancer2,"STRIP","STR_Loop_A",-1,true,false,false)
		setPedAnimation(gantonDancer2,"STRIP","STR_Loop_A",-1,true,false,false)
		setPedAnimation(bewbzNClub2,"STRIP","STR_Loop_A",-1,true,false,false)
		DancerTwoDanceNumber=DancerTwoDanceNumber+1
	elseif(DancerTwoDanceNumber==3)then
		setPedAnimation(pigpenDancer2,"STRIP","STR_C2",-1,true,false,false)
		setPedAnimation(eastBeachDancer2,"STRIP","STR_C2",-1,true,false,false)
		setPedAnimation(gantonDancer2,"STRIP","STR_C2",-1,true,false,false)
		setPedAnimation(bewbzNClub2,"STRIP","STR_C2",-1,true,false,false)
		DancerTwoDanceNumber=1
	end
end
local dancerTwoTimer=setTimer(dancerTwoLoop,12000,0)
