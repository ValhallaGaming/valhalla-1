---------
-- SQL --
---------

-- Items:
	-- Sedative, "A hypodermic needle filled with a drug."
	-- Antidote, "A hypodermic needle filled with a drug."

-----------------
-- Server side --
-----------------

-- Server side /sedate function
function sedatePlayer(thePlayer, CommandName, targetPartialNick)
	if not(exports.global:doesPlayerHaveItem(thePlayer, ??)) then -- does the player have the sedative item?
		outputChatBox("You need something to sedate them with.", thePlayer, 255, 0, 0)
	else
		if not (targetPartialNick) then -- if missing target player arg.
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer = exports.global:findPlayerByPartialNick(targetPartialNick)
			if not (targetPlayer) then -- is the player online?
				outputChatBox("Player not found.", thePlayer, 255, 0, 0)
			else
				local logged = getElementData(targetPlayerName, "loggedin")
				if (logged==0) then -- Are they logged in?
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
				elseif (logged==1) then
					local targetPlayerName = getPlayerName(targetPlayer)
					local x, y, z = getElementPosition(thePlayer)
					local tx, ty, tz = getElementPosition(targetPlayer)
					if (getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)>4) then -- Are they standing next to each other?
						outputChatBox("You are too far away to inject "..targetPlayerName..".", thePlayer, 255, 0, 0)
					else
						exports.global:sendLocalMeAction(thePlayer,"injects "..targetPlayerName.." with a sedative.")
						exports.global:takePlayerItem(thePlayer, itemID, itemValue)
						triggerClientEvent("sedativeEffect", targetPlayer)
						setTimer(sedativeDelay, 3000, 1, targetPlayer)
					end
				end
			end
		end
	end
end
addCommandHandler("sedate", blindfoldPlayer, false, false)

-- Server side /antidote function
function antidotePlayer (thePlayer, CommandName, targetPartialNick)
	if not(exports.global:doesPlayerHaveItem(thePlayer, ??)) then -- does the player have the antidote item?
		outputChatBox("You need an antidote to revive them.", thePlayer, 255, 0, 0)
	else
		if not (targetPartialNick) then -- if missing target player arg.
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer = exports.global:findPlayerByPartialNick(targetPartialNick)
			if not (targetPlayer) then -- is the player online?
				outputChatBox("Player not found.", thePlayer, 255, 0, 0)
			else
				local logged = getElementData(targetPlayerName, "loggedin")
				if (logged==0) then -- Are they logged in?
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
				elseif (logged==1) then
					local targetPlayerName = getPlayerName(targetPlayer)
					local x, y, z = getElementPosition(thePlayer)
					local tx, ty, tz = getElementPosition(targetPlayer)
					if (getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)>4) then -- Are they standing next to each other?
						outputChatBox("You are too far away to inject "..targetPlayerName..".", thePlayer, 255, 0, 0)
					else
						exports.global:sendLocalMeAction(thePlayer,"injects "..targetPlayerName.." with an antidote.")
						exports.global:takePlayerItem(thePlayer, itemID, itemValue)
						triggerClientEvent("cancelSedativeEffect", targetPlayer)
						setTimer(antidoteDelay, 3000, 1, targetPlayer)
					end
				end
			end
		end
	end
end
addCommandHandler("antidote", blindfoldPlayer, false, false)

function sedativeDelay()
	setElementData(targetPlayer, "freeze", 1)
	exports.global:applyAnimation(targetPlayer, "ped", "FLOOR_hit", true, 1.0, 1.0, 0.0, false, false)
	exports.global:sendLocalMeAction(targetPlayer,"staggers and collapses.")
end

function antidoteDelay()
	setElementData(targetPlayer, "freeze", 0)
	exports.global:removeAnimation(targetPlayer)
	exports.global:sendLocalMeAction(targetPlayer,"slowly regains consciousness.")
end

-----------------
-- Client Side --
-----------------
	
-- Client Side Sedative Effect
sedativeTimer = nil
function sedativeEffect ()
	-- Freeze the player
	toggleAllControls( false, true, false)
	setPedWeaponSlot(targetPlayer, 0)
	-- Fade Screen to black
	fadeCamera ( false, 3.0, 0, 0, 0 )
	-- Create Text on victims screen
	sedativeText = guiCreateLabel(0.0, 0.5, 1.0, 0.3, "You have been sedated", true)
	-- Start the effect timer
	sedativeTimer = setTimer(cancelSedative, 300000, 1) -- 5 minutes.
end

function cancelSedativeEffect ()
	-- Unfreeze the player
	toggleAllControls( true, true, false)
	-- Fade Screen in
	fadeCamera ( true, 3.0 )
	-- Remove the text
	destroyElement(sedativeText)
	killTimer(sedativeTimer)
	sedativeTimer = nil
		
end
