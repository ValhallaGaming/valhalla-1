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
	elseif(isPlayerScripter(thePlayer)) then
		return true
	end
end

function isPlayerSuperAdmin(thePlayer)
	local adminLevel = tonumber(getElementData(thePlayer, "adminlevel"))

	if(adminLevel==0) then
		return false
	elseif(adminLevel>=1) then
		return true
	elseif(isPlayerScripter(thePlayer)) then
		return true
	end
end

function isPlayerHeadAdmin(thePlayer)
	local adminLevel = tonumber(getElementData(thePlayer, "adminlevel"))

	if(adminLevel==0) then
		return false
	elseif(adminLevel>=5) then
		return true
	elseif(isPlayerScripter(thePlayer)) then
		return true
	end
end

function isPlayerLeadAdmin(thePlayer)
	local adminLevel = tonumber(getElementData(thePlayer, "adminlevel"))

	if(adminLevel==0) then
		return false
	elseif(adminLevel>=4) then
		return true
	elseif(isPlayerScripter(thePlayer)) then
		return true
	end
end

function getPlayerAdminLevel(thePlayer)
	local adminLevel = tonumber(getElementData(thePlayer, "adminlevel"))
	return adminLevel
end

function getPlayerAdminTitle(thePlayer)
	local adminLevel = tonumber(getElementData(thePlayer, "adminlevel"))
	
	if (adminLevel==0) then -- Normal player
		if(isPlayerScripter(thePlayer)) then
			return "Player - Scripter"
		else
			return "Player"
		end
	elseif (adminLevel==1) then -- Trial Admin
		if(isPlayerScripter(thePlayer)) then
			return "Trial Admin - Scripter"
		else
			return "Trial Admin"
		end
	elseif (adminLevel==2) then -- Admin
		if(isPlayerScripter(thePlayer)) then
			return "Admin - Scripter"
		else
			return "Admin"
		end
	elseif (adminLevel==3) then --  Super Admin
		if(isPlayerScripter(thePlayer)) then
			return "Super Admin - Scripter"
		else
			return "Super Admin"
		end
	elseif (adminLevel==4) then --  Lead Admin
		if(isPlayerScripter(thePlayer)) then
			return "Lead Admin - Scripter"
		else
			return "Lead Admin"
		end
	elseif (adminLevel==5) then --  Head Admin
		local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
		if(isPlayerScripter(thePlayer)) then
			if (hiddenAdmin==0) then
				return "Head Admin - Scripter"
			elseif (hiddenAdmin==1) then
				return "Head Admin (Hidden) - Scripter"
			end
		else
			if (hiddenAdmin==0) then
				return "Head Admin"
			elseif (hiddenAdmin==1) then
				return "Head Admin (Hidden)"
			end
		end
	elseif (adminLevel==6) then --  Owner
		local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
		if(isPlayerScripter(thePlayer)) then
			if (hiddenAdmin==0) then
				return "Owner - Scripter"
			elseif (hiddenAdmin==1) then
				return "Owner (Hidden) - Scripter"
			end
		else
			if (hiddenAdmin==0) then
				return "Owner"
			elseif (hiddenAdmin==1) then
				return "Owner (Hidden)"
			end
		end
	else
		return "Player"
	end
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
	['Mr.Hankey'] = true
}
function isPlayerScripter(thePlayer)
	if getElementType(thePlayer) == "console" or isPlayerHeadAdmin(thePlayer) or scripterAccounts[getElementData(thePlayer, "gameaccountusername")] then
		return true
	else
		return false
	end
end
