local odimension, ointerior, ox, oy, oz, orot, oskin
local localPlayer = getLocalPlayer()
local team = 0
local factionrank
local skins
local skincount
local curr

function changeDutySkin()
	local factionid = getElementData(localPlayer, "faction")
	factionrank = getElementData(localPlayer, "factionrank")
	curr = 1

	if (factionid==1) then
		team = 1
		skins = { }
		
		skins[1] = { }
		skins[1][1] = 71
		skins[1][2] = 1
		
		skins[2] = { }
		skins[2][1] = 280
		skins[2][2] = 2
		
		skins[3] = { }
		skins[3][1] = 281
		skins[3][2] = 10
		
		skins[4] = { }
		skins[4][1] = 282
		skins[4][2] = 12
		
		skins[5] = { }
		skins[5][1] = 283
		skins[5][2] = 15
		
		skins[6] = { }
		skins[6][1] = 284
		skins[6][2] = 2
		
		skins[7] = { }
		skins[7][1] = 288
		skins[7][2] = 13
		skincount = 7
	elseif (factionid==2) then
		team = 2
		skins = { }
		
		skins[1] = { }
		skins[1][1] = 274
		skins[1][2] = 1
		
		skins[2] = { }
		skins[2][1] = 275
		skins[2][2] = 1
		
		skins[3] = { }
		skins[3][1] = 276
		skins[3][2] = 1
		
		skins[4] = { }
		skins[4][1] = 277
		skins[4][2] = 1
		
		skins[5] = { }
		skins[5][1] = 278
		skins[5][2] = 1
		
		skins[6] = { }
		skins[6][1] = 279
		skins[6][2] = 1
		skincount = 6
	elseif (factionid==4) then
		team = 4
		skins = { }
		
		skins[1] = { }
		skins[1][1] = 163
		skins[1][2] = 1
		
		skins[2] = { }
		skins[2][1] = 164
		skins[2][2] = 1
		
		skins[3] = { }
		skins[3][1] = 165
		skins[3][2] = 1
		
		skins[4] = { }
		skins[4][1] = 166
		skins[4][2] = 1
		
		skins[5] = { }
		skins[5][1] = 286
		skins[5][2] = 1
		
		skincount = 5
	else
		return
	end
	
	odimension = getElementDimension(localPlayer)
	ointerior = getElementInterior(localPlayer)
	ox, oy, oz = getElementPosition(localPlayer)
	orot = getPedRotation(localPlayer)
	oskin = getElementModel(localPlayer)
	
	local dimension = 65000 + getElementData(localPlayer, "gameaccountid")
	setElementDimension(localPlayer, dimension)
	setElementInterior(localPlayer, 0)
	setElementPosition(localPlayer, 2373.1181640625, 972.830078125, 18.318904876709)
	setPedRotation(localPlayer, 0)
	
	setCameraMatrix(2373.0029296875, 976.880859375, 18.318904876709, 2373.1181640625, 972.830078125, 18.318904876709)
	bindKey("Enter", "down", finishDutySkin)
	addEventHandler("onClientRender", getRootElement(), displayHelpText)
	
	unbindKey("F4", "down", changeDutySkin)
	bindKey("arrow_l", "down", prevDutySkin)
	bindKey("arrow_r", "down", nextDutySkin)
	
	setElementModel(localPlayer, skins[1][1])
	
	toggleAllControls(false, true, false)
end
bindKey("F4", "down", changeDutySkin)

function prevDutySkin()
	curr = curr - 1
	if (curr<1) then
		curr = skincount
	end
	
	setElementModel(localPlayer, skins[curr][1])
end

function nextDutySkin()
	curr = curr + 1
	if (curr>skincount) then
		curr = 1
	end
	
	setElementModel(localPlayer, skins[curr][1])
end

function displayHelpText()
	local screenWidth, screenHeight = guiGetScreenSize()
	dxDrawText("Use arrow keys to pick a skin. Enter to select that skin.", screenHeight-380, screenHeight-93, screenWidth-30, screenHeight, tocolor ( 255, 255, 255, 255 ), 1, "pricedown")
	
	if (skins[curr][2]>factionrank) then
		dxDrawText("You are not a high enough rank to use this skin.", screenHeight-380, screenHeight-120, screenWidth-30, screenHeight, tocolor ( 255, 0, 0, 255 ), 1, "pricedown")
	end
end

function finishDutySkin()
	if (skins[curr][2]>factionrank) then
		playSoundFrontEnd(7)
	else
		toggleAllControls(true, true, false)
		bindKey("F4", "down", changeDutySkin)
		unbindKey("arrow_l", "down", prevDutySkin)
		unbindKey("arrow_r", "down", nextDutySkin)
		removeEventHandler("onClientRender", getRootElement(), displayHelpText)
		setElementDimension(localPlayer, odimension)
		setElementInterior(localPlayer, ointerior)
		triggerServerEvent("finishDutySkin", localPlayer, ox, oy, oz, orot, odimension, ointerior, skins[curr][1])
		setElementModel(localPlayer, oskin)
		unbindKey("Enter", "down", finishDutySkin)
	end
end