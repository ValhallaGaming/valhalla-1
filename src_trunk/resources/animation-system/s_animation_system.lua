-- Bind Keys required
function bindKeys()
	local players = exports.pool:getPoolElementsByType("player")
	for k, arrayPlayer in ipairs(players) do
		if not(isKeyBound(arrayPlayer, "space", "down", stopAnimation)) then
			bindKey(arrayPlayer, "space", "down", stopAnimation)
		end
	end
end

function bindKeysOnJoin()
	bindKey(source, "space", "down", stopAnimation)
end
addEventHandler("onResourceStart", getRootElement(), bindKeys)
addEventHandler("onPlayerJoin", getRootElement(), bindKeysOnJoin)

function stopAnimation(thePlayer)
	local forcedanimation = getElementData(thePlayer, "forcedanimation")
	local animation = getElementData(thePlayer, "animation")
	
	if (animation) then
		if not (forcedanimation) then
			exports.global:removeAnimation(thePlayer)
		end
	end
end
addCommandHandler("stopanim", stopAnimation, false, false)
addCommandHandler("stopani", stopAnimation, false, false)

function animationList(thePlayer)
	outputChatBox("~~~~~~~~~~~~~~~~~~~~~ Animation List ~~~~~~~~~~~~~~~~~~~~~", thePlayer, 255, 194, 14)
	outputChatBox("/cover /cpr /copaway /copcome /copleft /copstop /wait /think /shake", thePlayer, 255, 194, 14)
	outputChatBox("/lean /idle /piss /wank /strip1 /strip2 /cheer /sit /smoke /daps1 /daps2", thePlayer, 255, 194, 14)
	outputChatBox("/shove /dive /fallfront /fall", thePlayer, 255, 194, 14)
	outputChatBox("/stopanim or press the space bar to cancel animations.", thePlayer, 255, 194, 14)
end
addCommandHandler("animlist", animationList, false, false)
addCommandHandler("animhelp", animationList, false, false)
addCommandHandler("anims", animationList, false, false)
addCommandHandler("animations", animationList, false, false)

