function showStats(thePlayer, commandName, targetPlayerName)
	local showPlayer = thePlayer
	if exports.global:isPlayerAdmin(thePlayer) and targetPlayerName then
		targetPlayer = exports.global:findPlayerByPartialNick(targetPlayerName)
		if targetPlayer then
			if getElementData(targetPlayer, "loggedin") == 1 then
				thePlayer = targetPlayer
			else
				outputChatBox("Player is not logged in.", showPlayer, 255, 0, 0)
				return
			end
		else
			outputChatBox("Player not found", showPlayer, 255, 0, 0)
			return
		end
	end
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
	for key, value in ipairs(getElementsByType("pickup", getResourceRootElement(getResourceFromName("interior-system")))) do
		local owner = tonumber(getElementData(value, "owner"))
		if owner and owner == dbid and getElementData(value, "name") then
			local id = getElementData(value, "dbid")
			properties = properties .. id .. ", "
			numproperties = numproperties + 1
		end
	end
	
	if (properties=="") then properties = "None.  " end
	if (carids=="") then carids = "None.  " end
	
	local hoursplayed = getElementData(thePlayer, "hoursplayed")
	
	local languages = {}
	for i = 1, 3 do
		local lang = getElementData(thePlayer, "languages.lang" .. i)
		if lang and lang ~= 0 then
			local skill = getElementData(thePlayer, "languages.lang" .. i .. "skill")
			local langname = exports['language-system']:getLanguageName( lang )
			if langname then
				languages[i] = langname .. " (" .. skill .. "%)"
			else
				languages[i] = "-"
			end
		else
			languages[i] = "-"
		end
	end
	
	outputChatBox("~-~-~-~-~-~ " .. getPlayerName(thePlayer) .. " ~-~-~-~-~", showPlayer, 255, 194, 14)
	outputChatBox("Cell Number: " .. getElementData(thePlayer, "cellnumber"), showPlayer, 255, 194, 14)
	outputChatBox("Drivers License: " .. carlicense, showPlayer, 255, 194, 14)
	outputChatBox("Gun License: " .. gunlicense, showPlayer, 255, 194, 14)
	outputChatBox("Vehicles (" .. numcars .. "): " .. string.sub(carids, 1, string.len(carids)-2), showPlayer, 255, 194, 14)
	outputChatBox("Properties (" .. numproperties .. "): " .. string.sub(properties, 1, string.len(properties)-2), showPlayer, 255, 194, 14)
	outputChatBox("Time spent on this character: " .. hoursplayed .. " hours.", showPlayer, 255, 194, 14)
	outputChatBox("Languages: " .. table.concat(languages, ", "), showPlayer, 255, 194, 14)
	outputChatBox("~-~-~-~-~-~-~-~-~-~-~-~-~-~-~~-~", showPlayer, 255, 194, 14)
end
addCommandHandler("stats", showStats, false, false)

function showMoney( thePlayer )
	outputChatBox( "Your current money: $" .. exports.global:getMoney( thePlayer ), thePlayer )
end
addCommandHandler("money", showMoney, false, false)