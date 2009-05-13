
function SpikesOnGround(theElement, matchingDimension)
	if(getElementType(theElement) == "vehicle") then
		local luck
		luck = math.random(1, 4)
		if(luck ~= 1) then
			setVehicleWheelStates ( theElement, 1, -1, -1, -1 )
		end
		luck = math.random(1, 4)
		if(luck ~= 4) then
			setVehicleWheelStates ( theElement, -1, 1, -1, -1 )
		end
		luck = math.random(1, 4)
		if(luck ~= 3) then
			setVehicleWheelStates ( theElement, -1, -1, 1, -1 )
		end
		luck = math.random(1, 4)
		if(luck ~= 2) then
			setVehicleWheelStates ( theElement, -1, -1, -1, 1 )
		end
		setVehicleTurnVelocity ( theElement, 0, 0, 0.22 )
	end
end

function AddedSpikes()
	addEventHandler( "onClientColShapeHit", getRootElement(), SpikesOnGround )
end
addEvent( "onSpikesAdded", true )
addEventHandler( "onSpikesAdded", getRootElement(), AddedSpikes)

function AllSpikesRemoved(Shape,limit)
	for value=1,limit,1 do
		if(Shape[value] ~= nil) then
		local id = tonumber ( value )
		destroyElement(Shape[id])
		end
	end
	removeEventHandler( "onClientColShapeHit", getRootElement(), SpikesOnGround )
end
addEvent( "onAllSpikesRemoved", true )
addEventHandler( "onAllSpikesRemoved", getRootElement(), AllSpikesRemoved)