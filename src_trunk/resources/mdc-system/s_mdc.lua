-- ////////////////////////////////////
-- //			MYSQL				 //
-- ////////////////////////////////////		
sqlUsername = exports.mysql:getMySQLUsername()
sqlPassword = exports.mysql:getMySQLPassword()
sqlDB = exports.mysql:getMySQLDBName()
sqlHost = exports.mysql:getMySQLHost()
sqlPort = exports.mysql:getMySQLPort()

handler = mysql_connect(sqlHost, sqlUsername, sqlPassword, sqlDB, sqlPort)

function checkMySQL()
	if not (mysql_ping(handler)) then
		handler = mysql_connect(sqlHost, sqlUsername, sqlPassword, sqlDB, sqlPort)
	end
end
setTimer(checkMySQL, 300000, 0)

function closeMySQL()
	if (handler) then
		mysql_close(handler)
	end
end
addEventHandler("onResourceStop", getResourceRootElement(getThisResource()), closeMySQL)
-- ////////////////////////////////////
-- //			MYSQL END			 //
-- ////////////////////////////////////

-- function adds a new suspect to the database, where the details are stored in the table, "details"
function addNewSuspectToDatabase(details)

	-- check to see if the suspect is already in the database
	local result = mysql_query(handler, "SELECT suspect_name FROM suspectDetails WHERE suspect_name='" .. details[1] .. "'")
	local name
	if (mysql_num_rows(result)>0) then
		name = "exists"
	else
		name = nil
	end
	mysql_free_result(result)
	
	-- if the player has attached a photo, get the suspects skin
	if (details[9] ) then
	
		local suspect
		
		suspect = getPlayerFromNick ( details[1]	)
		
		if not (suspect == false) then
			local skin= getPedSkin(suspect)
			
			if(skin <10) then
				details[9] = "00"..skin
			elseif(skin >= 10 and skin < 100) then
				details[9] = "0"..skin
			else
				details[9] = skin
			end
			
		else
			details[9] = "nil"
		end
		
	else
		details[9] = "nil"
	end
	
	-- if player is not already in the database, insert them
	
	if (name==nil) then
		local result = mysql_query(handler, "INSERT INTO suspectDetails SET suspect_name='" .. details[1] .. "', birth='" .. details[2] .. "', gender='" .. details[3] .. "', ethnicy='" .. details[4] .. "', cell='" .. details[5] .. "', occupation='" .. details[6] .. "', address='" .. details[7] .. "', other='" .. details[8] .. "', is_wanted='0', wanted_reason='None', wanted_punishment='None', wanted_by='None', photo='" .. details[9] .. "', done_by='" .. details[10] .. "'")
		exports.irc:sendMessage(tostring(mysql_error(handler)))
	end

end
addEvent("onAddNewSuspect", true)
addEventHandler("onAddNewSuspect", getRootElement(), addNewSuspectToDatabase)

-- function adds a new suspect to the database, where the details are stored in the table, "details"
function addUpdateSuspectToDatabase(details)

	-- check to see if the suspect is already in the database
	local result = mysql_query(handler, "SELECT suspect_name FROM suspectDetails WHERE suspect_name='" .. details[1] .. "'")
	local name = mysql_result(result, 1, 1)
	mysql_free_result(result)
	
	local updatePhoto = details[9]
	
	-- if the player has attached a photo, get the suspects skin
	if (updatePhoto ) then
	
		local suspect
		suspect = getPlayerFromNick ( details[1]	)
		
		if not (suspect == false) then
			local skin= getElementModel(suspect)
			
			if(skin <10) then
				details[9] = "00"..skin
			elseif(skin >= 10 and skin < 100) then
				details[9] = "0"..skin
			else
				details[9] = skin
			end
		else
			details[9] = "nil"
		end
	end
	
	--if player is already in the database, updatethem
	if (name) then
	
		local sucess
	
		if(updatePhoto) then
			mysql_query(handler, "UPDATE suspectDetails SET birth='" .. details[2] .. "', gender='" .. details[3] .. "', ethnicy='" .. details[4] .. "', cell='" .. details[5] .. "', occupation='" .. details[6] .. "', address='" .. details[7] .. "', other='" .. details[8] .. "', photo='" .. details[9] .. "', done_by='" .. details[10] .. "' WHERE suspect_name='" .. details[1] .. "'")
		else
			mysql_query(handler, "UPDATE suspectDetails SET birth='" .. details[2] .. "', gender='" .. details[3] .. "', ethnicy='" .. details[4] .. "', cell='" .. details[5] .. "', occupation='" .. details[6] .. "', address='" .. details[7] .. "', other='" .. details[8] .. "', done_by='" .. details[10] .. "' WHERE suspect_name='" .. details[1] .. "'")
		end
		
		if(sucess) then
			-- get the new details and send them back to the client
			local result = mysql_query(handler, "SELECT suspect_name, birth, gender, ethnicy, cell, occupation, address, otherphoto, done_by FROM suspectDetails WHERE suspect_name='" .. details[1] .. "' LIMIT 1")
			
			-- backwards compatability for jasons code...
			local tableresult = { }
			tableresult[1] = { }
			tableresult[1][1] = mysql_result(result, 1, 1)
			tableresult[1][2] = mysql_result(result, 1, 2)
			tableresult[1][3] = mysql_result(result, 1, 3)
			tableresult[1][4] = mysql_result(result, 1, 4)
			tableresult[1][5] = mysql_result(result, 1, 5)
			tableresult[1][6] = mysql_result(result, 1, 6)
			tableresult[1][7] = mysql_result(result, 1, 7)
			tableresult[1][8] = mysql_result(result, 1, 8)
			tableresult[1][9] = mysql_result(result, 1, 9)
			mysql_free_result(result)
			
			triggerClientEvent(client, "onSaveSuspectDetailsClient", client, details[1] , tableresult)
		end
	else -- output error message
		outputChatBox("~~ Could not update since you changed the name of the suspect ~~", client, 255, 0 ,0 , true)
	end

