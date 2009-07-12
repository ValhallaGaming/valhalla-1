local totalCatch = 0
local fishSize = 0

-- /fish to start fishing.
function startFishing(thePlayer)
	local element = getPedContactElement(thePlayer)
	
	if not (isElement(element)) then
		outputChatBox("You must be on a boat to fish.", thePlayer, 255, 0, 0)
	else
		if not (getElementType(element)=="vehicle") then
			outputChatBox("You must be on a boat to fish.", thePlayer, 255, 0, 0)
		else
			if not (getVehicleType(element)=="Boat") then
				outputChatBox("You must be on a boat to fish.", thePlayer, 255, 0, 0)
			else
				local x, y, z = getElementPosition(thePlayer)
					
				if (x < 3000) or (y > 4000) then -- the further out to sea you go the bigger the fish you will catch.
					outputChatBox("You must be out at sea to fish.", thePlayer, 255, 0, 0)
				else
					if not(exports.global:doesPlayerHaveItem(thePlayer, 49)) then -- does the player have the fishing rod item?
						outputChatBox("You need a fishing rod to fish.", thePlayer, 255, 0, 0)
					else
						if (catchTimer) then -- Are they already fishing?
							outputChatBox("You have already cast your line. Wait for a fish to bite.", thePlayer, 255, 0, 0)
						else
							if (totalCatch >= 2000) then
								outputChatBox("#FF9933The boat can't hold any more fish. #FF66CCSell#FF9933 the fish you have caught before continuing.", thePlayer, 255, 104, 91, true)
							else
								local biteTimer = math.random(60000,300000)
								--catchTimer = setTimer( theyHaveABite, biteTimer, 1, thePlayer) -- A fish will bite within 1 and 5 minutes.
								catchTimer = setTimer( theyHaveABite, 10000, 1, thePlayer)
								exports.global:sendLocalMeAction(thePlayer,"casts a fishing line.")
								
								if not (colsphere) then -- If the /sellfish marker isnt already being shown...
									blip = createBlip( 2243.7339, 578.905, 6.78, 0, 2, 255, 0, 255, 255 )
									marker = createMarker( 2243.7339, 578.905, 6.78, "cylinder", 2, 255, 0, 255, 150 )
									colsphere = createColSphere (2243.7339, 578.905, 6.78, 3)
									
									setElementVisibleTo(blip, getRootElement(), false)
									setElementVisibleTo(blip, thePlayer, true)
									setElementVisibleTo(marker, getRootElement(), false)
									setElementVisibleTo(marker, thePlayer, true)

									outputChatBox("#FF9933When you are done fishing you can sell your catch at the fish market ((#FF66CCblip#FF9933 added to radar)).", thePlayer, 255, 104, 91, true)
									outputChatBox("#FF9933((/totalcatch to see how much you have caught. To sell your catch enter /sellfish in the #FF66CCmarker#FF9933.))", thePlayer, 255, 104, 91, true)
								end
							end
						end
					end
				end
			end
		end
	end
end	
addCommandHandler("fish", startFishing, false, false)
addEvent("fish")
addEventHandler("fish", getRootElement(), startFishing)

------ triggers the mini game.
function theyHaveABite(source)
	killTimer(catchTimer)
	catchTimer=nil
	triggerClientEvent("createReel", source) 
	exports.global:sendLocalMeAction(source,"has a bite!")
end

----- Snapped line.
function lineSnap()
	exports.global:takePlayerItem(source, 49, 1) -- fishing rod
	exports.global:sendLocalMeAction(source,"snaps their fishing line.")
	outputChatBox("The monster of a fish has broken your line. You need to buy a new fishing rod to continue fishing.", source, 255, 0, 0)
end
addEvent("lineSnap",true)
addEventHandler("lineSnap", getRootElement(), lineSnap)

----- Successfully reeled in the fish.
function catchFish(fishSize)
		exports.global:sendLocalMeAction(source,"catches a fish weighing ".. fishSize .."lbs.")
	totalCatch = totalCatch + fishSize
	outputChatBox("You have caught "..totalCatch.."lbs of fish so far.", source, 255, 194, 14)
	if (fishSize >= 100) then
		exports.global:givePlayerAchievement(source, 35)
	end
end
addEvent("catchFish", true)
addEventHandler("catchFish", getRootElement(), catchFish)

------ /totalcatch command
function currentCatch(thePlayer)
	outputChatBox("You have "..totalCatch.."lbs of fish caught so far.", thePlayer, 255, 194, 14)
end
addCommandHandler("totalcatch", currentCatch, false, false)

------ /sellfish
function unloadCatch(thePlayer)
	if (isElementWithinColShape(thePlayer, colsphere)) then
		if (totalCatch == 0) then
			outputChatBox("You need to catch some fish to sell first." ,thePlayer, 255, 0, 0)
		else
			local profit = math.floor(totalCatch)/2
			exports.global:sendLocalMeAction(thePlayer,"sells " .. totalCatch .."lbs of fish.")
			exports.global:givePlayerSafeMoney(thePlayer, profit)
			outputChatBox("You made $".. profit .." from the fish you caught." ,thePlayer, 255, 104, 91)
			totalCatch = 0
			destroyElement(blip)
			destroyElement(marker)
			destroyElement(colsphere)
			blip=nil
			marker=nil
			colsphere=nil
		end
	else
		outputChatBox("You need to be at the fish market to sell your catch.", thePlayer, 255, 0, 0)
	end
end
addCommandHandler("sellFish", unloadCatch, false, false)