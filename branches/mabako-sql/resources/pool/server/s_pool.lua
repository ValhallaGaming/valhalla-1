poolTable = {
    ["player"] = {},
    ["vehicle"] = {},
    ["colshape"] = {},
    ["ped"] = {},
    ["marker"] = {},
    ["object"] = {},
    ["pickup"] = {},
    ["team"] = {},
    ["blip"] = {}
}

function isValidType(elementType)
    for k, v in pairs(poolTable) do
        if k == elementType then
            return true
        end
    end
    return false
end

function showsize(thePlayer)
	local players = #poolTable["player"]
	local vehicles = #poolTable["vehicle"]
	local colshapes = #poolTable["colshape"]
	local peds = #poolTable["ped"]
	local markers = #poolTable["marker"]
	local objects = #poolTable["object"]
	local pickups = #poolTable["pickup"]
	local teams = #poolTable["team"]
	local blips = #poolTable["blip"]
	
	local tplayers = #getElementsByType("player")
	local tvehicles = #getElementsByType("vehicle")
	local tcolshapes = #getElementsByType("colshape")
	local tpeds = #getElementsByType("ped")
	local tmarkers = #getElementsByType("marker")
	local tobjects = #getElementsByType("object")
	local tpickups = #getElementsByType("pickup")
	local tteams = #getElementsByType("team")
	local tblips = #getElementsByType("blip")
	
	
	outputChatBox("PLAYERS: " .. tostring(players) .. ":" .. tostring(tplayers), thePlayer)
	outputChatBox("VEHICLES: " .. tostring(vehicles) .. ":" .. tostring(tvehicles), thePlayer)
	outputChatBox("COLSHAPES: " .. tostring(colshapes) .. ":" .. tostring(tcolshapes), thePlayer)
	outputChatBox("PEDS: " .. tostring(peds) .. ":" .. tostring(tpeds), thePlayer)
	outputChatBox("MARKERS: " .. tostring(markers) .. ":" .. tostring(tmarkers), thePlayer)
	outputChatBox("OBJECTS: " .. tostring(objects) .. ":" .. tostring(tobjects), thePlayer)
	outputChatBox("PICKUPS: " .. tostring(pickups) .. ":" .. tostring(tpickups), thePlayer)
	outputChatBox("TEAMS: " .. tostring(teams) .. ":" .. tostring(tteams), thePlayer)
	outputChatBox("BLIPS: " .. tostring(blips) .. ":" .. tostring(tblips), thePlayer)
	
end
addCommandHandler("size", showsize)

function deallocateElement(element)
    local elementType = getElementType(element)
    if (isValidType(elementType)) then
        local elementPool = poolTable[elementType]
        for k, v in ipairs(elementPool) do
            if v == element then
                table.remove(elementPool, k)
            end
        end
    end
end

function allocateElement(element)
    local elementType = getElementType(element)
    if (isValidType(elementType)) then
        table.insert (poolTable[elementType], element)
    end
end

function getPoolElementsByType(elementType)
	if (elementType=="pickup") then
		return getElementsByType("pickup")
	end

    if isValidType(elementType) then
        return poolTable[elementType]
    end
    return false
end

function updatePoolOnResourceStart(resource)
    if resource == getThisResource() then
        for k, element in ipairs(getElementChildren(getRootElement())) do
            allocateElement(element)
        end
    else
        for k, element in ipairs( getElementChildren(source)) do
            allocateElement(element)
        end
    end
end

addEventHandler("onResourceStart", getRootElement(), updatePoolOnResourceStart)

addEventHandler("onPlayerJoin", getRootElement(),
    function ()
        allocateElement(source)
    end
)

addEventHandler("onPlayerQuit", getRootElement(),
    function ()
        deallocateElement(source)
    end
)

addEventHandler("onElementDestroy", getRootElement(),
    function ()
        deallocateElement(source)
    end
)