-- ////////////////////////////////////
-- //			MYSQL				 //
-- ////////////////////////////////////		
sqlUsername = exports.mysql:getMySQLUsername()
sqlPassword = exports.mysql:getMySQLPassword()
sqlDB = exports.mysql:getMySQLDBName()
sqlHost = exports.mysql:getMySQLHost()
sqlPort = exports.mysql:getMySQLPort()

handler = mysql_connect(sqlHost, sqlUsername, sqlPassword, sqlDB, sqlPort)

function checkMySQL()
	if not (mysql_ping(handler)) then
		handler = mysql_connect(sqlHost, sqlUsername, sqlPassword, sqlDB, sqlPort)
	end
end
setTimer(checkMySQL, 300000, 0)

function closeMySQL()
	if (handler~=nil) then
		mysql_close(handler)
	end
end
addEventHandler("onResourceStop", getResourceRootElement(getThisResource()), closeMySQL)
-- ////////////////////////////////////
-- //			MYSQL END			 //
-- ////////////////////////////////////

licenseColSphere = createColSphere(358.25839233398, 161.80035400391, 1008.3828125, 3)
exports.pool:allocateElement(licenseColSphere)
setElementInterior(licenseColSphere, 3)
setElementDimension(licenseColSphere, 125)

function hitLicenseColShape(thePlayer, matchingDimension)
	if (matchingDimension) then
		triggerClientEvent(thePlayer, "onLicense", thePlayer)
	end
end
addEventHandler("onColShapeHit", licenseColSphere, hitLicenseColShape)

function giveLicense(license, cost)
	if (license==1) then -- car drivers license
		setElementData(source, "license.car", 1)
		mysql_query(handler, "UPDATE characters SET car_license='1' WHERE charactername='" .. mysql_escape_string(handler, getPlayerName(source)) .. "' LIMIT 1")
		outputChatBox("You obtained your drivers license.", source, 255, 194, 14)
		exports.global:takePlayerSafeMoney(source, cost)
	elseif (license==2) then
		setElementData(source, "license.gun", 1)
		mysql_query(handler, "UPDATE characters SET gun_license='1' WHERE charactername='" .. mysql_escape_string(handler, getPlayerName(source)) .. "' LIMIT 1")
		outputChatBox("You obtained your weapons license.", source, 255, 194, 14)
		exports.global:takePlayerSafeMoney(source, cost)
	end
end
addEvent("acceptLicense", true)
addEventHandler("acceptLicense", getRootElement(), giveLicense)

function showLicenses(thePlayer, commandName, targetPlayer)
	local loggedin = getElementData(thePlayer, "loggedin")

	if (loggedin==1) then
		if not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer = exports.global:findPlayerByPartialNick(targetPlayer)
			
			if not (targetPlayer) then
				outputChatBox("Player not found.", thePlayer, 255, 0, 0)
			else
				local targetPlayerName = getPlayerName(targetPlayer)
				local logged = getElementData(targetPlayer, "loggedin")
				
				if (logged==0) then
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
				elseif (logged==1) then
					outputChatBox("You have shown your licenses to " .. targetPlayerName .. ".", thePlayer, 255, 194, 14)
					outputChatBox(getPlayerName(thePlayer) .. " has shown you their licenses.", targetPlayer, 255, 194, 14)
					
					local gunlicense = getElementData(thePlayer, "license.gun")
					local carlicense = getElementData(thePlayer, "license.car")
					
					local guns, cars
					
					if (gunlicense==0) then
						guns = "No"
					else
						guns = "Yes"
					end
					
					if (carlicense==0) then
						cars = "No"
					else
						cars = "Yes"
					end
					
					outputChatBox("~-~-~-~- " .. getPlayerName(thePlayer) .. "'s Licenses -~-~-~-~", targetPlayer, 255, 194, 14)
					outputChatBox("        Weapon License: " .. guns, targetPlayer, 255, 194, 14)
					outputChatBox("        Car License: " .. cars, targetPlayer, 255, 194, 14)
				end
			end
		end
	end
end
addCommandHandler("showlicenses", showLicenses, false, false)