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
		local theVehicle = getPedOccupiedVehicle(source)
		setElementData(source, "realinvehicle", 0, false)
		removePedFromVehicle(source)
		respawnVehicle(theVehicle)
		setElementData(source, "license.car", 1)
		local query = mysql_query(handler, "UPDATE characters SET car_license='1' WHERE charactername='" .. mysql_escape_string(handler, getPlayerName(source)) .. "' LIMIT 1")
		mysql_free_result(query)
		outputChatBox("Congratulations, you've passed the second part of your driving examination.", source, 255, 194, 14)
		outputChatBox("You are now fully licenses to drive on the public streets. You have paid the $350 processing fee.", source, 255, 194, 14)
		exports.global:takeMoney(source, cost)
	elseif (license==2) then
		setElementData(source, "license.gun", 1)
		local query = mysql_query(handler, "UPDATE characters SET gun_license='1' WHERE charactername='" .. mysql_escape_string(handler, getPlayerName(source)) .. "' LIMIT 1")
		mysql_free_result(query)
		outputChatBox("You obtained your weapons license.", source, 255, 194, 14)
		exports.global:takeMoney(source, cost)
	end
end
addEvent("acceptLicense", true)
addEventHandler("acceptLicense", getRootElement(), giveLicense)

function payFee(amount)
	exports.global:takeMoney(source, amount)
end
addEvent("payFee", true)
addEventHandler("payFee", getRootElement(), payFee)

function passTheory()
	setElementData(source,"license.car",3) -- Set data to "theory passed"
	local query = mysql_query(handler, "UPDATE characters SET car_license='3' WHERE charactername='" .. mysql_escape_string(handler, getPlayerName(source)) .. "' LIMIT 1")
	mysql_free_result(query)
end
addEvent("theoryComplete", true)
addEventHandler("theoryComplete", getRootElement(), passTheory)

function showLicenses(thePlayer, commandName, targetPlayer)
	local loggedin = getElementData(thePlayer, "loggedin")

	if (loggedin==1) then
		if not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer = exports.global:findPlayerByPartialNick(targetPlayer)
			
			if not (targetPlayer) then
				outputChatBox("Player not found or multiple were found.", thePlayer, 255, 0, 0)
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
					elseif (carlicense==3)then
						cars = "Theory test passed"
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


function checkDMVCars(player)
	-- aka civilian previons
	if getElementData(source, "owner") == -2 and getElementData(source, "faction") == -1 and getElementModel(source) == 436 and getElementData(player,"license.car") ~= 3 then
		outputChatBox("This DMV Car is for the Driving Test only.", player, 255, 0, 0)
		cancelEvent()
	end
end
addEventHandler( "onVehicleStartEnter", getRootElement(), checkDMVCars)