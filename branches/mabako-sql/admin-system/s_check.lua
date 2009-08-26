function doCheck(sourcePlayer, command, ...)
	if (exports.global:isPlayerAdmin(sourcePlayer)) then
		if not (...) then
			outputChatBox("SYNTAX: /" .. command .. " [Partial Player Name / ID]", sourcePlayer, 255, 194, 14)
		else
			local noob = exports.global:findPlayerByPartialNick(...)
			
			if noob and isElement(noob) then
				local ip = getPlayerIP(noob)
				local adminreports = tonumber(getElementData(noob, "adminreports"))
				local donatorlevel = exports.global:getPlayerDonatorTitle(noob)
				
				triggerClientEvent( sourcePlayer, "onCheck", noob, ip, adminreports, donatorlevel)
			else
				outputChatBox("No such player online.", sourcePlayer, 255, 194, 14)
			end
		end
	end
end
addCommandHandler("check", doCheck)

function deleteall()
	for key, value in ipairs(getElementChildren(getRootElement())) do
		local element = getElementType(value)
		
		if (element=="pickup" or element=="ped" or element=="vehicle" or element=="marker" or element=="colshape") then
			destroyElement(value)
		end
	end
end
addCommandHandler("deleteall", deleteall)