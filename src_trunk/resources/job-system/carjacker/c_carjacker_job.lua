vehicles = {}
vehicles[1] = {518} -- Buccaneer
vehicles[2] = {439} -- Stallion
vehicles[3] = {492} -- Greenwood
vehicles[4] = {551} -- Merit
vehicles[5] = {560} -- Sultan
vehicles[6] = {579} -- Huntley
vehicles[7] = {517} -- Majestic
vehicles[8] = {565} -- Flash
vehicles[9] = {549} -- Tampa
vehicles[10] = {559} -- Jester

parts = {}
parts [1] = {"a transmission"}
parts [2] = {"a cooling system"}
parts [3] = {"front and rear dampers"}
parts [4] = {"a sports clutch"}
parts [5] = {"an induction kit"}

local marker = nil
local blip = nil

function createHunterMarkers()

	local modelID = math.random(1, 10) -- random vehicle ID from the list above.
	local vehicleID = vehicles[modelID][1]
	local vehicleName = getVehicleNameFromModel (vehicleID)
	setElementData(source, "missionModel", vehicleID, true) -- set the players element data to the car requested car model.
	local rand = math.random(1, 5) -- random car part from the list above.
	local carPart = parts[rand][1]
	
	-- selecting a random car model (and car part just for fun).
	outputChatBox("SMS From: Hunter - Hey, man. I need ".. carPart .." from a ".. vehicleName ..". Can you help me out?")
	outputChatBox("#FF9933((Steal a ".. vehicleName .." and deliver the car to Hunter's #FF66CCgarage#FF9933.))", 255, 104, 91, true )
	
	--blip = createBlip(1108.7441, 1903.98535, 9.52469, 0, 4, 255, 127, 255) -- No blip. The player should know where the garage is from when they met Hunter to get the job.
	marker = createMarker(1653.44, -1840.57, 12.24, "cylinder", 4, 255, 127, 255, 150)
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