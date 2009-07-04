---------
-- SQL --
---------
-- Name, description
-- Mask, ((RP as a bandana, halloween mask, balaclava, etc))

-------------

-- server side use item
elseif (itemID==??itemID) then -- MASK
			local mask = getElementData(source, "masked")
			
			if not (masked) or (masked==0) then
				exports.global:sendLocalMeAction(source, "covers their face with something.")
				
				-- can't see their name
				local pid = getElementData(source, "playerid")
				local fixedName = "(" .. tostring(pid) .. ") Unknown_Person"
				setPlayerNametagText(source, tostring(fixedName))

				setElementData(source, "masked", 1)
			elseif (masked==1) then
				exports.global:sendLocalMeAction(source, "uncovers their face.")
				
				-- can see their name
				local pid = getElementData(source, "playerid")
				local name = getPlayerName(source)
				local fixedName = "(" .. tostring(pid) .. ") " .. name
				setPlayerNametagText(source, tostring(fixedName))

				setElementData(source, "masked", 0)
			end
			
-- Client side shop resources
item[23] = {"Mask", "((RP as a bandana, halloween mask, balaclava, etc))", "50", ??itemID, 1,1,false,10}