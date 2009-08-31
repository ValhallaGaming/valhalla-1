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
	"English",
	"Russian",
	"German"
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

function removeLanguages(player, language)
	local hasLanguage, slot = doesPlayerHaveLanguage(player, language)
	
	if (hasLanguage) then
		setElementData(player, "languages.lang" .. slot, 0)
		setElementData(player, "languages.lang" .. slot .. "skill", 0)
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

-- Bind Keys required
function bindKeys()
	local players = exports.pool:getPoolElementsByType("player")
	for k, arrayPlayer in ipairs(players) do
		if not(isKeyBound(arrayPlayer, "F6", "down", showLanguages)) then
			bindKey(arrayPlayer, "F6", "down", showLanguages)
		end
	end
end

function bindKeysOnJoin()
	bindKey(source, "F6", "down", showLanguages)
end
addEventHandler("onResourceStart", getResourceRootElement(), bindKeys)
addEventHandler("onPlayerJoin", getRootElement(), bindKeysOnJoin)

function showLanguages(player)
	local langs = { }
	local count = 1
	
	-- LANGUAGE 1
	local language1 = getElementData(player, "languages.lang1")
	local language1skill = getElementData(player, "languages.lang1skill")
	if (language1) and (language1>0) then
		langs[count] = { }
		langs[count][1] = language1
		langs[count][2] = language1skill
		count = count + 1
	end
	
	-- LANGUAGE 2
	local language2 = getElementData(player, "languages.lang2")
	local language2skill = getElementData(player, "languages.lang2skill")
	if (language2) and (language2>0) then
		langs[count] = { }
		langs[count][1] = language2
		langs[count][2] = language2skill
		count = count + 1
	end
	
	-- LANGUAGE 3
	local language3 = getElementData(player, "languages.lang3")
	local language3skill = getElementData(player, "languages.lang3skill")
	if (language3) and (language3>0) then
		langs[count] = { }
		langs[count][1] = language3
		langs[count][2] = language3skill
		count = count + 1
	end
	
	local currLang = getElementData(player, "languages.current")
	
	triggerClientEvent(player, "showLanguages", player, langs, currLang)
end

function useLanguage(lang)
	local hasLanguage, slot = doesPlayerHaveLanguage(source, lang)
	
	if (hasLanguage) then
		outputChatBox("You are now using " .. languages[lang] .. " as your language.", source, 255, 194, 14)
		setElementData(source, "languages.current", slot, false)
		showLanguages(source)
	end
end
addEvent("useLanguage", true)
addEventHandler("useLanguage", getRootElement(), useLanguage)