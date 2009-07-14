vehicles = {}
vehicles [1] = {602}
vehicles [2] = {496}	
vehicles [3] = {517}
vehicles [4] = {401}	
vehicles [5] = {410}
vehicles [6] = {518}	
vehicles [7] = {600}
vehicles [8] = {527}	
vehicles [9] = {436}
vehicles [10] = {589}	
vehicles [11] = {419}	
vehicles [12] = {549}
vehicles [13] = {526}	
vehicles [14] = {445}	 
vehicles [15] = {507}	
vehicles [16] = {585}
vehicles [17] = {587}	
vehicles [18] = {409}
vehicles [19] = {466}	
vehicles [20] = {550}
vehicles [21] = {492}	
vehicles [22] = {566}
vehicles [23] = {540}
vehicles [24] = {551}	
vehicles [25] = {421}
vehicles [26] = {529}
vehicles [27] = {536}
vehicles [28] = {534}
vehicles [29] = {567}
vehicles [30] = {535}
vehicles [31] = {576}
vehicles [32] = {412}
vehicles [33] = {402}
vehicles [34] = {475}
vehicles [35] = {429}	
vehicles [36] = {411}
vehicles [37] = {541}	
vehicles [38] = {559}
vehicles [39] = {560}
vehicles [40] = {562}	
vehicles [41] = {506}
vehicles [42] = {565}	
vehicles [43] = {451}
vehicles [44] = {558}
vehicles [45] = {477}
vehicles [46] = {579}
vehicles [47] = {400}

parts = {}
parts [1] = {"a transmission"}
parts [2] = {"a cooling system"}
parts [3] = {"front and rear dampers"}
parts [4] = {"a sports clutch"}
parts [5] = {"an induction kit"}

local marker = nil
local blip = nil

function createHunterMarkers()

	local modelID = math.random(1, 47) -- random vehicle ID from the list above.
	local vehicleID = vehicles[modelID][1]
	local vehicleName = getVehicleNameFromModel (vehicleID)
	setElementData(source, "missionModel", vehicleID) -- set the players element data to the car requested car model.
	local rand = math.random(1, 5) -- random car part from the list above.
	local carPart = parts[rand][1]
	
	-- selecting a random car model (and car part just for fun).
	outputChatBox("SMS From: Hunter - Hey, man. I need ".. carPart .." from a ".. vehicleName ..". Can you help me out?")
	outputChatBox("#FF9933((Steal a ".. vehicleName .." and deliver the car to Hunter's #FF66CCgarage#FF9933.))", 255, 104, 91, true )
	
	--blip = createBlip(1108.7441, 1903.98535, 9.52469, 0, 4, 255, 127, 255) -- No blip. The player should know where the garage is from when they met Hunter to get the job.
	marker = createMarker(1108.7441, 1903.98535, 9.52469, "cylinder", 4, 255, 127, 255, 150)
	addEventHandler("onClientMarkerHit", marker, dropOffCar, false)
end
addEvent("createHunterMarkers", true)
addEventHandler("createHunterMarkers", getRootElement(), createHunterMarkers)

function dropOffCar(player, dimension)
	if (dimension) and (player==getLocalPlayer()) then
		triggerServerEvent("dropOffCar", getLocalPlayer())
	end
end

function jackerCleanup()
	--if (isElement(blip)) then destroyElement(blip) end
	if (isElement(marker)) then destroyElement(marker) end
end
addEvent("jackerCleanup", true)
addEventHandler("jackerCleanup", getRootElement(), jackerCleanup)