-- /look
function returnDescription (commandName, thePlayer)
		local posX, posY, posZ = getElementPosition( thePlayer )
        local objSphere = createColSphere( posX, posY, posZ, 20 )
		exports.pool:allocateElement(objSphere)
        local nearbyCharacters = getElementsWithinColShape( objSphere, "player" )
        destroyElement( objSphere )
		
		-- message to other players?
		
		local count = 0
		
		for index, nearbyCharacters in ipairs( nearbyCharacters ) do
			local name = getPlayerNick(value)
			local query = mysql_query(handler, "SELECT gender, skincolour, age, height, weight, description FROM characters WHERE charactername='" .. name .. "'")
			
			local genderValue = tonumber(mysql_result(query, 1, 1))
			local ethnicityValue = tonumber((mysql_result(query, 1, 2))
			local ageVale = tonumber(mysql_result(query, 1, 3))
			local height = tonumber(mysql_result(query, 1, 4))
			local weight = tonumber(mysql_result(query, 1, 5))
			local desc = tostring(mysql_result(query, 1, 6))
			
			if (ageVale>80) then
				local ageRange = tostring("61-80 years old")
			elseif (ageVale>60) then
				local ageRange = tostring("51-60 years old") 
			elseif (ageVale>50) then
				local ageRange = tostring("41-50 years old") 
			elseif (ageVale>40) then
				local ageRange = tostring("31-40 years old") 
			elseif (ageVale>30) then
				local ageRange = tostring("21-30 years old") 
			elseif (ageVale>20) then
				local ageRange = tostring("18-20 years old")
			end
			
			if (genderValue=0) then
				local gender = tostring("Male")
			elseif(genderValue=1)
				local gender = tostring("Female")
			else
				local gender = tostring("hermaphradite")
			end
			
			if (ethnicityValue=0) then
				local ethnicity = tostring("Black")
			elseif (ethnicityValue=1) then
				local ethnicity = tostring("White")
			elseif (ethnicityValue=2) then
				local ethnicity = tostring("Asian")
			else
				local ethnicity = tostring("Alien")
			end
			
			count = count + 1
						-- John Smith: Male, Black, 182cm, 89kg, Tall dark and handsome.
			outputChatBox("(("..name..")): "..gender..", "..ethnicity..", "..ageRange..", "..height.."cm, "..weight.."kg, "..description, thePlayer, 255, 51, 102)
		end
		
		if (count==0) then
			outputChatBox("No one is around.", thePlayer, 255, 51, 102)
		end
	end
end
addCommandHandler("look", returnDescription, false, false)


		

