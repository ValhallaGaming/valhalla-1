-- Items:
	-- Sedative, "A hypodermic needle filled with a drug."
	-- Antidote, "A hypodermic needle filled with a drug."

-- Server side useItem function
elseif (itemID== ) then -- sedative
	exports.global:sendLocalMeAction(thePlayer,"injects "..targetPlayerName.." with a sedative." )
	exports.global:sendLocalMeAction(targetPlayerName," staggers and collapses." )
	exports.global:takePlayerItem(source, itemID, itemValue)
	triggerClientEvent("sedativeEffect", targetPlayer)
	
	setElementData(targetPlayer, "freeze", 1)

elseif (itemID== ) then -- Antidote
	exports.global:sendLocalMeAction(thePlayer,"injects "..targetPlayerName.." with an antidote." )
	exports.global:sendLocalMeAction(targetPlayerName," slowly regains consciousness." )
	exports.global:takePlayerItem(source, itemID, itemValue)
	triggerClientEvent("sedativeEffect", targetPlayer)
	setElementData(targetPlayer, "freeze", 0)
	
-- Client Side Sedative Effect
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
	-- Fade Screen in
	fadeCamera ( true, 3.0 )
	-- Remove the text
	destroyElement(sedativeText)
end
