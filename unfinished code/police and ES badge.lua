-- PD and ES badge items.

---------
-- SQL --
---------
INSERT INTO items SET id='20', item_name='LVMPD Badge', item_description='A gold Las Venturas Metropolitan Police Badge.';
INSERT INTO items SET id='21', item_name='LVMPD Badge', item_description='A gold Las Venturas Metropolitan Police Badge.';

-----------------------------
-- Server side item script --
-----------------------------
-- useItem function
		elseif (itemID==20) then -- Police Badge
			showInventory(source)
			local r, g, b = getPlayerNametagColor ( source )
			if not ( r == 0) and (b == 80) and (g == 255) then
				setPlayerNametagColor ( source, 0, 80, 255 ) -- Change the players name tag to blue.
				outputChatBox(source.." puts on a police badge. Badge Number: "..itemValue..".", thePlayer, 255, 51, 102)
			else
				setPlayerNametagColor ( source, false ) -- Change the players name tag to default.
				outputChatBox(source.." takes off a police badge.", thePlayer, 255, 51, 102)
			end
		elseif (itemID==21) then -- ES ID badge
			showInventory(source)
			local r, g, b = getPlayerNametagColor ( source )
			if not ( r == 255) and (b == 0) and (g == 0) then
				setPlayerNametagColor ( source, 155, 0, 0 ) -- Change the players name tag to blue.
				outputChatBox(source.." puts on a Las Venturas ID badge. Badge Number: "..itemValue..".", thePlayer, 255, 51, 102)
			else
				setPlayerNametagColor ( source, false ) -- Change the players name tag to default.
				outputChatBox(source.." takes off a Las Venturas ID badge.", thePlayer, 255, 51, 102)
			end
			
-- /issueBadge Command
-- A commnad for leaders of the PD and ES factions to issue a police badge or ES ID badge item to their members. This will be the only IC way badges can be created.
function givePlayerBadge(thePlayer, commandName, targetPlayer, badgeID )
	if not ( ) or ( )then -- If the player is not the leader of the PD or ES factions
		outputChatBox("You must be set as leader to issue badges.", thePlayer, 255, 0, 0) -- If they aren't PD or ES leader they can't give out badges.
	else	
		if not (itemValue) or not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID][Badge Number]", thePlayer, 255, 194, 14)
		else
			local targetPlayer = exports.global:findPlayerByPartialNick(targetPlayer)
			if not (targetPlayer) then -- is the player online?
				outputChatBox("Player not found.", thePlayer, 255, 0, 0)
			else
				local targetPlayerName = getPlayerName(targetPlayer)
				local logged = getElementData(targetPlayer, "loggedin")
				if (logged==0) then -- Are they logged in?
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
				elseif (logged==1) then
					local x, y, z = getElementPosition(thePlayer)
					local tx, ty, tz = getElementPosition(targetPlayer)
					if (getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)>4) then -- Are they standing next to each other?
						outputChatBox("You are too far away to issue this player a police badge.", thePlayer, 255, 0, 0)
					else
						if ( ) then -- If the player is a PD leader
							itemID = 20 -- or the ID of the police badge.
							itemValue = tonumber(itemValue) -- The badge number the player will be issued.
							exports.global:givePlayerItem(targetPlayer, itemID, itemValue) -- Give the player the badge.
							exports.global:sendLocalMeAction(thePlayer, " issues "..targetPlayer.." a police badge with number "..itemvalue..".")
						else -- If the player is a ES leader
							itemID = 21 -- or the ID of the ES badge.
							itemValue = tonumber(itemValue) -- The badge number the player will be issued.
							exports.global:givePlayerItem(targetPlayer, itemID, itemValue) -- Give the player the badge.
							exports.global:sendLocalMeAction(thePlayer, " issues "..targetPlayer.." a Las Venturas Emergency Service ID badge with number "..itemvalue..".")
						end
					end
				end
			end
		end
	end
end
addCommandHandler("issuebadge", givePlayerBadge, false, false)