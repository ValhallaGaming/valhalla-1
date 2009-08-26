function mixDrugs(drug1, drug2, drug1name, drug2name)
	-- 30 = Cannabis Sativa
	-- 31 = Cocaine Alkaloid
	-- 32 = Lysergic Acid
	-- 33 = Unprocessed PCP
	
	-- 34 = Cocaine
	-- 35 = Drug 2
	-- 36 = Drug 3
	-- 37 = Drug 4
	-- 38 = Marijuana
	-- 39 = Drug 6
	-- 40 = Drug 7
	-- 41 = LSD
	-- 42 = Drug 9
	-- 43 = Angel Dust
	local drugName
	local drugID
	
	if (drug1 == 31 and drug2 == 31) then -- Cocaine
		drugName = "Cocaine"
		drugID = 34
	elseif (drug1==30 and drug2==31) or (drug1==31 and drug2==30) then -- Drug 2
		drugName = "Drug 2"
		drugID = 35
	elseif (drug1==32 and drug2==31) or (drug1==31 and drug2==32) then -- Drug 3
		drugName = "Drug 3"
		drugID = 36
	elseif (drug1==33 and drug2==31) or (drug1==31 and drug2==33) then -- Drug 4
		drugName = "Drug 4"
		drugID = 37
	elseif (drug1==30 and drug2==30) then -- Marijuana
		drugName = "Marijuana"
		drugID = 38
	elseif (drug1==30 and drug2==32) or (drug1==32 and drug2==30) then -- Drug 6
		drugName = "Drug 6"
		drugID = 39
	elseif (drug1==30 and drug2==33) or (drug1==33 and drug2==30) then -- Drug 7
		drugName = "Drug 7"
		drugID = 40
	elseif (drug1==32 and drug2==32) then -- LSD
		drugName = "LSD"
		drugID = 41
	elseif (drug1==32 and drug2==33) or (drug1==33 and drug2==32) then -- Drug 9
		drugName = "Drug 9"
		drugID = 42
	elseif (drug1==33 and drug2==33) then -- Angel Dust
		drugName = "Angel Dust"
		drugID = 43
	end
	
	if (drugName == nil or drugID == nil) then
		outputChatBox("Error #1000 - Report on http://bugs.valhallagaming.net", source, 255, 0, 0)
		return
	end
	
	exports.global:takeItem(source, drug1)
	exports.global:takeItem(source, drug2)
	local given = exports.global:giveItem(source, drugID, 1)
	
	if (given) then
		outputChatBox("You mixed '" .. drug1name .. "' and '" .. drug2name .. "' to form '" .. drugName .. "'", source)
		exports.global:sendLocalMeAction(source, "mixes some chemicals together.")
	else
		outputChatBox("You do not have enough space to mix these chemicals.", source, 255, 0, 0)
		exports.global:giveItem(source, drug1, 1)
		exports.global:giveItem(source, drug2, 1)
	end
end
addEvent("mixDrugs", true)
addEventHandler("mixDrugs", getRootElement(), mixDrugs)

function raidForChemicals(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		local raided = getElementData(thePlayer, "raided")
		
		if not (raided) or (raided==0) then
			local x, y, z = getElementPosition(thePlayer)
			local colShape = createColSphere(x, y, z, 5)
			
			local vehicles = getElementsWithinColShape(colShape, "vehicle")
			local found = false
			for key, value in ipairs(vehicles) do
				
				if (getElementModel(value)==416) then
					local locked = isVehicleLocked(value)
					found = true

					if (locked) then
						outputChatBox("You try to enter the ambulance, but find it is locked.", thePlayer, 255, 0, 0)
						exports.global:sendLocalMeAction(thePlayer, "attempts to enter the back of the ambulance.")
					else
						setElementData(thePlayer, "raided", 1)
						setTimer(setElementData, 300000, 1, thePlayer, "raided", 0)
						local rand1 = math.random(30, 33)
						local rand2 = math.random(30, 33)
						local given1 = exports.global:giveItem(thePlayer, rand1, 1)
						local given2 = exports.global:giveItem(thePlayer, rand2, 1)
						
						if (given1) or (given2) then
							outputChatBox("You broke into the back of the ambulance and stole some chemicals.", thePlayer, 0, 255, 0)
							exports.global:sendLocalMeAction(thePlayer, "enters the back of the ambulance and steals some chemicals.")
						elseif not (given1) and not (given2) then
							outputChatBox("You do not have enough space to take those items.", thePlayer, 255, 0, 0)
							exports.global:sendLocalMeAction(thePlayer, "enters the back of the ambulance and attempts to steal some chemicals but drops them.")
						end
					end
					break
				end
			end
			
			if not (found) then
				outputChatBox("You are too far away.", thePlayer, 255, 0, 0)
			end
		else
			outputChatBox("Please wait before raiding again.", thePlayer, 255, 0, 0)
		end
	end
end
--addCommandHandler("raid", raidForChemicals, false, false)