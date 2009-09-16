pdColShape = createColSphere(255.3798828125, 77.3798828125, 1003.640625, 5)
exports.pool:allocateElement(pdColShape)
setElementDimension(pdColShape, 1)
setElementInterior(pdColShape, 6)

esColShape = createColSphere(1581.2067871094, 1790.4083251953, 2083.3837890625, 5)
exports.pool:allocateElement(esColShape)
setElementInterior(esColShape, 4)

fbiColShape = createColSphere(222.822265625, 123.501953125, 1010.2117919922, 5)
exports.pool:allocateElement(fbiColShape)
setElementDimension(fbiColShape, 795)
setElementInterior(fbiColShape, 10)

function saveWeaponsOnDuty( thePlayer )
	triggerClientEvent(thePlayer, "saveGunsDuty", thePlayer)
	triggerClientEvent(thePlayer, "saveGuns", thePlayer)
	exports.global:takeAllWeapons(thePlayer)
end

function restoreWeapons( thePlayer )
	exports.global:takeAllWeapons(thePlayer)
	local weapons = getElementData(thePlayer, "dutyguns")
	if weapons then
		for k, v in pairs( weapons ) do
			exports.global:giveWeapon(thePlayer,k,v)
		end
		removeElementData(thePlayer, "dutyguns")
	end
	triggerClientEvent(thePlayer, "saveGuns", thePlayer)
end

--- DUTY TYPE
-- 0 = NONE
-- 1 = SWAT
-- 2 = Police
-- 3 = Cadet
-- 4 = ES
-- 5 = FIRE ES
-- 6 = FBI

-- ES
function lvesHeal(thePlayer, commandName, targetPartialNick, price)
	if not (targetPartialNick) or not (price) then -- if missing target player arg.
		outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID] [Price of Heal]", thePlayer, 255, 194, 14)
	else
		local targetPlayer = exports.global:findPlayerByPartialNick(targetPartialNick)
		if not (targetPlayer) then -- is the player online?
			outputChatBox("Player not found or multiple were found.", thePlayer, 255, 0, 0)
		else
			local logged = getElementData(thePlayer, "loggedin")
	
			if (logged==1) then
				local theTeam = getPlayerTeam(thePlayer)
				local factionType = getElementData(theTeam, "type")
				
				if not (factionType==4) then
					outputChatBox("You have no basic medic skills, contact the ES.", thePlayer, 255, 0, 0)
				else
					price = tonumber(price)
					if price > 600 then
						outputChatBox("This is too much to ask him for.", thePlayer, 255, 0, 0)
					else
						local targetPlayerName = getPlayerName(targetPlayer)
						local x, y, z = getElementPosition(thePlayer)
						local tx, ty, tz = getElementPosition(targetPlayer)
						
						if (getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)>5) then -- Are they standing next to each other?
							outputChatBox("You are too far away to heal '"..getPlayerName(targetPlayerName).."'.", thePlayer, 255, 0, 0)
						else
							local money = exports.global:getMoney(targetPlayer)
							local bankmoney = getElementData(targetPlayer, "bankmoney")
							
							if money + bankmoney < price then
								outputChatBox("The player cannot afford the heal.", thePlayer, 255, 0, 0)
							else
								local takeFromCash = math.min( money, price )
								local takeFromBank = price - takeFromCash
								exports.global:takeMoney(targetPlayer, takeFromCash)
								if takeFromBank > 0 then
									setElementData(targetPlayer, "bankmoney", bankmoney - takeFromBank)
								end
								
								local tax = exports.global:getTaxAmount()
								
								exports.global:giveMoney( getTeamFromName("Los Santos Emergency Services"), math.ceil((1-tax)*price) )
								exports.global:giveMoney( getTeamFromName("Government of Los Santos"), math.ceil(tax*price) )
								
								setElementHealth(targetPlayer, 100)
								triggerEvent("onPlayerHeal", targetPlayer, true)
								outputChatBox("You healed '" ..getPlayerName(targetPlayer).. "'.", thePlayer, 0, 255, 0)
								outputChatBox("You have been healed by '" ..getPlayerName(thePlayer).. "' for $" .. price .. ".", targetPlayer, 0, 255, 0)
							end
						end
					end
				end
			end
		end
	end
