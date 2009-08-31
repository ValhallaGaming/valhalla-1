local languages = {
	"English",
	"Russian",
	"German",
	}
	
local flags = {
	"gb",
	"ru",
	"de"
	}
	
-- Displaying the increase in skill
local sx, sy, text, count, addedEvent, alpha
local langInc = 0

function increaseInSkill(language)
	local localPlayer = getLocalPlayer()
	
	local x, y, z = getPedBonePosition(localPlayer, 6)
	sx, sy = getScreenFromWorldPosition(x, y, z+0.2, 100, false)
	
	langInc = langInc + 1
	
	text = "+" .. langInc .. " " .. languages[language] .. " (" .. string.gsub(getPlayerName(source), "_", " ") .. ")"
	
	count = 0
	alpha = 255
	if not (addedEvent) then
		addedEvent = true
		addEventHandler("onClientRender", getRootElement(), renderText)
	end
end
addEvent("increaseInSkill", true)
addEventHandler("increaseInSkill", getRootElement(), increaseInSkill)

function renderText()
	count = count + 1
	dxDrawText(text, sx-150, sy, sx+200, sy+50, tocolor(255, 255, 255, alpha), 1, "diploma", "center", "center")
	
	sy = sy - 3
	alpha = alpha - 6
	
	if (alpha<0) then alpha = 0 end
	
	if (count>50) then 
		removeEventHandler("onClientRender", getRootElement(), renderText)
		addedEvent = false
		langInc = 0
	end
end

tlanguages = nil
wLanguages = nil
localPlayer = getLocalPlayer()
function displayGUI(remotelanguages)
	if not (wLanguages) then
		local width, height = 600, 400
		local scrWidth, scrHeight = guiGetScreenSize()
		local x = scrWidth/2 - (width/2)
		local y = scrHeight/2 - (height/2)
		
		wLanguages = guiCreateWindow(x, y, width, height, "Languages: " .. string.gsub(getPlayerName(localPlayer), "_", " "), false)
		
		tlanguages = remotelanguages
		
		local offset = 0.06
		-- LANGUAGE 1
		if (tlanguages[1]~=nil) then
			local lang1 = tlanguages[1][1]
			local lang1skill = tlanguages[1][2]
			local imgLang1 = guiCreateStaticImage(0.05, 0.12+offset, 0.025, 0.025, ":social-system/images/flags/" .. flags[lang1] .. ".png", true, wLanguages)
			local lLang1Name = guiCreateLabel(0.1, 0.092+offset, 0.5, 0.1, languages[lang1], true, wLanguages)
			guiSetFont(lLang1Name, "default-bold-small")
			
			local pLang1Skill = guiCreateProgressBar(0.1, 0.14+offset, 0.6, 0.05, true, wLanguages)
			guiProgressBarSetProgress(pLang1Skill, lang1skill)
			
			local lLang1Skill = guiCreateLabel(0.73, 0.14+offset, 0.2, 0.1, lang1skill .. "/100", true, wLanguages)
			guiSetFont(lLang1Skill, "default-bold-small")
			
			local bUnlearnLang1 = guiCreateButton(0.83, 0.14+offset, 0.2, 0.05, "Un-learn", true, wLanguages)
			offset = offset + 0.3
		end
		
		-- LANGUAGE 2
		if (tlanguages[2]~=nil) then
			local lang2 = tlanguages[2][1]
			local lang2skill = tlanguages[2][2]
			local imgLang2 = guiCreateStaticImage(0.05, 0.1+offset, 0.025, 0.025, ":social-system/images/flags/" .. flags[lang2] .. ".png", true, wLanguages)
			local lLang2Name = guiCreateLabel(0.1, 0.092+offset, 0.5, 0.1, languages[lang2], true, wLanguages)
			guiSetFont(lLang2Name, "default-bold-small")
			
			local pLang2Skill = guiCreateProgressBar(0.1, 0.14+offset, 0.6, 0.05, true, wLanguages)
			guiProgressBarSetProgress(pLang2Skill, lang2skill)
			
			local lLang2Skill = guiCreateLabel(0.73, 0.14+offset, 0.2, 0.1, lang2skill .. "/100", true, wLanguages)
			guiSetFont(lLang2Skill, "default-bold-small")
			
			local bUnlearnLang2 = guiCreateButton(0.83, 0.14+offset, 0.2, 0.05, "Un-learn", true, wLanguages)
			offset = offset + 0.3
		end
		
		-- LANGUAGE 3
		if (tlanguages[3]~=nil) then
			local lang3 = tlanguages[3][1]
			local lang3skill = tlanguages[3][2] or 0
			local imgLang3 = guiCreateStaticImage(0.05, 0.1+offset, 0.025, 0.025, ":social-system/images/flags/" .. flags[lang3] .. ".png", true, wLanguages)
			local lLang3Name = guiCreateLabel(0.1, 0.092+offset, 0.5, 0.1, languages[lang3], true, wLanguages)
			guiSetFont(lLang3Name, "default-bold-small")
			
			local pLang3Skill = guiCreateProgressBar(0.1, 0.14+offset, 0.6, 0.05, true, wLanguages)
			guiProgressBarSetProgress(pLang3Skill, lang3skill)
			
			local lLang3Skill = guiCreateLabel(0.73, 0.14+offset, 0.2, 0.1, lang3skill .. "/100", true, wLanguages)
			guiSetFont(lLang3Skill, "default-bold-small")
			
			local bUnlearnLang3 = guiCreateButton(0.83, 0.14+offset, 0.2, 0.05, "Un-learn", true, wLanguages)
		end
		
		local bClose = guiCreateButton(0.05, 0.92, 0.9, 0.07, "Close", true, wLanguages)
	else
		hideGUI()
	end
end
addEvent("showLanguages", true)
addEventHandler("showLanguages", getLocalPlayer(), displayGUI)

function hideGUI()
	if (wLanguages) then
		destroyElement(wLanguages)
	end
	wLanguages = nil
end