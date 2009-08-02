showfps = false
lastfps = 0
fps = 0
timer = nil

function toggleShowFPS()
	showfps = not showfps
	
	if (showfps) then
		fps = 0
		lastfps = 0
		addEventHandler("onClientRender", getRootElement(), countFPS)
		timer = setTimer(resetFPS, 1000, 0)
	else
		killTimer(timer)
		timer = nil
		removeEventHandler("onClientRender", getRootElement(), countFPS)
	end
end
addCommandHandler("showfps", toggleShowFPS, false)

function resetFPS()
	lastfps = fps
	fps = 0
end

function countFPS()
	fps = fps + 1
	width, height = guiGetScreenSize()
	dxDrawText("FPS: " .. tostring(lastfps), 20, height-30, 50, height-10, tocolor(255, 255, 255, 125), 1, "pricedown")
end