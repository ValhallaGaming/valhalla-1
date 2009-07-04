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
		outputChatBox("Congratulations, you've passed the second part of your driving examination.", thePlayer, 255, 194, 14)
		outputChatBox("You are now fully licenses to drive on the public streets. You have paid the $350 processing fee.", thePlayer, 255, 194, 14)
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

-------------------------------------------------------
--	Script written by Morelli adapted by Chamberlain
--	Given copy to vg.MTA on 12th December 2008
--
--
-- THIS COPY WAS INTENDED FOR vG.MTA
-- GAMING ONLY. FULL RIGHTS TO SCRIPT
-- ARE HELD BY Morelli (Cris G.)
-------------------------------------------------------

function Checkpoints( x_point, y_point, z_point )
	return { x_point=x_point, y_point=y_point, z_point=z_point }
end


--------- LIST OF CHECKPOINTS (x,y,z)
testRoute = {
Checkpoints(2514.2597, 1191.9062, 10.477),		-- 1
Checkpoints(2530.0156, 1284.8164, 10.4880),		-- 2
Checkpoints( 2712.6298,	1310.6669, 13.6419),	-- 3
Checkpoints(2829.1064, 1436.44, 10.5162),		-- 4
Checkpoints(2782.4716, 1525.5292, 9.7729),		-- 5
Checkpoints(2729.1005, 1812.75, 6.5581),		-- 6
Checkpoints(2773.9082, 2046.6904, 9.1560),		-- 7
Checkpoints(2719.7871, 2115.8505, 13.7437),		-- 8
Checkpoints(2509.4902, 2114.9462, 10.4880),		-- 9
Checkpoints(2400.9990, 2149.6630, 10.5272),		-- 10
Checkpoints(2196.4970, 2150.0312, 10.4746),		-- 11
Checkpoints(2149.6796, 2213.7060, 1049095),		-- 12
Checkpoints(2229.5185, 2426.5937, 10.4748),		-- 13
Checkpoints(2117.9375, 2455.0009, 10.5272),		-- 14
Checkpoints(2037.2714, 2342.9609, 10.4735),		-- 15
Checkpoints(2045.8105, 1623.1123, 10.5269),		-- 16
Checkpoints(2055.3525, 1371.8535, 10.4815),		-- 17
Checkpoints(2292.7185, 1371.2167, 10.4796),		-- 18
Checkpoints(2310.5205, 1463.1201, 10.6294),		-- 19 -- Parking exercise
Checkpoints(2301.7207, 1451.6406, 10.6252),		-- 20 -- Parking exercise
Checkpoints(2310.9482, 1438.4736, 10.6266),		-- 21 -- Parking exercise
Checkpoints(2381.1210, 130.7363, 10.5272),		-- 22
Checkpoints(2425.0205, 1221.6035, 10.4880),		-- 23
}

testVehicle = {[]=true, []=true, []=true, []=true, []=true} -- need to /makecivveh. The test cars are permanently spawned.


function initiateDrivingTest(thePlayer)
	local blip = createBlip(2514.2597, 1191.9062, 10.477, 0, 2, 255, 0, 255, 255)
	local marker = createMarker(2514.2597, 1191.9062, 10.477, "cylinder", 2, 0, 255, 0, 150) -- start marker.
	exports.pool:allocateElement(blip)
	exports.pool:allocateElement(marker)
	attachElements ( marker, blip )
		
	setElementVisibleTo(blip, getRootElement(), false)
	setElementVisibleTo(blip, thePlayer, true)
	setElementVisibleTo(marker, getRootElement(), false)
	setElementVisibleTo(marker, thePlayer, true)
			
	outputChatBox("You are now ready to take your practical driving examination. Collect a DMV test car and begin the route.", thePlayer, 255, 194, 14)
	outputChatBox("(( The first marker has been added to your radar.))", thePlayer, 255, 194, 14)
	addEventHandler("onMarkerHit", marker, startDrivingTest, false)
end
addEvent("DrivingTestPart2", true)
addEventHandler("DrivingTestPart2", getRootElement(), initiateDrivingTest)

function startDrivingTest(thePlayer)
	if (isElement(thePlayer)) then
		local attached = getElementAttachedTo ( source ) -- source is the marker; attatched is the blip
		destroyElement(attached)
		destroyElement(source)
		attached = nil
		source = nil
		
		local vehicle = getPedOccupiedVehicle ( thePlayer )
		setElementData(thePlayer, "drivingTest.marker", "1")
		setElementData(thePlayer, "drivingTest.vehicle", vehicle)

		local x1,y1,z1 = nil -- Setup the first checkpoint
		x1 = CheckpointStyle_1[1].x_point
		y1 = CheckpointStyle_1[1].y_point
		z1 = CheckpointStyle_1[1].z_point
		setElementData(thePlayer, "drivingTest.checkmarkers", "23")

		local blip2 = createBlip(x1 ,y1 ,z1, 0, 2, 255, 0, 255, 255)
		local marker2 = createMarker(x1 ,y1 ,z1 , "checkpoint", 4, 255, 0, 255, 150)
		exports.pool:allocateElement(blip2)
		exports.pool:allocateElement(marker2)
		
		setElementVisibleTo(blip2, getRootElement(), false)
		setElementVisibleTo(blip2, thePlayer, true)
		setElementVisibleTo(marker2, getRootElement(), false)
		setElementVisibleTo(marker2, thePlayer, true)
		
		local colsphere = createColSphere ( x1 ,y1 ,z1 , 4 )
		exports.pool:allocateElement(colsphere)
		attachElements ( marker2, blip2 )
		setElementData(colsphere, "attatched", marker2)
		
		addEventHandler("onColShapeHit", colsphere, UpdateCheckpoints)	
		
		outputChatBox(" You will need tocomplete the route without damaging the test car.", thePlayer, 255, 194, 14)
		outputChatBox("Good luck and drive safe.", thePlayer, 255, 194, 14)
	end
	