end
addCommandHandler("heal", lvesHeal, false, false)

function lvesExamine(thePlayer, commandName, targetPartialNick)
	if not targetPartialNick then -- if missing target player arg.
		outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID]", thePlayer, 255, 194, 14)
	else
		local targetPlayer = exports.global:findPlayerByPartialNick(targetPartialNick)
		if not targetPlayer then -- is the player online?
			outputChatBox("Player not found or multiple were found.", thePlayer, 255, 0, 0)
		else
			local logged = getElementData(thePlayer, "loggedin")
	
			if logged==1 then
				local theTeam = getPlayerTeam(thePlayer)
				local factionType = getElementData(theTeam, "type")
				
				if not (factionType==4) then
					outputChatBox("You have no basic medic skills, contact the ES.", thePlayer, 255, 0, 0)
				else
					local targetPlayerName = getPlayerName(targetPlayer)
					local x, y, z = getElementPosition(thePlayer)
					local tx, ty, tz = getElementPosition(targetPlayer)
				
					if (getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)>5) then -- Are they standing next to each other?
						outputChatBox("You are too far away to examine '"..getPlayerName(targetPlayerName).."'.", thePlayer, 255, 0, 0)
					else
						triggerEvent("onPlayerExamine", targetPlayer, thePlayer)
					end
				end
			end
		end
	end
end
addCommandHandler("examine", lvesExamine, false, false)

function lvesduty(thePlayer, commandName)	
	local logged = getElementData(thePlayer, "loggedin")

	if (logged==1) then
		if (isElementWithinColShape(thePlayer, esColShape)) then
		
			local duty = tonumber(getElementData(thePlayer, "duty"))
			local theTeam = getPlayerTeam(thePlayer)
			local factionType = getElementData(theTeam, "type")
			
			if (factionType==4) then
				if (duty==0) then
					local dutyskin = getElementData(thePlayer, "dutyskin")
					
					if (dutyskin==-1) then
						outputChatBox("You have not picked a uniform yet, press F4 to pick a uniform.", thePlayer, 255, 0, 0)
					else
						outputChatBox("You are now on Medic Duty.", thePlayer)
						exports.global:sendLocalMeAction(thePlayer, "takes their uniform from their locker.")
						
						setElementData(thePlayer, "casualskin", getPedSkin(thePlayer), false)
						
						saveWeaponsOnDuty(thePlayer)
						setElementHealth(thePlayer, 100)
						
						exports.global:giveWeapon(thePlayer, 41, 1500) -- Pepperspray
						exports.global:giveItem(thePlayer, 70, 7) -- first aid kit
						setPedSkin(thePlayer, dutyskin)
						
						setElementData(thePlayer, "duty", 4, false)
					end
				elseif (duty==4) then -- ES
					restoreWeapons(thePlayer)
					outputChatBox("You are now off Medic Duty.", thePlayer)
					exports.global:sendLocalMeAction(thePlayer, "puts their uniform into their locker.")
					setElementData(thePlayer, "duty", 0, false)
					
					local casualskin = getElementData(thePlayer, "casualskin")
					setPedSkin(thePlayer, casualskin)
				elseif (duty==5) then -- FIRE ES
					restoreWeapons(thePlayer)
					outputChatBox("You are now off Firefighter Duty.", thePlayer)
					exports.global:sendLocalMeAction(thePlayer, "puts their firefighter gear into their locker.")
					setElementData(thePlayer, "duty", 0, false)
					
					local casualskin = getElementData(thePlayer, "casualskin")
					setPedSkin(thePlayer, casualskin)
				end
			end
		end
	end