end
addEvent("onUpdateSuspectDetails", true)
addEventHandler("onUpdateSuspectDetails", getRootElement(), addUpdateSuspectToDatabase)


-- function gets the details of the suspects name provided from the database
function getSuspectDetails(suspectName)

	-- get the details
	local result = mysql_query(handler, "SELECT suspect_name, birth, gender, ethnicy, cell, occupation, address, other, is_wanted, wanted_punishment, wanted_by, photo, done_by FROM suspectDetails WHERE suspect_name='" .. suspectName .. "' LIMIT 1")
	
	-- send the details to the client
	if(result) then
		if (mysql_num_rows(result)>0) then
			-- backwards compatability for jasons code...
			local tableresult = { }
			tableresult[1] = { }
			tableresult[1][1] = mysql_result(result, 1, 1)
			tableresult[1][2] = mysql_result(result, 1, 2)
			tableresult[1][3] = mysql_result(result, 1, 3)
			tableresult[1][4] = mysql_result(result, 1, 4)
			tableresult[1][5] = mysql_result(result, 1, 5)
			tableresult[1][6] = mysql_result(result, 1, 6)
			tableresult[1][7] = mysql_result(result, 1, 7)
			tableresult[1][8] = mysql_result(result, 1, 8)
			tableresult[1][9] = mysql_result(result, 1, 9)
			tableresult[1][10] = mysql_result(result, 1, 10)
			tableresult[1][11] = mysql_result(result, 1, 11)
			tableresult[1][12] = mysql_result(result, 1, 12)
			tableresult[1][13] = mysql_result(result, 1, 13)
			triggerClientEvent(client, "onSaveSuspectDetailsClient", client, suspectName, tableresult)
		else
			triggerClientEvent(client, "onSaveSuspectDetailsClient", client, suspectName, nil )
		end
		mysql_free_result(result)
	else
		triggerClientEvent(client, "onSaveSuspectDetailsClient", client, suspectName, nil )
	end

end
addEvent("onGetSuspectDetails", true)
addEventHandler("onGetSuspectDetails", getRootElement(), getSuspectDetails)

-- function gives the client all the player who are currently wanted
function getSuspectWhoAreWanted()
	
	-- get the details
	local result = mysql_query(handler, "SELECT suspect_name FROM suspectDetails WHERE is_wanted='1'")
	
	if (mysql_num_rows(result)>0) then
		-- backwards compatability for jasons code...
		local tableresult = { }
		tableresult[1] = { }
		tableresult[1][1] = mysql_result(result, 1, 1)
		triggerClientEvent(client, "onSaveSuspectWantedClient", client, tableresult)
	else
		triggerClientEvent(client, "onSaveSuspectWantedClient", client, nil )
	end
	mysql_free_result(result)
	
end
addEvent("onGetWantedSuspects", true)
addEventHandler("onGetWantedSuspects", getRootElement(), getSuspectWhoAreWanted)


-- function updates the suspects warrant details
function addUpdateSuspectWarrantToDatabase(warrantDetails)
	-- check to see if the suspect is already in the database
	local result = mysql_query(handler, "SELECT suspect_name FROM suspectDetails WHERE suspect_name='" .. warrantDetails[1] .. "'")
	local name = mysql_result(result, 1, 1)
	mysql_free_result(result)
	
	--if player is already in the database, updatethem
	if (name) then
		mysql_query(handler, "UPDATE suspectDetails SET is_wanted = '"..warrantDetails[2].."', wanted_reason = '"..warrantDetails[3].."', wanted_punishment = '"..warrantDetails[4].."', wanted_by = '"..warrantDetails[5].."' WHERE suspect_name = '"..warrantDetails[1].. "'")
	end

