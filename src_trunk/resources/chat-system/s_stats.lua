function showStats(thePlayer)
	local carlicense = getElementData(thePlayer, "license.car")
	local gunlicense = getElementData(thePlayer, "license.gun")
	
	if (carlicense==1) then
		carlicense = "Yes"
	else
		carlicense = "No"
	end
	
	if (gunlicense==1) then
		gunlicense = "Yes"
	else
		gunlicense = "No"
	end

	local dbid = tonumber(getElementData(thePlayer, "dbid"))
	
	-- CAR IDS
	local carids = ""
	local numcars = 0
	for key, value in ipairs(exports.pool:getPoolElementsByType("vehicle")) do
		local owner = tonumber(getElementData(value, "owner"))

		if (owner) and (owner==dbid) then
			local id = getElementData(value, "dbid")
			carids = carids .. id .. ", "
			numcars = numcars + 1
		end
	end
	
	-- Properties
	local properties = ""
	local numproperties = 0
	for key, value in ipairs(exports.pool:getPoolElementsByType("pickup")) do
		local owner = tonumber(getElementData(value, "owner"))
		local inttype = tonumber(getElementData(value, "inttype"))
		local pickuptype = getElementData(value, "type")

		if (owner) and (owner==dbid and inttype~=2 and pickuptype=="interior") then
			local id = getElementData(value, "dbid")
			properties = properties .. id .. ", "
			numproperties = numproperties + 1
		end
	end
	
	if (properties=="") then properties = "None.  " end
	if (carids=="") then carids = "None.  " end
	
	local hoursplayed = getElementData(thePlayer, "hoursplayed")
	
	outputChatBox("~-~-~-~-~-~ " .. getPlayerName(thePlayer) .. " ~-~-~-~-~", thePlayer, 255, 194, 14)
	outputChatBox("Cell Number: " .. getElementData(thePlayer, "cellnumber"), thePlayer, 255, 194, 14)
	outputChatBox("Drivers License: " .. carlicense, thePlayer, 255, 194, 14)
	outputChatBox("Gun License: " .. gunlicense, thePlayer, 255, 194, 14)
	outputChatBox("Vehicles (" .. numcars .. "): " .. string.sub(carids, 1, string.len(carids)-2), thePlayer, 255, 194, 14)
	outputChatBox("Properties (" .. numproperties .. "): " .. string.sub(properties, 1, string.len(properties)-2), thePlayer, 255, 194, 14)
	outputChatBox("Time spent on this character: " .. hoursplayed .. " hours.", thePlayer, 255, 194, 14)
	outputChatBox("~-~-~-~-~-~-~-~-~-~-~-~-~-~-~~-~-~-~-~-~-~-~-~-~-~-~-~-~-~", thePlayer, 255, 194, 14)
end
addCommandHandler("stats", showStats, false, false)