end
addCommandHandler("duty", lvesduty, false, false)

-- ES FD
function lvfdduty(thePlayer, commandName)	
	local logged = getElementData(thePlayer, "loggedin")

	if (logged==1) then
		if (isElementWithinColShape(thePlayer, esColShape)) then
		
			local duty = tonumber(getElementData(thePlayer, "duty"))
			local theTeam = getPlayerTeam(thePlayer)
			local factionType = getElementData(theTeam, "type")
			
			if (factionType==4) then
				if (duty==0) then
					local dutyskin = getElementData(thePlayer, "dutyskin")
					
					if (dutyskin==-1) then
						outputChatBox("You have not picked a uniform yet, press F4 to pick a uniform.", thePlayer, 255, 0, 0)
					else
						outputChatBox("You are now on Firefighter Duty.", thePlayer)
						exports.global:sendLocalMeAction(thePlayer, "takes their firefighter gear from their locker.")
						
						setElementData(thePlayer, "casualskin", getPedSkin(thePlayer), false)
						
						saveWeaponsOnDuty(thePlayer)
						setElementHealth(thePlayer, 100)
						
						exports.global:giveWeapon(thePlayer, 42, 1500) -- Fire Extinguisher
						exports.global:giveWeapon(thePlayer, 9, 1) -- Chainsaw
						exports.global:giveItem(thePlayer, 70, 3) -- first aid kit
						setPedSkin(thePlayer, dutyskin)
						
						setElementData(thePlayer, "duty", 5, false)
					end
				elseif (duty==4) then -- ES
					restoreWeapons(thePlayer)
					outputChatBox("You are now off Medic Duty.", thePlayer)
					exports.global:sendLocalMeAction(thePlayer, "puts their uniform into their locker.")
					setElementData(thePlayer, "duty", 0, false)
					
					local casualskin = getElementData(thePlayer, "casualskin")
					setPedSkin(thePlayer, casualskin)
				elseif (duty==5) then -- FIRE ES
					restoreWeapons(thePlayer)
					outputChatBox("You are now off Firefighter Duty.", thePlayer)
					exports.global:sendLocalMeAction(thePlayer, "puts their firefighter gear into their locker.")
					setElementData(thePlayer, "duty", 0, false)
					
					local casualskin = getElementData(thePlayer, "casualskin")
					setPedSkin(thePlayer, casualskin)
				end
			end
		end
	end
end
addCommandHandler("firefighter", lvfdduty, false, false)

function pdarmor(thePlayer, commandName)
	local logged = getElementData(thePlayer, "loggedin")

	if (logged==1) then
		if (isElementWithinColShape(thePlayer, pdColShape)) then
		
			local duty = tonumber(getElementData(thePlayer, "duty"))
			local theTeam = getPlayerTeam(thePlayer)
			local factionType = getElementData(theTeam, "type")
			
			if (factionType==2) then
				outputChatBox("You now have a new armor vest.", thePlayer, 255, 194, 14)
				setPedArmor(thePlayer, 100)
			end
		end
	end
end
addCommandHandler("armor", pdarmor)

