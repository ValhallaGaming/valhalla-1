function getBlips(thePlayer, stype)
	local gameaccountid = getElementData(thePlayer, "gameaccountid")
	local blips = { }
	local count = 1
	for key, value in ipairs(exports.pool:getPoolElementsByType("blip")) do
		local bliptype = getElementData(value, "type")
		local blipowner = getElementData(value, "owner")
		
		if not (stype) then
			bliptype = nil
			stype = nil
		end
		
		if (bliptype==stype) and (blipowner==gameaccountid) then
			blips[count] = value
			count = count + 1
		end
	end
	return blips
end

function getMarkers(thePlayer, stype)
	local gameaccountid = getElementData(thePlayer, "gameaccountid")
	local markers = { }
	local count = 1
	for key, value in ipairs(exports.pool:getPoolElementsByType("marker")) do
		local markertype = getElementData(value, "type")
		local markerowner = getElementData(value, "owner")
		
		if not (stype) then
			markertype = nil
			stype = nil
		end
		
		if (markertype==stype) and (markerowner==gameaccountid) then
			markers[count] = value
			count = count + 1
		end
	end
	return markers
end