end
addCommandHandler("st", startDrivingTest)

function UpdateCheckpoints(thePlayer)
	local vehicle = getPedOccupiedVehicle(thePlayer)
	if not (vehicle(testVehicle) then
		outputChatBox("You must be in a DMV test car when passing through the check points.", thePlayer, 255, 0, 0) -- Wrong car type.
	else
		local markerattatched = getElementData(source, "attatched" )
		local attached = getElementAttachedTo ( markerattatched ) -- source is the marker; attatched is the blip
		destroyElement(attached)
		destroyElement(markerattatched)
		destroyElement(source)
		attached = nil
		markerattatched = nil
		source = nil
			
		local m_number = getElementData(thePlayer, "drivingTest.marker")
		local max_number = getElementData(thePlayer, "drivingTest.checkmarkers")
		if tonumber(max_number-1) == tonumber(m_number) then
			outputChatBox("Pull over at the side of the road ahead to complete the test.", thePlayer, 255, 194, 14)
			local newnumber = m_number+1
			setElementData(thePlayer, "drivingTest.marker", newnumber)
				
			local x2, y2, z2 = nil
			x2 = CheckpointStyle_1[newnumber].x_point
			y2 = CheckpointStyle_1[newnumber].y_point
			z2 = CheckpointStyle_1[newnumber].z_point
				
			local marker3 = createMarker( x2, y2, z2, "checkpoint", 4, 255, 0, 255, 150)
			local blip3 = createBlip( x2, y2, z2, 0, 2, 255, 0, 255, 255)
			exports.pool:allocateElement(marker3)
			exports.pool:allocateElement(blip3)
				
			setElementVisibleTo(blip3, getRootElement(), false)
			setElementVisibleTo(blip3, thePlayer, true)
			setElementVisibleTo(marker3, getRootElement(), false)
			setElementVisibleTo(marker3, thePlayer, true)
				
			local colsphere = createColSphere ( x2 ,y2 ,z2 , 4 )
			exports.pool:allocateElement(colsphere)
			attachElements ( marker3, blip3 )
			setElementData(colsphere, "attatched", marker3)
				
			addEventHandler("onColShapeHit", colsphere, EndTest)
		elseif
			local newnumber = m_number+1
			setElementData(thePlayer, "drivingTest.marker", newnumber)
				
			local x2, y2, z2 = nil
			x2 = CheckpointStyle_1[newnumber].x_point
			y2 = CheckpointStyle_1[newnumber].y_point
			z2 = CheckpointStyle_1[newnumber].z_point
				
			local marker3 = createMarker( x2, y2, z2, "checkpoint", 4, 255, 0, 255, 150)
			local blip3 = createBlip( x2, y2, z2, 0, 2, 255, 0, 255, 255)
			exports.pool:allocateElement(marker3)
			exports.pool:allocateElement(blip3)
				
			setElementVisibleTo(blip3, getRootElement(), false)
			setElementVisibleTo(blip3, thePlayer, true)
			setElementVisibleTo(marker3, getRootElement(), false)
			setElementVisibleTo(marker3, thePlayer, true)
				
			local colsphere = createColSphere ( x2 ,y2 ,z2 , 4 )
			exports.pool:allocateElement(colsphere)
			attachElements ( marker3, blip3 )
			setElementData(colsphere, "attatched", marker3)
								
			addEventHandler("onColShapeHit", colsphere, UpdateCheckpoints)
		end
	end
end


function EndTest(thePlayer)
	local vehicle = getPedOccupiedVehicle(thePlayer)
	if not (vehicle(testVehicle) then
		outputChatBox("You must be in a DMV test car when passing through the check points.", thePlayer, 255, 0, 0) -- Wrong car type.
	else
		local vehicleHealth = getElementHealth ( vehicle )
		if (vehicleHealth > 1750) then
			local playerMoney = getElementData(thePlayer, "money")
			if (playerMoney < 350 ) then
				outputChatBox("You can't afford the $350 processing fee.", thePlayer, 255, 0, 0) -- Wrong car type.
			else
				----------
				-- PASS --
				----------
				givelicense(1, 350)
			end
		else
			outputChatBox("After inspecting the vehicle we can see that it's damage.", thePlayer, 255, 194, 14) -- Wrong car type.
			outputChatBox("You have failed the practical driving test.", thePlayer, 255, 0, 0) -- Wrong car type.

		end
		
		local markerattatched = getElementData(source, "attatched" )
		local attached = getElementAttachedTo ( markerattatched ) -- source is the marker; attatched is the blip
		destroyElement(attached)
		destroyElement(markerattatched)
		destroyElement(source)
		attached = nil
		markerattatched = nil
		source = nil

		removePedFromVehicle ( thePlayer ) -- respawn the vehicle
		respawnVehicle(	vehicle )
			
		removeElementData(thePlayer, "drivingTest.vehicle")
		
		removeElementData(thePlayer, "drivingTest.vehicle")	-- cleanup data
		removeElementData ( thePlayer, "drivingTest.marker" )
		removeElementData ( thePlayer, "drivingTest.checkmarkers" )
	end
end

function quit()
    local vehicle = getElementData(source, "drivingTest.vehicle")
    if vehicle then
        respawnVehicle(	vehicle )
    end
    removeElementData(source, "drivingTest.vehicle")
end
addEventHandler("onPlayerQuit", getRootElement(), quit)