-- /cover animtion -------------------------------------------------
function coverAnimation(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		exports.global:applyAnimation(thePlayer, "ped", "duck_cower", 1, 2, 0, true, false, false)
	end
end
addCommandHandler("cover", coverAnimation, false, false)

-- /cpr animtion -------------------------------------------------
function cprAnimation(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
	--block, name, speed, blendSpeed, startTime, loop, updatePosition, forced
		exports.global:applyAnimation(thePlayer, "medic", "cpr", 1, 2, 0, false, false, false)
	end
end
addCommandHandler("cpr", cprAnimation, false, false)

-- cop away Animation -------------------------------------------------------------------------
function copawayAnimation(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		exports.global:applyAnimation(thePlayer, "police", "coptraf_away", 1, 2, 0, true, false, false)
	end
end
addCommandHandler("copaway", copawayAnimation, false, false)

-- Cop come animation
function copcomeAnimation(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		exports.global:applyAnimation(thePlayer, "police", "coptraf_come", 1, 2, 0, true, false, false)
	end
end
addCommandHandler("copcome", copcomeAnimation, false, false)

-- Cop Left Animation -------------------------------------------------------------------------
function copleftAnimation(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		exports.global:applyAnimation(thePlayer, "police", "coptraf_left", 1, 2, 0, true, false, false)
	end
end
addCommandHandler("copleft", copleftAnimation, false, false)

-- Cop Stop Animation -------------------------------------------------------------------------
function copstopAnimation(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		exports.global:applyAnimation(thePlayer, "police", "coptraf_stop", 1, 2, 0, true, false, false)
	end
end
addCommandHandler("copstop", copstopAnimation, false, false)

-- Wait Animation -------------------------------------------------------------------------
function pedWait(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		exports.global:applyAnimation(thePlayer, "COP_AMBIENT", "Coplook_loop", 1, 2, 0, true, false, false)
	end
end
addCommandHandler ( "wait", pedWait, false, false )

-- Think Animation (/wait modifier) ---------------------------------------------------------------
function pedThink(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		exports.global:applyAnimation(thePlayer, "COP_AMBIENT", "Coplook_think", 1, 2, 0, true, false, false)
	end
end
addCommandHandler ( "think", pedThink, false, false )

-- Shake Animation(/wait modifier) ---------------------------------------------------------------
function pedShake(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		exports.global:applyAnimation(thePlayer, "COP_AMBIENT", "Coplook_shake", 1, 2, 0, true, false, false)
	end
end
addCommandHandler ( "shake", pedShake, false, false )

-- Lean Animation -------------------------------------------------------------------------
function pedLean(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		exports.global:applyAnimation(thePlayer, "GANGS", "leanIDLE", 1, 2, 0, true, false, false)
	end
end
addCommandHandler ( "lean", pedLean, false, false )

-- /idle animtion -------------------------------------------------
function idle1Animation(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		exports.global:applyAnimation(thePlayer, "dealer", "dealer_idle_01", 1, 2, 0, true, false, false)
	end
end
addCommandHandler("idle", idle1Animation, false, false)

-- Piss Animation -------------------------------------------------------------------------
function pedPiss(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
	exports.global:applyAnimation(thePlayer, "paulnmac", "piss_loop", 1, 2, 0, true, false, false)
	end
end
addCommandHandler ( "piss", pedPiss, false, false )

-- Wank Animation -------------------------------------------------------------------------
function pedWank(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		exports.global:applyAnimation(thePlayer, "paulnmac", "wank_loop", 1, 2, 0, true, false, false)
	end
end
addCommandHandler ( "wank", pedWank, false, false )

-- Strip Animation -------------------------------------------------------------------------
function pedStrip1( thePlayer )
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		exports.global:applyAnimation(thePlayer, "STRIP", "strip_D", 1, 2, 0, true, false, false)
	end
end
addCommandHandler ( "strip1", pedStrip1, false, false )

function pedStrip2 ( thePlayer )
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		exports.global:applyAnimation(thePlayer, "STRIP", "STR_Loop_C", 1, 2, 0, true, false, false)
	end
end
addCommandHandler ( "strip2", pedStrip2, false, false )

-- Cheer Amination -------------------------------------------------------------------------
function ped1Cheer(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		exports.global:applyAnimation(thePlayer, "STRIP", "PUN_HOlLER", 1, 2, 0, true, false, false)
	end
end
addCommandHandler ( "cheer", ped1Cheer, false, false )

-- /sit animtion -------------------------------------------------
function sit1Animation(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		exports.global:applyAnimation(thePlayer, "PED", "SEAT_idle", 1, 2, 0, true, false, false)
	end
end
addCommandHandler("sit", sit1Animation, false, false)

-- /smoke animtion -------------------------------------------------
function smoke1Animation(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		exports.global:applyAnimation(thePlayer, "GANGS", "smkcig_prtl", false, 1.0, 1.0, 0.0, true, false)
	end
end
addCommandHandler("smoke", smoke1Animation, false, false)

-- /daps animtion -------------------------------------------------
function handshake1Animation(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		exports.global:applyAnimation(thePlayer, "GANGS", "hndshkfa", 1, 2, 0, false, false, false)
	end
end
addCommandHandler("daps1", handshake1Animation, false, false)

function handshake2Animation(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		exports.global:applyAnimation(thePlayer, "GANGS", "hndshkca", 1, 2, 0, false, false, false)
	end
end
addCommandHandler("daps2", handshake2Animation, false, false)

-- /shove animtion -------------------------------------------------
function shoveAnimation(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		exports.global:applyAnimation(thePlayer, "GANGS", "shake_carSH", 1, 2, 0, false, false, false)
	end
end
addCommandHandler("shove", shoveAnimation, false, false)

-- /dive animtion -------------------------------------------------
function diveAnimation(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		exports.global:applyAnimation(thePlayer, "ped", "EV_dive", 1, 2, 0, false, true, false)
	end
end
addCommandHandler("dive", diveAnimation, false, false)

-- /fallfront Amination -------------------------------------------------------------------------
function fallfrontAnimation(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		exports.global:applyAnimation(thePlayer, "ped", "FLOOR_hit_f", 0.3, 2, 0, true, false, false)
	end
end
addCommandHandler ( "fallfront", fallfrontAnimation, false, false )

-- /fall Amination -------------------------------------------------------------------------
function fallAnimation(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		exports.global:applyAnimation(thePlayer, "ped", "FLOOR_hit", 0.3, 2, 0, true, false, false)
	end
end
addCommandHandler ( "fall", fallAnimation, false, false )