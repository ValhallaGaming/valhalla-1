function restartSingleResource(thePlayer, commandName, resourceName)
	if (exports.global:isPlayerHeadAdmin(thePlayer)) then
		if not (resourceName) then
			outputChatBox("SYNTAX: /restartres [Resource Name]", thePlayer, 255, 194, 14)
		else
			local theResource = getResourceFromName(tostring(resourceName))
			if (theResource) then
				restartResource(theResource)
				outputChatBox("Resource " .. resourceName .. " was restarted.", thePlayer, 0, 255, 0)
				exports.global:sendMessageToAdmins("AdmScript: " .. getPlayerName(thePlayer) .. " restarted the resource '" .. resourceName .. "'.")
			else
				outputChatBox("Resource not found.", thePlayer, 255, 0, 0)
			end
		end
	else
		outputChatBox("You are not authorised to use that command.", thePlayer, 255, 0, 0)
	end
end
addCommandHandler("restartres", restartSingleResource)
 
function stopSingleResource(thePlayer, commandName, resourceName)
	if (exports.global:isPlayerHeadAdmin(thePlayer)) then
		if not (resourceName) then
			outputChatBox("SYNTAX: /stopres [Resource Name]", thePlayer, 255, 194, 14)
		else
			local theResource = getResourceFromName(tostring(resourceName))
			if (theResource) then
				stopResource(theResource)
				outputChatBox("Resource " .. resourceName .. " was stopped.", thePlayer, 0, 255, 0)
				exports.global:sendMessageToAdmins("AdmScript: " .. getPlayerName(thePlayer) .. " stopped the resource '" .. resourceName .. "'.")
			else
				outputChatBox("Resource not found.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("stopres", stopSingleResource)
 
function startSingleResource(thePlayer, commandName, resourceName)
	if (exports.global:isPlayerHeadAdmin(thePlayer)) then
		if not (resourceName) then
			outputChatBox("SYNTAX: /startres [Resource Name]", thePlayer, 255, 194, 14)
		else
			local theResource = getResourceFromName(tostring(resourceName))
			if (theResource) then
				startResource(theResource, true)
				outputChatBox("Resource " .. resourceName .. " was started.", thePlayer, 0, 255, 0)
				exports.global:sendMessageToAdmins("AdmScript: " .. getPlayerName(thePlayer) .. " started the resource '" .. resourceName .. "'.")
			else
				outputChatBox("Resource not found.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("startres", startSingleResource)