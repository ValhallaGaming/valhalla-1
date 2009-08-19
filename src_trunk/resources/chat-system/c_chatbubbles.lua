-- made by dragon and flobu

local textsToDraw = {}

local showtime = 10000
local characteraddition = 50

function income(message,messagetype)
	if source ~= getLocalPlayer() or messagetype == 2 then
		addText(source,message,messagetype)
	end
end

function addText(source,message,messagetype)
	local notfirst = false
	for i,v in ipairs(textsToDraw) do
		if v[1] == source then
			v[4] = v[4] + 1
			notfirst = true
		end
	end
	local infotable = {source,message,messagetype,0}
	table.insert(textsToDraw,infotable)
	if not notfirst then
		setTimer(removeText,showtime + (#message * characteraddition),1,infotable)
	end
end

function removeText(infotable)
	for i,v in ipairs(textsToDraw) do
		if v[1] == infotable[1] and v[2] == infotable[2] then
			for i2,v2 in ipairs(textsToDraw) do
				if v2[1] == v[1] and v[4] - v2[4] == 1 then
					setTimer(removeText,showtime + (#v[2] * characteraddition),1,v2)
				end
			end
			table.remove(textsToDraw,i)
			break
		end
	end
end

function getTextsToRemove()
	for i,v in ipairs(textsToDraw) do
		if v[1] == source then
			removeText(v)
		end
	end
end

function handleDisplay()
	for i,v in ipairs(textsToDraw) do
		local camPosXl, camPosYl, camPosZl = getPedBonePosition (v[1], 6)
        local camPosXr, camPosYr, camPosZr = getPedBonePosition (v[1], 7)
        local x,y,z = (camPosXl + camPosXr) / 2, (camPosYl + camPosYr) / 2, (camPosZl + camPosZr) / 2
		--local posx,posy = getScreenFromWorldPosition(x,y,z+0.25)
		local cx,cy,cz = getCameraMatrix()
		local px,py,pz = getElementPosition(v[1])
		local distance = getDistanceBetweenPoints3D(cx,cy,cz,px,py,pz)
		local posx,posy = getScreenFromWorldPosition(x,y,z+0.020*distance+0.10)
		if posx and distance <= 45 and ( isLineOfSightClear(cx,cy,cz,px,py,pz,true,true,false,true,false,true,true,getPedOccupiedVehicle(getLocalPlayer())) or isLineOfSightClear(cx,cy,cz,px,py,pz,true,true,false,true,false,true,true,getPedOccupiedVehicle(v[1])) ) then -- change this when multiple ignored elements can be specified
			local width = dxGetTextWidth(v[2],1,"default")
			
			dxDrawRectangle(posx - (3 + (0.5 * width)),posy - (2 + (v[4] * 20)),width + 5,19,tocolor(0,0,0,255))
			dxDrawRectangle(posx - (6 + (0.5 * width)),posy - (2 + (v[4] * 20)),width + 11,19,tocolor(0,0,0,40))
			dxDrawRectangle(posx - (8 + (0.5 * width)),posy - (1 + (v[4] * 20)),width + 15,17,tocolor(0,0,0,255))
			dxDrawRectangle(posx - (10 + (0.5 * width)),posy - (1 + (v[4] * 20)),width + 19,17,tocolor(0,0,0,40))
			dxDrawRectangle(posx - (10 + (0.5 * width)),posy - (v[4] * 20) + 1,width + 19,13,tocolor(0,0,0,255))
			dxDrawRectangle(posx - (12 + (0.5 * width)),posy - (v[4] * 20) + 1,width + 23,13,tocolor(0,0,0,40))
			dxDrawRectangle(posx - (12 + (0.5 * width)),posy - (v[4] * 20) + 4,width + 23,7,tocolor(0,0,0,255))
			
			local r,g,b = 255,255,255
			if v[3] == 2 then
				r,g,b = getTeamColor(getPlayerTeam(v[1]))
			end
			
			-- dxDrawText("This is a message! font:default",400,100,400,100,tocolor(255,255,255,255),1,"default")
			-- dxDrawText("This is a message! font:default-bold",400,130,400,130,tocolor(255,255,255,255),1,"default-bold")
			-- dxDrawText("This is a message! font:clear",400,160,400,160,tocolor(255,255,255,255),1,"clear")
			-- dxDrawText("This is a message! font:arial",400,190,400,190,tocolor(255,255,255,255),1,"arial")
			-- dxDrawText("This is a message! font:pricedown",400,220,400,220,tocolor(255,255,255,255),1,"pricedown")
			-- dxDrawText("This is a message! font:bankgothic",400,250,400,250,tocolor(255,255,255,255),1,"bankgothic")
			-- dxDrawText("This is a message! font:diploma",400,280,400,280,tocolor(255,255,255,255),1,"diploma")
			-- dxDrawText("This is a message! font:beckett",400,310,400,310,tocolor(255,255,255,255),1,"beckett")
			-- dxDrawText("This is a message! font:sans",400,340,400,340,tocolor(255,255,255,255),1,"sans")
			
			dxDrawText(v[2],posx - (0.5 * width),posy - (v[4] * 20),posx - (0.5 * width),posy - (v[4] * 20),tocolor(r,g,b,255),1,"default","left","top",false,false,false)
		end
	end
end

addEvent("onMessageIncome",true)
addEventHandler("onMessageIncome",getRootElement(),income)
addEventHandler("onClientPlayerQuit",getRootElement(),getTextsToRemove)
addEventHandler("onClientRender",getRootElement(),handleDisplay)