function swatduty(thePlayer, commandName)	
	local logged = getElementData(thePlayer, "loggedin")

	if (logged==1) then
		if (isElementWithinColShape(thePlayer, pdColShape)) then
		
			local duty = tonumber(getElementData(thePlayer, "duty"))
			local theTeam = getPlayerTeam(thePlayer)
			local factionType = getElementData(theTeam, "type")
			
			if (factionType==2) then
				if (duty==0) then
					outputChatBox("You are now on SWAT Duty.", thePlayer)
					exports.global:sendLocalMeAction(thePlayer, "takes their swat gear from their locker.")
					
					setElementData(thePlayer, "casualskin", getPedSkin(thePlayer), false)
					
					saveWeaponsOnDuty(thePlayer)
					
					setPedArmor(thePlayer, 100)
					setElementHealth(thePlayer, 100)
					
					exports.global:giveWeapon(thePlayer, 24, 250) -- Deagle / MP Handgun
					exports.global:giveWeapon(thePlayer, 27, 200) -- Shotgun
					exports.global:giveWeapon(thePlayer, 29, 800) -- MP5
					exports.global:giveWeapon(thePlayer, 31, 1200) -- M4
					exports.global:giveWeapon(thePlayer, 34, 200) -- Sniper
					exports.global:giveWeapon(thePlayer, 17, 10) -- Tear gas
					
					exports.global:giveItem(thePlayer, 26, 1)
					exports.global:giveItem(thePlayer, 27, 1)
					exports.global:giveItem(thePlayer, 28, 1)
					exports.global:giveItem(thePlayer, 29, 1)
					exports.global:giveItem(thePlayer, 45, 1)
					
					setPedSkin(thePlayer, 285)
					
					setElementData(thePlayer, "duty", 1, false)
				elseif (duty==1) then -- SWAT
					restoreWeapons(thePlayer)
					outputChatBox("You are now off SWAT duty.", thePlayer)
					exports.global:sendLocalMeAction(thePlayer, "puts their SWAT gear into their locker.")
					setPedArmor(thePlayer, 0)
					setElementData(thePlayer, "duty", 0, false)
					
					exports.global:takeItem(thePlayer, 26)
					exports.global:takeItem(thePlayer, 27)
					exports.global:takeItem(thePlayer, 28)
					exports.global:takeItem(thePlayer, 29)
					exports.global:takeItem(thePlayer, 45)
					
					local casualskin = getElementData(thePlayer, "casualskin")
					setPedSkin(thePlayer, casualskin)
				elseif (duty==2) then
					restoreWeapons(thePlayer)
					outputChatBox("You are now off duty.", thePlayer)
					exports.global:sendLocalMeAction(thePlayer, "puts their gear into their locker.")
					setPedArmor(thePlayer, 0)
					setElementData(thePlayer, "duty", 0, false)
					
					exports.global:takeItem(thePlayer, 45)
					
					local casualskin = getElementData(thePlayer, "casualskin")
					setPedSkin(thePlayer, casualskin)
				elseif (duty==3) then -- CADET
					restoreWeapons(thePlayer)
					outputChatBox("You are now off duty.", thePlayer)
					exports.global:sendLocalMeAction(thePlayer, "puts their cadet gear into their locker.")
					setPedArmor(thePlayer, 0)
					setElementData(thePlayer, "duty", 0, false)
					
					exports.global:takeItem(thePlayer, 45)
					
					local casualskin = getElementData(thePlayer, "casualskin")
					setPedSkin(thePlayer, casualskin)
				end
			end
		end
	end
end
addCommandHandler("swat", swatduty, false, false)

