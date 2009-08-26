function getAdmins()
	local players = exports.pool:getPoolElementsByType("player")
	
	local admins = { }
	local count = 1
	
	for key, value in ipairs(players) do
		local adminLevel = getElementData(value, "adminlevel")
		
		if (adminLevel>0) then
			admins[count] = value
			count = count + 1
		end
	end
	return admins
end

function isPlayerAdmin(thePlayer)
	local adminLevel = tonumber(getElementData(thePlayer, "adminlevel"))

	if(adminLevel==0) then
		return false
	elseif(adminLevel>=1) then
		return true
	end
end

function isPlayerSuperAdmin(thePlayer)
	local adminLevel = tonumber(getElementData(thePlayer, "adminlevel"))

	if(adminLevel==0) then
		return false
	elseif(adminLevel>=1) then
		return true
	end
end

function isPlayerHeadAdmin(thePlayer)
	local adminLevel = tonumber(getElementData(thePlayer, "adminlevel"))

	if(adminLevel==0) then
		return false
	elseif(adminLevel>=5) then
		return true
	end
end

function isPlayerLeadAdmin(thePlayer)
	local adminLevel = tonumber(getElementData(thePlayer, "adminlevel"))

	if(adminLevel==0) then
		return false
	elseif(adminLevel>=4) then
		return true
	end
end

function getPlayerAdminLevel(thePlayer)
	local adminLevel = tonumber(getElementData(thePlayer, "adminlevel"))
	return adminLevel
end

local titles = { "Trial Admin", "Admin", "Super Admin", "Lead Admin", "Head Admin", "Owner" }
function getPlayerAdminTitle(thePlayer)
	local adminLevel = tonumber(getElementData(thePlayer, "adminlevel")) or 0
	local text = titles[adminLevel] or "Player"
	
	local hiddenAdmin = getElementData(thePlayer, "hiddenadmin") or 0
	if (hiddenAdmin==1) then
		text = text .. " (Hidden)"
	end
	return text
end

local scripterAccounts = {
	Daniels = true,
	Chamberlain = true,
	Konstantine = true,
	mabako = true,
	Cazomino09 = true,
	Serizzim = true,
	CCC = true,
	Flobu = true,
	ryden = true,
	['Mr.Hankey'] = true
}
function isPlayerScripter(thePlayer)
	if getElementType(thePlayer) == "console" or isPlayerHeadAdmin(thePlayer) or scripterAccounts[getElementData(thePlayer, "gameaccountusername")] then
		return true
	else
		return false
	end
end
