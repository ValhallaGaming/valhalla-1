recognisedLanguages ={ [le], [ls], [lf], [li], [lj], [lc], [lr], [lv], [la], [lp], [las] }

-- English /le [ENG]
-- Italian /li [ITA]
-- Spanish /ls [SPA]
-- Japanese /lj [JPN]
-- Chinese (Mandarin, Wu, Min, Cantonese)/ lc [CHI]
-- Russian /lr [RUS]
-- Vietnamese /lv [VIE]
-- Arabic /la [ARA]
-- Patois (Jamaican /lp [PAT]
-- American sign language? /las [SIGNED]

-- globals
	-- getTagFromLanguage: creates the "[Esp]", etc tags from the recognisedLangauges (ls, lf, li, le, lj, etc) args.
	-- languageFilterSentChat: Checks the senders language ability for the language the message is sent in, then randomises it accordingly.
	-- languageFilterReceivedChat: Checks the already filtered message against the receivers language ability for the language the message is sent in, then randomises words accordingly.

----------------------------
--------- Example ----------
----------------------------
-- /w(hisper)
function localWhisper(thePlayer, commandName, targetPlayerNick, language, ...)
	local logged = tonumber(getElementData(thePlayer, "loggedin")) 
	 
	if (logged==1) then -- Is the player logged in?
		if not (targetPlayerNick) or not (...) then -- Is there are player and message in the entered command?
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick][Language Code][Message]", thePlayer, 255, 194, 14) -- Error message.
			outputChatBox("Type /languages to see the available language codes.", thePlayer, 255, 194, 14)
		else
			local targetPlayer = exports.global:findPlayerByPartialNick(targetPlayerNick) -- Find the target player in the server.
			
			if not (targetPlayer) then -- Was player found?
				outputChatBox("Player not found.", thePlayer, 255, 255, 0) -- Error message.
			else
				local x, y, z = getElementPosition(thePlayer)
				local tx, ty, tz = getElementPosition(targetPlayer)
					
				if (getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)>3) then -- are the two players close enough to each other?
					outputChatBox("You are too far away from " .. getPlayerName(targetPlayer) .. ".", thePlayer, 255, 0, 0) -- Error message.
				else -- if they are close enough...
					local name = string.gsub(getPlayerName(thePlayer), "_", " ") -- Format the names ready for output.
					local targetName = string.gsub(getPlayerName(targetPlayer), "_", " ")
					
					if not ( recognisedLanguages[language] ) then -- If a language wasn't specified / the language code wasn't recognised ...
						-- filter the message according to both players level of understanding USING THE SENDERS DEFAULT LANGUAGE (because the language arg was missing).
						defaultLanguage = getElementData( thePlayer, "DefaultLanguage" )
						message = table.concat({...}, " ")
						messageAsSent = exports.global:languageFilterSentChat( defaultLanguage, message ) -- Filter the chat based on how well the sender can speak the language
						messageAsUnderstood = exports.global:languageFilterReceivedChat( defaultLanguage, messageAsSent ) -- Filter the senders interpritation of the message based on how well the receiver can speak the language
						
						langTag = exports.global:getTagFromLanguage ( defaultLanguage )
						exports.global:sendLocalMeAction(thePlayer, " whispers to ".. targetName ..".")
						outputChatBox(name .." whispers ".. langTag ..": ".. message, thePlayer, 255, 255, 255) -- The senders chat isn't filtered. They may think they make sense when they don't.
						outputChatBox(name .." whispers ".. langTag ..": ".. messageAsUnderstood, targetPlayer, 255, 255, 255)
					else -- If the language code was recognised ...
						-- filter the message according to both players level of understanding of the specified language.
						message = table.concat({...}, " ")
						messageAsSent = exports.global:languageFilterSentChat( language, message ) -- Filter the chat based on how well the sender can speak the language
						messageAsUnderstood = exports.global:languageFilterReceivedChat( language, messageAsSent ) -- Filter the senders interpritation of the message based on how well the receiver can speak the language
						
						langTag = exports.global:getTagFromLanguage ( defaultLanguage )
						exports.global:sendLocalMeAction(thePlayer, " whispers to ".. targetName ..".")
						outputChatBox(name .." whispers ".. langTag ..": ".. message, thePlayer, 255, 255, 255) -- The senders chat isn't filtered. They may think they make sense when they don't.
						outputChatBox(name .." whispers ".. langTag ..": ".. messageAsUnderstood, targetPlayer, 255, 255, 255)
					end
				end
			end
		end
	end
end
addCommandHandler("w", localWhisper, false, false)