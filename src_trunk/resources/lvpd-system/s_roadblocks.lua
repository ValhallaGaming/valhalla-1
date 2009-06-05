rbcount = 0
roadblocks = { }

function removeRoadblock(thePlayer, commandName, id)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		local faction = getPlayerTeam(thePlayer)
		local ftype = getElementData(faction, "type")
			
		if (ftype==2) then
			if not (id) then
				outputChatBox("SYNTAX: /" .. commandName .. " [Roadblock ID]", 255, 194, 15)
			elseif (rbcount==0) then
				outputChatBox("No roadblocks are spawned.", thePlayer, 255, 0, 0)
			else
				id = tonumber(id)
				if (roadblocks[id]==nil) then
					outputChatBox("No roadblock was found with this ID.", thePlayer, 255, 0, 0)
				else
					destroyElement(roadblocks[id])
					table.remove(roadblocks, id)
					rbcount = rbcount - 1
					outputChatBox("Removed roadblock with ID #" .. id .. ".", thePlayer, 0, 255, 0)
				end
			end
		end
	end
end
addCommandHandler("delroadblock", removeRoadblock, false, false)

function removeAllRoadblocks(thePlayer, commandName)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		local faction = getPlayerTeam(thePlayer)
		local ftype = getElementData(faction, "type")
			
		if (ftype==2) then
			if (rbcount==0) then
				outputChatBox("No roadblocks are spawned.", thePlayer, 255, 0, 0)
			else
				for i = 1, rbcount do
					if (roadblocks[i]) then
						destroyElement(roadblocks[i])
						rbcount = rbcount - 1
					end
				end
				roadblocks = { }
				outputChatBox("All roadblocks are removed.", thePlayer, 0, 255, 0)
			end
		end
	end
end
addCommandHandler("delallroadblocks", removeAllRoadblocks, false, false)

function createBigRoadblock(thePlayer, commandName)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		local faction = getPlayerTeam(thePlayer)
		local ftype = getElementData(faction, "type")
			
		if (ftype==2) then
			if (rbcount==30) then
				outputChatBox("Too many roadblocks are already spawned. Please delete some using /delroadblock or /delallroadblocks.", thePlayer, 255, 0, 0)
			else
				rbcount = rbcount + 1
				local rotation = getPedRotation(thePlayer)
				local x, y, z = getElementPosition(thePlayer)
				local object = createObject(981, x, y, z, 0, 0, rotation)
				
				x = x + ( ( math.cos ( math.rad ( rotation ) ) ) * 5 )
				y = y + ( ( math.sin ( math.rad ( rotation ) ) ) * 5 )
				setElementPosition(thePlayer, x, y, z)
			
				local slot = 0
				for i = 1, 30 do
					if (roadblocks[i]==nil) then
						roadblocks[i] = object
						slot = i
						break
					end
				end

				outputChatBox("Roadblock spawned with ID #" .. slot.. ".", thePlayer, 0, 255, 0)
			end
		end
	end
end
addCommandHandler("bigrb", createBigRoadblock, false, false)
addCommandHandler("rb2", createBigRoadblock, false, false)
addCommandHandler("bigroadblock", createBigRoadblock, false, false)

function createSmallRoadblock(thePlayer, commandName)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		local faction = getPlayerTeam(thePlayer)
		local ftype = getElementData(faction, "type")
			
		if (ftype==2) then
			if (rbcount==30) then
				outputChatBox("Too many roadblocks are already spawned. Please delete some using /delroadblock or /delallroadblocks.", thePlayer, 255, 0, 0)
			else
				rbcount = rbcount + 1
				local rotation = getPedRotation(thePlayer)
				local x, y, z = getElementPosition(thePlayer)
				local object = createObject(1422, x, y, z-0.7, 0, 0, rotation)
				
				x = x + ( ( math.cos ( math.rad ( rotation ) ) ) * 5 )
				y = y + ( ( math.sin ( math.rad ( rotation ) ) ) * 5 )
				setElementPosition(thePlayer, x, y, z)
			
				local slot = 0
				for i = 1, 30 do
					if (roadblocks[i]==nil) then
						roadblocks[i] = object
						slot = i
						break
					end
				end

				outputChatBox("Roadblock spawned with ID #" .. slot.. ".", thePlayer, 0, 255, 0)
			end
		end
	end
end
addCommandHandler("smallrb", createSmallRoadblock, false, false)
addCommandHandler("rb1", createSmallRoadblock, false, false)
addCommandHandler("smallroadblock", createSmallRoadblock, false, false)