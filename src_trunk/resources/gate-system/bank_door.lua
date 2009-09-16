-- Cashier
local ped = createPed(150, 2358.7563, 2361.6530, 2021.9191)
exports.pool:allocateElement(ped)
setPedRotation(ped, 90)

-- Guard.
local ped2 = createPed(71, 2345.7058, 2351.9014, 2022.8787)
exports.pool:allocateElement(ped2)
setPedRotation(ped2, 270)

-- Desk worker
local ped3 = createPed(141, 2340.0141, 2356.8478, 2022.93)
exports.pool:allocateElement(ped3)
setPedRotation(ped3, 270)

-- Manager in office.
local ped4 = createPed(57, 2357.0864, 2369.5573, 2021.9191)
exports.pool:allocateElement(ped4)
setPedRotation(ped4, 270)

setElementInterior(ped, 3)
setElementInterior(ped2, 3)
setElementInterior(ped3, 3)
setElementInterior(ped4, 3)

setPedAnimation(ped)
setPedAnimation(ped2)
setPedAnimation(ped3)
setPedAnimation(ped4)

local cooldown = false
local robbed = false
-- AI script
function playerTarget(target)
	if (target==ped4)then
		local faction = getPlayerTeam(source)
		local factiontype = getElementData(faction, "type")
		
		if (factiontype~=2) then
			local policeFaction = getTeamFromName("Los Santos Metropolitan Police Department")
			local police = getPlayersInTeam(policeFaction)
		
			if not (cooldown) then -- and (#police>2) then
				setPedAnimation(target, "ped", "handsup", -1, false, false, false)
				setTimer(setPedAnimation, 30000, 1, target)
				
				setPedAnimation(ped, "ped", "handsup", -1, false, false, false)
				setTimer(setPedAnimation, 30000, 1, ped)
				
				setPedAnimation(ped2, "ped", "handsup", -1, false, false, false)
				setTimer(setPedAnimation, 30000, 1, ped2)
				
				setPedAnimation(ped3, "ped", "handsup", -1, false, false, false)
				setTimer(setPedAnimation, 30000, 1, ped3)
				
				local dimension = getElementDimension(target)
				local interior = getElementInterior(target)
				
				local x, y, z = getElementPosition(target)
				local chatSphere = createColSphere(x, y, z, 20)
				exports.pool:allocateElement(chatSphere)
				local nearbyPlayers = getElementsWithinColShape(chatSphere, "player")
				
				
				for key, value in ipairs(police) do
					outputChatBox("[RADIO] This is dispatch, We've got an incident, Over.", value, 0, 183, 239)
					outputChatBox("[RADIO] The Bank of Los Santos is being robbed! ((" .. getPlayerName(source) .. "))", value, 0, 183, 239)
				end
				
				for index, nearbyPlayer in ipairs(nearbyPlayers) do
					local nearbyPlayerDimension = getElementDimension(nearbyPlayer)
					local nearbyPlayerInterior = getElementInterior(nearbyPlayer)
					
					if (nearbyPlayerDimension==dimension) and (nearbyPlayerInterior==interior) then
						local logged = tonumber(getElementData(nearbyPlayer, "loggedin"))
						if not (isPedDead(nearbyPlayer)) and (logged==1) then
							setTimer(outputChatBox, 1000, 1, "Bank Manager: Please Don't shoot!", nearbyPlayer, 255, 255, 255)
							setTimer(outputChatBox, 3000, 1, "Bank Manager: I will give you everything that's in our safe!", nearbyPlayer, 255, 255, 255)
							setTimer(outputChatBox, 11000, 1, "* The Bank Manager ducks behind the safe and starts to unlock it *", nearbyPlayer, 255, 51, 102)
							setTimer(outputChatBox, 16000, 1, "* The Bank Manager sobs a little *", nearbyPlayer, 255, 51, 102)
							setTimer(outputChatBox, 24000, 1, "Bank Manager: Please Don't shoot! It's almost open!", nearbyPlayer, 255, 255, 255)
							setTimer(outputChatBox, 30000, 1, "* The Bank Manager opens the safe and hands over the money *", nearbyPlayer, 255, 51, 102)
						end
					end
				end
				exports.global:givePlayerAchievement(source, 31)
				setTimer(giveBankMoney, 30000, 1, source, chatSphere)
				cooldown = true
				setTimer(resetCooldown, 3600000, 1)
			end
		end
	end
end
--addEventHandler("onPlayerTarget", getRootElement(), playerTarget)

function resetCooldown()
	cooldown = false
end

function giveBankMoney(thePlayer, colshape)
	if (isElementWithinColShape(thePlayer, colshape)) then
		destroyElement(colshape)
		exports.global:giveMoney(thePlayer, 2500)
	end
end