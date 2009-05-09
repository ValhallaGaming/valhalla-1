function getplayerid (thePlayer, commandName, targetPartialNick)
    
	if not (targetPartialNick) then -- if missing target player arg.
		outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID]", thePlayer, 255, 194, 14)
	else
	    local targetPlayer = exports.global:findPlayerByPartialNick(targetPartialNick)
		if not (targetPlayer) then -- is the player online?
			outputChatBox("Player not found.", thePlayer, 255, 0, 0)
	    else
		    local logged = getElementData(thePlayer, "loggedin")
	        if (logged==1) then
			
			    local getid = getElementData(targetPlayer, "playerid")
				outputChatBox ("** " ..targetPlayer.. "'s ID is " ..getid.. ".", sourcePlayer, 255, 194, 14)
            end
        end
    end
end
addCommandHandler("getid", getplayerid, false, false)
	    