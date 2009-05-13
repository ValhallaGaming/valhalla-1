local hover = false
local aircars = false
local jump = false

function cheatHover()
	local thePlayer = getLocalPlayer()
	
	if (hover) then -- Hover already enabled
		setWorldSpecialPropertyEnabled("hovercars", false)
		outputChatBox("Cheat 'Hover' Disabled!", 255, 194, 14)
		hover = false
	else
		setWorldSpecialPropertyEnabled("hovercars", true)
		outputChatBox("Cheat 'Hover' Enabled!", 255, 194, 14)
		hover = true
	end
end
addCommandHandler("cheathover", cheatHover, false)

function cheatAircars()
	local thePlayer = getLocalPlayer()
	
	if (aircars) then
		setWorldSpecialPropertyEnabled("aircars", false)
		outputChatBox("Cheat 'Air Cars' Disabled!", 255, 194, 14)
		aircars = false
	else
		setWorldSpecialPropertyEnabled("aircars", true)
		outputChatBox("Cheat 'Air Cars' Enabled!", 255, 194, 14)
		aircars = true
	end
end
addCommandHandler("cheatfly", cheatAircars, false)

function cheatJump()
	local thePlayer = getLocalPlayer()
	
	if (jump) then
		setWorldSpecialPropertyEnabled("extrajump", false)
		outputChatBox("Cheat 'Jump' Disabled!", 255, 194, 14)
		jump = false
	else
		setWorldSpecialPropertyEnabled("extrajump", true)
		outputChatBox("Cheat 'Jump' Enabled!", 255, 194, 14)
		jump = true
	end
end
addCommandHandler("cheatjump", cheatJump, false)