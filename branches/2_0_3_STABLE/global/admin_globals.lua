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
	elseif(adminLevel>=4) then
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

function getPlayerAdminTitle(thePlayer)
	local adminLevel = tonumber(getElementData(thePlayer, "adminlevel"))
	
	if (adminLevel==0) then -- Normal player
		return "Player"
	elseif (adminLevel==1) then -- Trial Admin
		return "Trial Admin"
	elseif (adminLevel==2) then -- Admin
		return "Admin"
	elseif (adminLevel==3) then --  Super Admin
		return "Super Admin"
	elseif (adminLevel==4) then --  Lead Admin
		return "Lead Admin"
	elseif (adminLevel==5) then --  Head Admin
		local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
		
		if (hiddenAdmin==0) then
			return "Head Admin"
		elseif (hiddenAdmin==1) then
			return "Head Admin (Hidden)"
		end
	elseif (adminLevel==6) then --  Owner
		local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
		
		if (hiddenAdmin==0) then
			return "Owner"
		elseif (hiddenAdmin==1) then
			return "Owner (Hidden)"
		end
	else
		return "Player"
	end
end