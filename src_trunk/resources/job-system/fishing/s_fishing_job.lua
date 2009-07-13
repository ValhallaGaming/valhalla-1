function resourceStart(res)
	if (res==getThisResource()) then
		for key, value in ipairs(exports.pool:getPoolElementsByType("player")) do
			setElementData(value, "totalcatch", 0)
		end
	end
end
addEventHandler("onResourceStart", getRootElement(), resourceStart)

-- /fish to start fishing.
function startFishing(thePlayer)
	if not (thePlayer) then
		thePlayer = source
	end
	if not(exports.global:doesPlayerHaveItem(thePlayer, 49)) then -- does the player have the fishing rod item?
		outputChatBox("You need a fishing rod to fish.", thePlayer, 255, 0, 0)
	else
		triggerClientEvent(thePlayer, "castLine", getRootElement())
	end
end	
addCommandHandler("fish", startFishing, false, false)
addEvent("fish")
addEventHandler("fish", getRootElement(), startFishing)

function theycasttheirline()
	exports.global:sendLocalMeAction(source,"casts their line.")
end
addEvent("castOutput", true)
addEventHandler("castOutput", getRootElement(), theycasttheirline)

function theyHaveABite()
	exports.global:sendLocalMeAction(source,"has a bite!")
end
addEvent("fishOnLine", true)
addEventHandler("fishOnLine", getRootElement(), theyHaveABite)


function lineSnap() ----- Snapped line.
	exports.global:takePlayerItem(source, 49, 1) -- fishing rod
	exports.global:sendLocalMeAction(source,"snaps their fishing line.")
end
addEvent("lineSnap",true)
addEventHandler("lineSnap", getRootElement(), lineSnap)

----- Successfully reeled in the fish.
function catchFish(fishSize)
	exports.global:sendLocalMeAction(source,"catches a fish weighing ".. fishSize .."lbs.")
	if (fishSize >= 100) then
		exports.global:givePlayerAchievement(source, 35)
	end
end
addEvent("catchFish", true)
addEventHandler("catchFish", getRootElement(), catchFish)

------ /sellfish
function unloadCatch( totalCatch, profit)
	exports.global:sendLocalMeAction(thePlayer,"sells " .. totalCatch .."lbs of fish.")
	exports.global:givePlayerSafeMoney(source, profit)
end
addEvent("sellcatch", true)
addEventHandler("sellcatch", getRootElement(), unloadCatch)