end
addEvent("onUpdateSuspectWarrantDetails", true)
addEventHandler("onUpdateSuspectWarrantDetails", getRootElement(), addUpdateSuspectWarrantToDatabase)


-- function saves a crime to the database
function saveCrime(details)
	if(string.len(details[12]) > 351) then
		outputChatBox("Too much information passed, unable to save crime - please add again.", client, 255, 0 ,0, true)
	else	
		-- insert the crimes
		mysql_query(handler, "INSERT INTO suspectCrime SET suspect_name='" .. details[1] .. "', time='" .. details[2] .. "', date='" .. details[3] .. "', officers='" .. details[4] .. "', ticket='" .. details[5] .. "', arrest='" .. details[6] .. "', fine='" .. details[7] .. "', ticket_price='" .. details[8] .. "', arrest_price='" .. details[9] .. "', fine_price='" .. details[10] .. "', illegal_items='" .. details[11] .. "', details='" .. details[12] .. "', done_by='" .. details[13] .. "'")
			
		outputChatBox("Crime added sucessfully.", client, 0, 255 ,0, true)
	end
end
addEvent("onSaveSuspectCrime", true)
addEventHandler("onSaveSuspectCrime", getRootElement(), saveCrime)


-- function returns all of the crimes for a suspect to the player
function getSuspectCrime(name)
	local result = mysql_query(handler, "SELECT id, suspect_name, time, date, officers, ticket, arrest, fine, ticket_price, arrest_price, fine_price, illegal_items, details, done_by FROM suspectCrime WHERE suspect_name='" .. name .. "' LIMIT 1")
	
	if (result) then
		if (mysql_num_rows(result)>0) then
			-- backwards compatability for jasons code...
			local tableresult = { }
			tableresult[1] = { }
			tableresult[1][1] = mysql_result(result, 1, 1)
			tableresult[1][2] = mysql_result(result, 1, 2)
			tableresult[1][3] = mysql_result(result, 1, 3)
			tableresult[1][4] = mysql_result(result, 1, 4)
			tableresult[1][5] = mysql_result(result, 1, 5)
			tableresult[1][6] = mysql_result(result, 1, 6)
			tableresult[1][7] = mysql_result(result, 1, 7)
			tableresult[1][8] = mysql_result(result, 1, 8)
			tableresult[1][9] = mysql_result(result, 1, 9)
			tableresult[1][10] = mysql_result(result, 1, 10)
			tableresult[1][11] = mysql_result(result, 1, 11)
			tableresult[1][12] = mysql_result(result, 1, 12)
			tableresult[1][13] = mysql_result(result, 1, 13)
			mysql_free_result(result)
			
			triggerClientEvent("onClientSaveSuspectCrimes", client, tableresult)
		end
		mysql_free_result(result)
	end

end
addEvent("onGetSuspectCrimes", true)
addEventHandler("onGetSuspectCrimes", getRootElement(), getSuspectCrime)


-- function deletes a crime from the database
function deleteCrime(crimeID)
	mysql_query(handler, "DELETE FROM suspectCrime WHERE id='" .. tonumber(crimeID) .. "'")
end
addEvent("onDeleteCrime", true)
addEventHandler("onDeleteCrime", getRootElement(), deleteCrime)



-- function check to see if the user is in the database when the client logs in
function clientLogIn(logInDetails)

	-- get the log in details for the client
	local result = mysql_query(handler, "SELECT user_name, password, high_command FROM mdcUsers WHERE user_name='" .. tostring(logInDetails[1]) .. "' LIMIT 1")
	
	if(result) then
		if(tostring(mysql_result(result, 1, 2)) == logInDetails[2])then--encrypt(logInDetails[2])) then
			-- tell the client that the log in details were corect
			-- backwards compatability for jasons code...
			local tableresult = { }
			tableresult[1] = { }
			tableresult[1][1] = mysql_result(result, 1, 1)
			tableresult[1][2] = mysql_result(result, 1, 2)
			tableresult[1][3] = mysql_result(result, 1, 3)
			mysql_free_result(result)
			triggerClientEvent("onCorrectLogInDetails", client, tableresult)
		else
			outputChatBox("Invalid Username or Password specified.", client, 255, 0, 0, true)
		end	
	else
		outputChatBox("Invalid username or password specified.", client, 255, 0, 0, true)
	end
end
addEvent("onClientLogInToMDC", true)
addEventHandler("onClientLogInToMDC", getRootElement(), clientLogIn)


-- function updates the users account details
function UpdateAccount(details)
	-- ADD encrypt TO DETAILS 2
	mysql_query(handler, "UPDATE mdcUsers SET password = '"..details[2].."', high_command = '"..details[3].."' WHERE user_name = '"..details[1].."'")
