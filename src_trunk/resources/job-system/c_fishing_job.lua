local count = 0
local pFish = nil
local state = 0

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
	setElementData(getLocalPlayer(), "jammed", true, 1)
		
	-- create two timers
	resetTimer = setTimer(resetProgress, 2750, 0)
	gotAwayTimer = setTimer(gotAway, 60000, 1)
	
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
		triggerServerEvent("catchFish", getLocalPlayer())
	end
end

function resetProgress()
	if(count>=0)then
		guiProgressBarSetProgress(pFish, (count-20))
		count = count-20
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
end
