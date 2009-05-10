pdColShape = createColSphere(215.86735534668, 148.48937988281, 1003.0234375, 10)
exports.pool:allocateElement(pdColShape)
setElementDimension(pdColShape, 1)
setElementInterior(pdColShape, 3)

--- DUTY TYPE
-- 1 = SWAT
-- 2 = Police
-- 3 = Cadet
function policeduty(thePlayer, commandName)	
	local logged = getElementData(thePlayer, "loggedin")

	if (logged==1) then
		if (isElementWithinColShape(thePlayer, pdColShape)) then
		
			local duty = tonumber(getElementData(thePlayer, "duty"))
			local theTeam = getPlayerTeam(thePlayer)
			local factionType = getElementData(theTeam, "type")
			
			if (factionType==2) then
				if (duty==0) then
					outputChatBox("You are now on Police Duty.", thePlayer)
					exports.global:sendLocalMeAction(thePlayer, "takes their gear from their locker.")
					
					setElementData(thePlayer, "casualskin", getPedSkin(thePlayer))
					
					takeAllWeapons(thePlayer)
					
					setPedArmor(thePlayer, 100)
					setElementHealth(thePlayer, 100)
					
					giveWeapon(thePlayer, 3, 1) -- Nightstick
					giveWeapon(thePlayer, 24, 1000) -- Deagle / MP Handgun
					giveWeapon(thePlayer, 25, 400) -- Shotgun
					giveWeapon(thePlayer, 29, 1000) -- MP5
					giveWeapon(thePlayer, 41, 5000) -- Pepperspray
					
					setPedSkin(thePlayer, 282)
					
					setElementData(thePlayer, "duty", 2)
				elseif (duty==2) then
					takeAllWeapons(thePlayer)
					outputChatBox("You are now off duty.", thePlayer)
					exports.global:sendLocalMeAction(thePlayer, "puts their gear into their locker.")
					setPedArmor(thePlayer, 0)
					setElementData(thePlayer, "duty", 0)
					
					local casualskin = getElementData(thePlayer, "casualskin")
					setPedSkin(thePlayer, casualskin)
				elseif (duty==3) then -- CADET
					takeAllWeapons(thePlayer)
					outputChatBox("You are now off duty.", thePlayer)
					exports.global:sendLocalMeAction(thePlayer, "puts their cadet gear into their locker.")
					setPedArmor(thePlayer, 0)
					setElementData(thePlayer, "duty", 0)
					
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
					outputChatBox("You are now on Cadet Duty.", thePlayer)
					exports.global:sendLocalMeAction(thePlayer, "takes their cadet gear from their locker.")
					
					setElementData(thePlayer, "casualskin", getPedSkin(thePlayer))
					
					takeAllWeapons(thePlayer)
					
					setPedArmor(thePlayer, 100)
					setElementHealth(thePlayer, 100)
					
					giveWeapon(thePlayer, 3, 1) -- Nightstick
					giveWeapon(thePlayer, 24, 1000) -- Deagle / MP Handgun
					giveWeapon(thePlayer, 41, 5000) -- Pepperspray
					
					setPedSkin(thePlayer, 71)
					
					setElementData(thePlayer, "duty", 3)
				elseif (duty==2) then -- POLICE
					takeAllWeapons(thePlayer)
					outputChatBox("You are now off duty.", thePlayer)
					exports.global:sendLocalMeAction(thePlayer, "puts their gear into their locker.")
					setPedArmor(thePlayer, 0)
					setElementData(thePlayer, "duty", 0)
					
					local casualskin = getElementData(thePlayer, "casualskin")
					setPedSkin(thePlayer, casualskin)
				elseif (duty==3) then -- CADET
					takeAllWeapons(thePlayer)
					outputChatBox("You are now off duty.", thePlayer)
					exports.global:sendLocalMeAction(thePlayer, "puts their cadet gear into their locker.")
					setPedArmor(thePlayer, 0)
					setElementData(thePlayer, "duty", 0)
					
					local casualskin = getElementData(thePlayer, "casualskin")
					setPedSkin(thePlayer, casualskin)
				end
			end
		end
	end
end
addCommandHandler("cadet", cadetduty, false, false)