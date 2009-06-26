---------
-- SQL --
---------

-- Items:
	-- Sedative, "A hypodermic needle filled with a drug."
	-- Antidote, "A hypodermic needle filled with a drug."

-----------------
-- Server side --
-----------------

-- Server side useItem function
	elseif (itemID== ) then -- sedative
		exports.global:sendLocalMeAction(thePlayer,"injects "..targetPlayerName.." with a sedative.")
		exports.global:takePlayerItem(source, itemID, itemValue)
		triggerClientEvent("sedativeEffect", targetPlayer)
		setTimer(sedativeDelay, 3000, 1)
	elseif (itemID== ) then -- Antidote
		exports.global:sendLocalMeAction(thePlayer,"injects "..targetPlayerName.." with an antidote.")
		exports.global:takePlayerItem(source, itemID, itemValue)
		triggerClientEvent("cancelSedativeEffect", targetPlayer)
		setTimer(antidoteDelay, 3000, 1)

		
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
	-- Fade Screen in
	fadeCamera ( true, 3.0 )
	-- Remove the text
	destroyElement(sedativeText)
	killTimer(sedativeTimer)
	sedativeTimer = nil
end
