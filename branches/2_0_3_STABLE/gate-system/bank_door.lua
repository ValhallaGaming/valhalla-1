local obj = createObject(1557, 2303.9951171875, -14.620796585083, 25.7421875, 0, 0, 270.55862426758)
exports.pool:allocateElement(obj)
local obj2 = createObject(1557, 2303.9951171875, -17.6, 25.7421875, 0, 0, 90.55862426758)
exports.pool:allocateElement(obj2)
local obj3 = createObject(1557, 2303.9951171875, -17.8, 25.7421875, 0, 0, 90.55862426758)
exports.pool:allocateElement(obj3)
local obj4 = createObject(1491, 2314.75390625, 0.36209610104561, 25.7421875, 0, 0, 0)
exports.pool:allocateElement(obj4)

local ped = createPed(150, 2318.423828125, -7.2702474594116, 26.749565124512)
exports.pool:allocateElement(ped)
setPedRotation(ped, 91.057830810547)

local ped2 = createPed(141, 2318.423828125, -9.9451246261597, 26.749565124512)
exports.pool:allocateElement(ped2)
setPedRotation(ped2, 91.057830810547)

local ped3 = createPed(57, 2318.423828125, -12.672068595886, 26.749565124512)
exports.pool:allocateElement(ped3)
setPedRotation(ped3, 91.057830810547)

local ped4 = createPed(57, 2306.6376953125, -7.5967411994934, 26.7421875)
exports.pool:allocateElement(ped4)
setPedRotation(ped4, 271.95004272461)

setElementDimension(obj, 128)
setElementDimension(obj2, 128)
setElementDimension(obj3, 128)
setElementDimension(obj4, 128)
setElementDimension(ped, 128)
setElementDimension(ped2, 128)
setElementDimension(ped3, 128)
setElementDimension(ped4, 128)

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
			local policeFaction = getTeamFromName("Las Venturas Metropolitan Police Department")
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
					outputChatBox("[RADIO] The Bank of Las Venturas is being robbed! ((" .. getPlayerName(source) .. "))", value, 0, 183, 239)
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
		exports.global:givePlayerSafeMoney(thePlayer, 2500)
	end
end