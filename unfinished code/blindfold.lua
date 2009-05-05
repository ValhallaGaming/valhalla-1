-- Blindfold Item

---------
-- SQL --
---------
INSERT INTO items SET id='22', item_name='Sack', item_description='An empty sack. Perfect for putting over heads to blindfold people.';

-------------------------------
-- Server side Item function --
-------------------------------

-- /blindfold [player]
function blindfoldPlayer(thePlayer, commandName, targetPartialNick )
	if not (targetPartialNick) then
		outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID]", thePlayer, 255, 194, 14)
	else
		if not(exports.global:doesPlayerHaveItem(thePlayer, 22)) then -- does the player have the blindfold object?
			outputChatBox("You need something to blindfold them with.", thePlayer, 255, 0, 0)
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
						outputChatBox("You are too far away to blindfold "..targetPlayerName..".", thePlayer, 255, 0, 0)
					else
						local dbid = getElementData( targetPlayer, "dbid" )
						local blindfoldState = mysql_query(handler, "SELECT blidfold FROM characters WHERE id=".. dbid .."'") -- is the target already blindfolded?
						if (blindfoldState == 0 ) then -- if they are not blindfolded...
							local restrain = getElementData(thePlayer, "restrain")
							if (restrain == 1 ) then -- is the person attempting to remove the blindfold cuffed?
								outputChatBox("You can't blindfold someone while you are restrained.", thePlayer, 255, 0, 0) -- cuffed error.
							else -- if they aren't cuffed. Remove the blind fold.
								local query = mysql_query(handler, "UPDATE characters SET blindfold=1 WHERE id='" .. dbid .. "'") -- Set the players blindfold state to 1.
								if (query) then
									mysql_free_result(query)								
									fadeCamera ( targetPlayer, false, 0.1, 0, 0, 0 )
									exports.global:takePlayerItem(thePlayer, 22, 1)
									exports.global:sendLocalMeAction(thePlayer,"blindfolds "..targetPlayerName.."." ) -- comfirmation
									triggerClientEvent( "createBlindfoldText", targetPlayer ) -- to creat the text on the screen.
								else
									outputChatBox("sql error. Unable to perform query.", thePlayer, 255, 0, 0)
								end
							end
						elseif (blindfoldState == 1 ) then -- if the target is already blindfolded ...
							local restrain = getElementData(thePlayer, "restrain")
							if (restrain == 1 ) then -- is the person attempting to remove the blindfold cuffed?
								outputChatBox("You can't remove a blindfold while restrained.", thePlayer, 255, 0, 0)
								exports.global:sendLocalMeAction(thePlayer," struggles in vein to remove the blindfold.") -- cuffed error.
							else -- if they aren't cuffed. Remove the blind fold.
								local query = mysql_query(handler, "UPDATE characters SET blindfold=0 WHERE id='" .. dbid .. "'") -- Set the players blindfold state to 0.
								if (query) then
									mysql_free_result(query)
									fadeCamera ( targetPlayer, true, 0.1 )
									exports.global:givePlayerItem(thePlayer, 22, 1)
									exports.global:sendLocalMeAction(thePlayer,"removes the blindfold from "..targetPlayerName.."." ) -- comfirmation
									triggerClientEvent( "delBlindfoldText", targetPlayer ) -- to creat the text on the screen.
								else
									outputChatBox("sql error. Unable to perform query.", thePlayer, 255, 0, 0)
								end
							end
						end
					end
				end	
			end
		end
	end
end
addCommandHandler("blindfold", givePlayerBadge, false, false)

-----------------
-- Client Side --
-----------------
blindfoldText = nil

function addBlindfoldText()	
	blindfoldText = guiCreateLabel(0.0, 0.5, 1.0, 0.3, "You have been blindfolded", true)
	guiSetFont(blindfoldText, "sa-header")
	guiLabelSetHorizontalAlign(blindfoldText, "center", true)
	guiSetAlpha(blindfoldText, 1.0)
end
addEvent ( "fadeBlindfoldText", true )
addEventHandler ( "fadeBlindfoldText", getRootElement(), addBlindfoldText )

function deleteBlindfoldText()	
	destroyElement(blindfoldText)
	blindfoldText = nil
end
addEvent ( "delBlindfoldText", true )
addEventHandler ( "delBlindfoldText", getRootElement(), deleteBlindfoldText )	

-------------------------------
-- Client side shop resource --
-------------------------------
-- Adds the sack item to the general shop GUI
function getItemsForSale(shop_type, race)
	if(shop_type == 1) then
		-- General Items
		item[20] = {"Sack", "An empty, heavy duty, storage sack.", "10", 22, 0, 1, false, 2}
