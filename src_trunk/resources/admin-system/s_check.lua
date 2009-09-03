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
				local note = ""
				local result = mysql_query( handler, "SELECT adminnote FROM accounts WHERE id = " .. tostring(getElementData(noob, "gameaccountid")) )
				if result then
					local text = mysql_result( result, 1, 1 )
					if text ~= mysql_null() then
						note = text
					end
					mysql_free_result( result )
				else
					outputDebugString( "Check Error: " .. mysql_error( handler ) )
				end
				
				triggerClientEvent( sourcePlayer, "onCheck", noob, ip, adminreports, donatorlevel, note)
			else
				outputChatBox("No such player online.", sourcePlayer, 255, 194, 14)
			end
		end
	end
end
addCommandHandler("check", doCheck)

function savePlayerNote( target, text )
	if exports.global:isPlayerAdmin(source) then
		local account = getElementData(target, "gameaccountid")
		if account then
			local result = mysql_query( handler, "UPDATE accounts SET adminnote = '" .. mysql_escape_string( handler, text ) .. "' WHERE id = " .. account )
			if result then
				mysql_free_result( result )
				
				outputChatBox( "Note for the " .. getPlayerName( target ):gsub("_", " ") .. " (" .. getElementData( target, "gameaccountusername" ) .. ") has been updated.", source, 0, 255, 0 )
			else
				outputDebugString( "Save Note Error: " .. mysql_error( handler ) )
				outputChatBox( "Note Update failed.", source, 255, 0, 0 )
			end
		else
			outputChatBox( "Unable to get Account ID.", source, 255, 0, 0 )
		end
	end
end
addEvent( "savePlayerNote", true )
addEventHandler( "savePlayerNote", getRootElement(), savePlayerNote )

function deleteall()
	for key, value in ipairs(getElementChildren(getRootElement())) do
		local element = getElementType(value)
		
		if (element=="pickup" or element=="ped" or element=="vehicle" or element=="marker" or element=="colshape") then
			destroyElement(value)
		end
	end
end
addCommandHandler("deleteall", deleteall)