end
addEvent("onUpdateAccount", true)
addEventHandler("onUpdateAccount", getRootElement(), UpdateAccount)




-- function updates the users account details
function CreateAccount(details)
	local result = mysql_query(handler, "SELECT user_name FROM mdcUsers where user_name='" .. details[1] .. "'")
	
	if not (mysql_num_rows(result)>0) then
		mysql_query(handler, "INSERT INTO mdcUsers SET user_name='" .. details[1] .. "', password='" .. details[2] .. "', high_command='" .. details[3] .. "'")
		outputChatBox("Account: "..details[1].." with password "..details[2].." and high command limits: '"..details[3].."' sucessfully created.", client, 0, 255, 0, true)
	else
		outputChatBox("Unable to create the account: "..details[1].." since it already exists in the database.", client, 255, 0, 0, true)
	end
	mysql_free_result(result)
end
addEvent("onCreateAccount", true)
addEventHandler("onCreateAccount", getRootElement(), CreateAccount)



-- function removes the user from the database
function RemoveAccount(details)
	local result = mysql_query(handler, "SELECT user_name FROM mdcUsers where user_name='" .. details[1] .. "'")
	
	if not (mysql_num_rows(result)>0) then
		mysql_query(handler, "DELETE FROM mdcUsers WHERE user_name='" .. details[1] .. "'")
		outputChatBox("Account: "..details[1].." has been removed from the database.", client, 0, 255, 0, true)
	else
		outputChatBox("Unable to remove the account: "..details[1].." since it does not exist in the database.", client, 255, 0, 0, true)
	end
	mysql_free_result(result)
end
addEvent("onRemoveAccount", true)
addEventHandler("onRemoveAccount", getRootElement(), RemoveAccount)


function getAccountInfo(account)
	local result = mysql_query(handler, "SELECT user_name, password, high_command FROM mdcUsers WHERE user_name='" .. account .. "'")

	if(result) then
		-- backwards compatability for jasons code...
		local tableresult = { }
		tableresult[1] = { }
		tableresult[1][1] = mysql_result(result, 1, 1)
		tableresult[1][2] = mysql_result(result, 1, 2)
		tableresult[1][3] = mysql_result(result, 1, 3)
		mysql_free_result(result)
		triggerClientEvent("onSaveUserAccountDetails", client, tableresult)
	end

end
addEvent("onGetAccountInfo", true)
addEventHandler("onGetAccountInfo", getRootElement(), getAccountInfo)


-- function gets all of the active  user accounts and their high command limits, and sends it to the client
function getAllAccountInfo()
	local result = mysql_query(handler, "SELECT user_name, high_command FROM mdcUsers")

	if(result) then
		-- backwards compatability for jasons code...
		local tableresult = { }
		
		local count = 1
		for result, row in mysql_rows(result) do
			tableresult[count] = { }
			tableresult[count][1] = row[1]
			tableresult[count][2] = row[2]
			count = count + 1
		end
		mysql_free_result(result)
		triggerClientEvent("onSaveAllAccounts", client, tableresult)
	end

end
addEvent("onGetAllAccounts", true)
addEventHandler("onGetAllAccounts", getRootElement(), getAllAccountInfo)


function getAllSuspects()
	local result = mysql_query(handler, "SELECT suspect_name, done_by FROM suspectDetails")
	
	
	-- backwards compatability for jasons code...
	local tableresult = { }
		
	local count = 1
	for result, row in mysql_rows(result) do
		tableresult[count] = { }
		tableresult[count][1] = row[1]
		tableresult[count][2] = row[2]
		count = count + 1
	end
	mysql_free_result(result)
	triggerClientEvent("onSaveAllSuspects", client, tableresult)
end
addEvent("onGetAllSuspects", true)
addEventHandler("onGetAllSuspects", getRootElement(), getAllSuspects)



-- function gets all of the active  user accounts and their high command limits, and sends it to the client
function deleteSuspect(name)
	local result = mysql_query(handler, "SELECT suspect_name FROM suspectDetails WHERE suspect_name='" .. tostring(name) .. "'")
	
	if (mysql_num_rows(result)>0) then
		mysql_query(handler, "DELETE FROM suspectDetails WHERE suspect_name='" .. name .. "'")
		mysql_query(handler, "DELETE FROM suspectCrime WHERE suspect_name='" .. name .. "'")
		outputChatBox("Sucessfull deletion of suspect: "..name..", including all of their crimes.", client, 0, 255, 0, true)
	else
		outputChatBox("Could not delete suspect "..name.." since they do not exist in the database.", client, 255, 0, 0, true)
	end
	mysql_free_result(result)
end
addEvent("onDeleteSuspect", true)
addEventHandler("onDeleteSuspect", getRootElement(), deleteSuspect)
