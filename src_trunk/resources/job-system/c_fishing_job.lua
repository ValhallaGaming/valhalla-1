local count = 0
local pFish = nil
local state = 0
local fishSize = 0
local hotSpot1 = nil
local hotSpot2 = nil

function fishOnLine()
	-- create the progress bar
	count = 0
	state = 0
			
	if (pFish) then
		destroyElement(pFish)
	end
		
	pFish = guiCreateProgressBar(0.425, 0.75, 0.2, 0.035, true)
	outputChatBox("You got a bite! ((Tap - and = to reel in the catch.))", 0, 255, 0)
	bindKey("-", "down", reelItIn)
			
	-- create two timers
	resetTimer = setTimer(resetProgress, 2750, 0)
	gotAwayTimer = setTimer(gotAway, 60000, 1)
		
	local x, y, z = getElementPosition(getLocalPlayer())
	if(x>=3950) and (x<=4450) and (y>= 1220) and (y<=1750) or (x>=4250) and (x<=5000) and (y>= -103) and (y<=500) then
		fishSize = math.random(100, 200)
	else
		local x, y, z = getElementPosition(getLocalPlayer())
		if ( y > 4500) then
			fishSize = math.random(75, 99)
		elseif (x > 5500) then
			fishSize = math.random(75, 99)
		elseif (x > 4500) then
			fishSize = math.random(50, 99)
		elseif (x > 3500) then
			fishSize = math.random(25,75)
		else
			fishSize = math.random(1, 50)
		end
	end
	
	-- Chances of line snapping 1/10. Fish over 100lbs are twice as likely to snap your line.
	local lineSnap = math.random(1,10)
	if (fishSize>=100)then
		if (lineSnap > 8) then
			triggerServerEvent("lineSnap",getLocalPlayer())
			killTimer (resetTimer)
			killTimer (gotAwayTimer)
			destroyElement(pFish)
			pFish = nil
			unbindKey("-", "down", reelItIn)
			unbindKey("=", "down", reelItIn)
			fishSize = 0
		end
	else
		if (lineSnap > 9) then
			triggerServerEvent("lineSnap",getLocalPlayer())
			killTimer (resetTimer)
			killTimer (gotAwayTimer)
			destroyElement(pFish)
			pFish = nil
			unbindKey("-", "down", reelItIn)
			unbindKey("=", "down", reelItIn)
			fishSize = 0
		end
	end
end
addEvent("createReel", true)
addEventHandler("createReel", getLocalPlayer(), fishOnLine)

function reelItIn()
	if (state==0) then
		bindKey("=", "down", reelItIn)
		unbindKey("-", "down", reelItIn)
		state = 1
	elseif (state==1) then
		bindKey("-", "down", reelItIn)
		unbindKey("=", "down", reelItIn)
		state = 0
	end
	
	count = count + 1
	guiProgressBarSetProgress(pFish, count)
	
	if (count>=100) then
		killTimer (resetTimer)
		killTimer (gotAwayTimer)
		destroyElement(pFish)
		pFish = nil
		unbindKey("-", "down", reelItIn)
		unbindKey("=", "down", reelItIn)
		triggerServerEvent("catchFish", getLocalPlayer(), fishSize)
	end
end

function resetProgress()
	if(count>=0)then
		local difficulty = (fishSize/4)
		guiProgressBarSetProgress(pFish, (count-difficulty))
		count = count-difficulty
	else
		count = 0
	end
end

function gotAway()
	killTimer (resetTimer)
	destroyElement(pFish)
	pFish = nil
	unbindKey("-", "down", reelItIn)
	unbindKey("=", "down", reelItIn)
	outputChatBox("#FF9933The fish get away.", 255, 0, 0, true)
	fishSize = 0
end
