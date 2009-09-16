function hasMoney(thePlayer, amount)
	amount = tonumber( amount ) or 0
	if thePlayer and isElement(thePlayer) and amount > 0 then
		amount = math.floor( amount )
		
		return getMoney(thePlayer) >= amount
	end
	return false
end

function getMoney(thePlayer)
	return getElementData(thePlayer, "money") or 0
end
