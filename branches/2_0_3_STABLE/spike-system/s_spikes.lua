TotalSpikes=nil
Spike = {}
SpikeLimit=3
Shape= {}
function PlacingSpikes(sourcePlayer, command)
	local theTeam = getPlayerTeam(sourcePlayer)
	local teamType = getElementData(theTeam, "type")
	
	if (teamType==2) then
		local x1,y1,z1 = getElementPosition(sourcePlayer)		
		local rotz = getPedRotation(sourcePlayer)
			if(TotalSpikes == nil or TotalSpikes < SpikeLimit) then
			if(TotalSpikes == nil) then
				TotalSpikes = 1
			else
				TotalSpikes = TotalSpikes+1
			end
			for value=1,SpikeLimit,1 do
				if(Spike[value] == nil) then

				Spike[value] = createObject ( 1593, x1, y1, z1-0.8, 0.0, 0.0, rotz+90.0)
				exports.pool:allocateElement(Spike[value])
				Shape[value] = createColCuboid ( x1-0.5, y1-0.5, z1-0.8, 2.0, 2.0, 2.5)
				exports.pool:allocateElement(Shape[value])
				triggerClientEvent ("onSpikesAdded", getRootElement())
				outputChatBox("Spawned spikes with ID:" .. value, sourcePlayer, 0, 194, 0)
				
				break end
			end
		else
			outputChatBox("Too many spikes are already spawned.", sourcePlayer, 255, 194, 14)
		end
	end
end
addCommandHandler("deployspikes", PlacingSpikes)


function RemovingSpikes(sourcePlayer, command, ...)
	local theTeam = getPlayerTeam(sourcePlayer)
	local teamType = getElementData(theTeam, "type")
	
	if (teamType==2) then
		if not (...) then
		outputChatBox("SYNTAX: /removespikes [ID]", sourcePlayer, 255, 194, 14)
		
		else
			local message = table.concat({...}, " ")
			message = tonumber ( message )
			if(Spike[message] ~= nil) then
				local x2,y2,z2 = getElementPosition(Spike[message])
				local x1,y1,z1 = getElementPosition(sourcePlayer)
				
				if (getDistanceBetweenPoints3D(x1, y1, z1, x2, y2, z2) <= 5) then
					outputChatBox("Removed spikes with ID:" .. message, sourcePlayer, 0, 194, 0)
					TotalSpikes = TotalSpikes -1
					destroyElement(Spike[tonumber(message)])
					Spike[message] = nil
					if(TotalSpikes <= 0) then
						triggerClientEvent ("onAllSpikesRemoved", getRootElement(), Shape, SpikeLimit)
						TotalSpikes = nil
					end
				else
					outputChatBox("You are too far from those spikes!", sourcePlayer, 255, 194, 14)
				end
			else
				outputChatBox("No spikes with that ID found!", sourcePlayer, 255, 194, 14)
			end
		end
	end
end
addCommandHandler("removespikes", RemovingSpikes)

function AdminRemovingSpikes(sourcePlayer, command)
	for value=1,SpikeLimit,1 do
		if(Spike[value] ~= nil) then
			local id = tonumber ( value )
			destroyElement(Spike[id])
			Spike[id] = nil
		end
	end
	triggerClientEvent ("onAllSpikesRemoved", getRootElement(), Shape, SpikeLimit)
	outputChatBox("Removed all the spawned spikes.", sourcePlayer, 0, 194, 0)
	TotalSpikes = nil
end
addCommandHandler("aremovespikes", AdminRemovingSpikes)

