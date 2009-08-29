-- ////////////////////////////////////
-- //			MYSQL				 //
-- ////////////////////////////////////		
sqlUsername = exports.mysql:getMySQLUsername()
sqlPassword = exports.mysql:getMySQLPassword()
sqlDB = exports.mysql:getMySQLDBName()
sqlHost = exports.mysql:getMySQLHost()
sqlPort = exports.mysql:getMySQLPort()

handler = mysql_connect(sqlHost, sqlUsername, sqlPassword, sqlDB, sqlPort)

local languages = {
	"English"
	}

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

function getLanguageName(language)
	return languages[language]
end

function increaseLanguageSkill(player, language)
	local chance = math.random(1, 1)

	if ( chance == 1 ) then
		local hasLanguage, slot = doesPlayerHaveLanguage(player, language)

		if (hasLanguage) then
			local currSkill = tonumber(getElementData(player, "languages.lang" .. slot .. "skill"))

			if (currSkill<100) then
				triggerClientEvent(player, "increaseInSkill", player, language)
				
				setElementData(player, "languages.lang" .. slot .. "skill", currSkill+1, false)
			end
		end
	end
end

function doesPlayerHaveLanguage(player, language)
	local lang1 = getElementData(player, "languages.lang1")
	local lang2 = getElementData(player, "languages.lang2")
	local lang3 = getElementData(player, "languages.lang3")
	
	if (lang1==language) then
		return true, 1
	elseif (lang2==language) then
		return true, 2
	elseif (lang3==language) then
		return true, 3
	else
		return false, nil
	end
end

function getSkillFromLanguage(player, language)
	local lang1 = getElementData(player, "languages.lang1")
	local lang2 = getElementData(player, "languages.lang2")
	local lang3 = getElementData(player, "languages.lang3")
	
	if (lang1==language) then
		return getElementData(player, "languages.lang1skill")
	elseif (lang2==language) then
		return getElementData(player, "languages.lang2skill")
	elseif (lang3==language) then
		return getElementData(player, "languages.lang3skill")
	else
		return 0
	end
end

function applyLanguage(player, message, language)
	local skill =  getSkillFromLanguage(player, language)

	local length = string.len(message)
	local percent = 100 - skill
	local replace = (percent/100) * length
	
	local i = 1

	while ( i < replace ) do
		local char = string.sub(message, i, i)
		if (char~="") and (char~=" ") then
			local replacechar

			if (string.byte(char)>=65 and string.byte(char)<=90) then -- upper char
				replacechar = string.char(math.random(65, 90))
			elseif (string.byte(char)>=97 and string.byte(char)<=122) then -- lower char
				replacechar = string.char(math.random(97, 122))
			end
			
			if (string.byte(char)>=65 and string.byte(char)<=90) or (string.byte(char)>=97 and string.byte(char)<=122) then
				message = string.gsub(message, tostring(char), replacechar, 1)
			end
		end
		i = i + 1
	end
	
	increaseLanguageSkill(player, language)
	return message
end