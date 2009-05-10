function getDonators()
	local players = exports.pool:getPoolElementsByType("player")
	
	local donators = { }
	local count = 1
	
	for key, value in ipairs(players) do
		local donatorLevel = getElementData(value, "donatorlevel")
		
		if (donatorLevel>0) then
			donators[count] = value
			count = count + 1
		end
	end
	return donators
end

function isPlayerBronzeDonator(thePlayer)
	local donatorLevel = tonumber(getElementData(thePlayer, "donatorlevel"))

	if(donatorLevel==0) then
		return false
	elseif(donatorLevel>=1) then
		return true
	end
end

function isPlayerSilverDonator(thePlayer)
	local donatorLevel = tonumber(getElementData(thePlayer, "donatorlevel"))

	if(donatorLevel==0) then
		return false
	elseif(donatorLevel>=2) then
		return true
	end
end

function isPlayerGoldDonator(thePlayer)
	local donatorLevel = tonumber(getElementData(thePlayer, "donatorlevel"))

	if(donatorLevel==0) then
		return false
	elseif(donatorLevel>=3) then
		return true
	end
end

function isPlayerPlatinumDonator(thePlayer)
	local donatorLevel = tonumber(getElementData(thePlayer, "donatorlevel"))

	if(donatorLevel==0) then
		return false
	elseif(donatorLevel>=4) then
		return true
	end
end

function isPlayerPearlDonator(thePlayer)
	local donatorLevel = tonumber(getElementData(thePlayer, "donatorlevel"))

	if(donatorLevel==0) then
		return false
	elseif(donatorLevel>=5) then
		return true
	end
end

function isPlayerDiamondDonator(thePlayer)
	local donatorLevel = tonumber(getElementData(thePlayer, "donatorlevel"))

	if(donatorLevel==0) then
		return false
	elseif(donatorLevel>=6) then
		return true
	end
end

function isPlayerGodlyDonator(thePlayer)
	local donatorLevel = tonumber(getElementData(thePlayer, "donatorlevel"))

	if(donatorLevel==0) then
		return false
	elseif(donatorLevel>=7) then
		return true
	end
end

function getPlayerDonatorLevel(thePlayer)
	local donatorLevel = tonumber(getElementData(thePlayer, "donatorlevel"))
	return donatorLevel
end

function getPlayerDonatorTitle(thePlayer)
	local donatorLevel = tonumber(getElementData(thePlayer, "donatorlevel"))
	
	if (donatorLevel==0) then -- Normal player
		return "Player"
	elseif (donatorLevel==1) then
		return "Bronze Donator"
	elseif (donatorLevel==2) then
		return "Silver Donator"
	elseif (donatorLevel==3) then
		return "Gold Donator"
	elseif (donatorLevel==4) then
		return "Platinum Donator"
	elseif (donatornLevel==5) then
		return "Pearl Donator"
	elseif (donatorLevel==6) then
		return "Diamond Donator"
	elseif (donatorLevel==7) then
		return "Godly Donator"
	else
		return "Player"
	end
end