function policeduty(thePlayer, commandName)	
	local logged = getElementData(thePlayer, "loggedin")

	if (logged==1) then
		if (isElementWithinColShape(thePlayer, pdColShape)) then
		
			local duty = tonumber(getElementData(thePlayer, "duty"))
			local theTeam = getPlayerTeam(thePlayer)
			local factionType = getElementData(theTeam, "type")
			
			if (factionType==2) then
				if (duty==0) then
					local dutyskin = getElementData(thePlayer, "dutyskin")
					
					if (dutyskin==-1) then
						outputChatBox("You have not picked a uniform yet, press F4 to pick a uniform.", thePlayer, 255, 0, 0)
					else
						outputChatBox("You are now on Police Duty.", thePlayer)
						exports.global:sendLocalMeAction(thePlayer, "takes their gear from their locker.")
						
						setElementData(thePlayer, "casualskin", getPedSkin(thePlayer), false)
						
						saveWeaponsOnDuty(thePlayer)
						
						setPedArmor(thePlayer, 100)
						setElementHealth(thePlayer, 100)
						
						exports.global:giveWeapon(thePlayer, 3, 1) -- Nightstick
						exports.global:giveWeapon(thePlayer, 24, 200) -- Deagle / MP Handgun
						exports.global:giveWeapon(thePlayer, 25, 200) -- Shotgun
						exports.global:giveWeapon(thePlayer, 29, 1000) -- MP5
						exports.global:giveWeapon(thePlayer, 41, 1500) -- Pepperspray
						
						exports.global:giveItem(thePlayer, 45, 1)
						
						setPedSkin(thePlayer, dutyskin)
						
						setElementData(thePlayer, "duty", 2, false)
					end
				elseif (duty==1) then -- SWAT
					restoreWeapons(thePlayer)
					outputChatBox("You are now off SWAT duty.", thePlayer)
					exports.global:sendLocalMeAction(thePlayer, "puts their SWAT gear into their locker.")
					setPedArmor(thePlayer, 0)
					setElementData(thePlayer, "duty", 0, false)
					
					exports.global:takeItem(thePlayer, 26)
					exports.global:takeItem(thePlayer, 27)
					exports.global:takeItem(thePlayer, 28)
					exports.global:takeItem(thePlayer, 29)
					exports.global:takeItem(thePlayer, 45)
					
					local casualskin = getElementData(thePlayer, "casualskin")
					setPedSkin(thePlayer, casualskin)
				elseif (duty==2) then
					restoreWeapons(thePlayer)
					outputChatBox("You are now off duty.", thePlayer)
					exports.global:sendLocalMeAction(thePlayer, "puts their gear into their locker.")
					setPedArmor(thePlayer, 0)
					setElementData(thePlayer, "duty", 0, false)
					
					exports.global:takeItem(thePlayer, 45)
					
					local casualskin = getElementData(thePlayer, "casualskin")
					setPedSkin(thePlayer, casualskin)
				elseif (duty==3) then -- CADET
					restoreWeapons(thePlayer)
					outputChatBox("You are now off duty.", thePlayer)
					exports.global:sendLocalMeAction(thePlayer, "puts their cadet gear into their locker.")
					setPedArmor(thePlayer, 0)
					setElementData(thePlayer, "duty", 0, false)
					
					exports.global:takeItem(thePlayer, 45)
					
					local casualskin = getElementData(thePlayer, "casualskin")
					setPedSkin(thePlayer, casualskin)
				end
			end
		end
	end
end
addCommandHandler("duty", policeduty, false, false)

