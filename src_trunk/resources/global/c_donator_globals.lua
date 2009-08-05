function cisPlayerBronzeDonator(thePlayer)
	local donatorLevel = tonumber(getElementData(thePlayer, "donatorlevel"))

	if(donatorLevel==0) then
		return false
	elseif(donatorLevel>=1) then
		return true
	end
end

function cisPlayerSilverDonator(thePlayer)
	local donatorLevel = tonumber(getElementData(thePlayer, "donatorlevel"))

	if(donatorLevel==0) then
		return false
	elseif(donatorLevel>=2) then
		return true
	end
end

function cisPlayerGoldDonator(thePlayer)
	local donatorLevel = tonumber(getElementData(thePlayer, "donatorlevel"))

	if(donatorLevel==0) then
		return false
	elseif(donatorLevel>=3) then
		return true
	end
end

function cisPlayerPlatinumDonator(thePlayer)
	local donatorLevel = tonumber(getElementData(thePlayer, "donatorlevel"))

	if(donatorLevel==0) then
		return false
	elseif(donatorLevel>=4) then
		return true
	end
end

function cisPlayerPearlDonator(thePlayer)
	local donatorLevel = tonumber(getElementData(thePlayer, "donatorlevel"))

	if(donatorLevel==0) then
		return false
	elseif(donatorLevel>=5) then
		return true
	end
end

function cisPlayerDiamondDonator(thePlayer)
	local donatorLevel = tonumber(getElementData(thePlayer, "donatorlevel"))

	if(donatorLevel==0) then
		return false
	elseif(donatorLevel>=6) then
		return true
	end
end

function cisPlayerGodlyDonator(thePlayer)
	local donatorLevel = tonumber(getElementData(thePlayer, "donatorlevel"))

	if(donatorLevel==0) then
		return false
	elseif(donatorLevel>=7) then
		return true
	end
end

function cgetPlayerDonatorLevel(thePlayer)
	local donatorLevel = tonumber(getElementData(thePlayer, "donatorlevel"))
	return donatorLevel
end

function cgetPlayerDonatorTitle(thePlayer)
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
	elseif (donatorLevel==5) then
		return "Pearl Donator"
	elseif (donatorLevel==6) then
		return "Diamond Donator"
	elseif (donatorLevel==7) then
		return "Godly Donator"
	else
		return "Player"
	end
end