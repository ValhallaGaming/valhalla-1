local pool = { }

function allocateVehicle(element)
	if (element) then
		for i = 1, #pool+1 do
			if (pool[i]==nil) then
				pool[i] = element
				setElementData(element, "poolid", i)
			end
		end
	end
end

function deallocateVehicle()
	if (getElementType(source)=="vehicle") then
		local id = getElementData(source, "poolid")
		pool[id] = nil
	end
end
addEventHandler("onElementDestroy", getRootElement(), deallocateVehicle)

function getAllVehicles()
	return pool
end

function getVehicleFromID(id)
	if (pool[id]~=nil) then
		return pool[id]
	else
		return false
	end
end

function showall()
	outputDebugString("VEHICLES: " .. #pool)
end
addCommandHandler("showall", showall)

function getall()
	local players = #exports.pool:getAllPlayers()
	local vehicles = #exports.pool:getAllVehicles()
	local blips = #exports.pool:getAllBlips()
	local teams = #exports.pool:getAllTeams()
	local colshapes = #exports.pool:getAllColshapes() + #exports.pool:getAllColshapes()
	local objects = #exports.pool:getAllObjects()
	local pickups = #exports.pool:getAllPickups()
	local markers = #exports.pool:getAllMarkers()
	local peds = #exports.pool:getAllPeds()
	--local total = players + vehicles + blips + teams + colshapes + objects + pickups + markers + peds
	--outputDebugString("TOTAL: " .. total)
	
	outputDebugString("Vehicles: " .. vehicles)
	outputDebugString("Players: " .. players)
	outputDebugString("Markers: " .. markers)
	outputDebugString("Pickups: " .. pickups)
	outputDebugString("Objects: " .. objects)
	outputDebugString("Blips: " .. blips)
	outputDebugString("Colshapes: " .. colshapes)
	outputDebugString("Teams: " .. teams)
	outputDebugString("Peds: " .. peds)
	
end
addCommandHandler("getall", getall)