function cadetduty(thePlayer, commandName)	
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		if (isElementWithinColShape(thePlayer, pdColShape)) then
		
			local duty = tonumber(getElementData(thePlayer, "duty"))
			local theTeam = getPlayerTeam(thePlayer)
			local factionType = getElementData(theTeam, "type")
			
			if (factionType==2) then
				if (duty==0) then
					local dutyskin = getElementData(thePlayer, "dutyskin")
					
					if (dutyskin==-1) then
						outputChatBox("You have not picked a uniform yet, press F4 to pick a uniform.", thePlayer, 255, 0, 0)
					else
						outputChatBox("You are now on Cadet Duty.", thePlayer)
						exports.global:sendLocalMeAction(thePlayer, "takes their cadet gear from their locker.")
						
						setElementData(thePlayer, "casualskin", getPedSkin(thePlayer), false)
						
						saveWeaponsOnDuty(thePlayer)
						
						setPedArmor(thePlayer, 100)
						setElementHealth(thePlayer, 100)
						
						exports.global:giveWeapon(thePlayer, 3, 1) -- Nightstick
						exports.global:giveWeapon(thePlayer, 24, 200) -- Deagle / MP Handgun
						exports.global:giveWeapon(thePlayer, 41, 1000) -- Pepperspray
						
						exports.global:giveItem(thePlayer, 45, 1)
						
						setPedSkin(thePlayer, dutyskin)
						
						setElementData(thePlayer, "duty", 3, false)
					end
				elseif (duty==1) then -- SWAT
					restoreWeapons(thePlayer)
					outputChatBox("You are now off SWAT duty.", thePlayer)
					exports.global:sendLocalMeAction(thePlayer, "puts their SWAT gear into their locker.")
					setPedArmor(thePlayer, 0)
					setElementData(thePlayer, "duty", 0, false)
					
					exports.global:takeItem(thePlayer, 26)
					exports.global:takeItem(thePlayer, 27)
					exports.global:takeItem(thePlayer, 28)
					exports.global:takeItem(thePlayer, 29)
					exports.global:takeItem(thePlayer, 45)
					
					local casualskin = getElementData(thePlayer, "casualskin")
					setPedSkin(thePlayer, casualskin)
				elseif (duty==2) then -- POLICE
					restoreWeapons(thePlayer)
					outputChatBox("You are now off duty.", thePlayer)
					exports.global:sendLocalMeAction(thePlayer, "puts their gear into their locker.")
					setPedArmor(thePlayer, 0)
					setElementData(thePlayer, "duty", 0, false)
					
					exports.global:takeItem(thePlayer, 45)
					
					local casualskin = getElementData(thePlayer, "casualskin")
					setPedSkin(thePlayer, casualskin)
				elseif (duty==3) then -- CADET
					restoreWeapons(thePlayer)
					outputChatBox("You are now off duty.", thePlayer)
					exports.global:sendLocalMeAction(thePlayer, "puts their cadet gear into their locker.")
					setPedArmor(thePlayer, 0)
					setElementData(thePlayer, "duty", 0, false)
					
					exports.global:takeItem(thePlayer, 45)
					
					local casualskin = getElementData(thePlayer, "casualskin")
					setPedSkin(thePlayer, casualskin)
				end
			end
		end
	end
end
addCommandHandler("cadet", cadetduty, false, false)

function fbiduty(thePlayer, commandName)	
	local logged = getElementData(thePlayer, "loggedin")

	if (logged==1) then
		if (isElementWithinColShape(thePlayer, fbiColShape)) then
		
			local duty = tonumber(getElementData(thePlayer, "duty"))
			local theTeam = getPlayerTeam(thePlayer)
			local factionType = getElementData(theTeam, "type")
			
			if (factionType==2) then
				if (duty==0) then
					local dutyskin = getElementData(thePlayer, "dutyskin")
					
					if (dutyskin==-1) then
						outputChatBox("You have not picked a uniform yet, press F4 to pick a uniform.", thePlayer, 255, 0, 0)
					else
						outputChatBox("You are now on FBI Duty.", thePlayer)
						exports.global:sendLocalMeAction(thePlayer, "takes their FBI gear from their locker.")
						
						setElementData(thePlayer, "casualskin", getPedSkin(thePlayer), false)
						
						saveWeaponsOnDuty(thePlayer)
						
						setPedArmor(thePlayer, 100)
						setElementHealth(thePlayer, 100)
						
						exports.global:giveWeapon(thePlayer, 22, 200) -- Colt 45
						exports.global:giveItem(thePlayer, 45, 1) -- Cuffs
						
						setPedSkin(thePlayer, dutyskin)
						
						setElementData(thePlayer, "duty", 6, false)
					end
				elseif (duty==6) then -- FBI
					restoreWeapons(thePlayer)
					outputChatBox("You are now off FBI duty.", thePlayer)
					exports.global:sendLocalMeAction(thePlayer, "puts their FBI gear into their locker.")
					setPedArmor(thePlayer, 0)
					setElementData(thePlayer, "duty", 0, false)
					
					exports.global:takeItem(thePlayer, 45)
					
					local casualskin = getElementData(thePlayer, "casualskin")
					setPedSkin(thePlayer, casualskin)
				else
					local casualskin = getElementData(thePlayer, "casualskin")
					setPedSkin(thePlayer, casualskin)
					setElementData(thePlayer, "duty", 0, false)
				end
			end
		end
	end
end
addCommandHandler("fbi", fbiduty, false, false)