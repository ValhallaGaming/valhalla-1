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
	outputChatBox("/piss /wank /slapass /carfix /handsup /hailtaxi /scratch /fu", thePlayer, 255, 194, 14)
	outputChatBox("/strip1-2 /lightup /drink /beg /mourn /cheer1-3 /dance1-3 /crack 1-2", thePlayer, 255, 194, 14)
	outputChatBox("gsign1-5 /puke /rap1-3 /sit1-3 /smoke1-3 /smokelean /laugh /startrace", thePlayer, 255, 194, 14)
	outputChatBox("/carchat /daps1-2 /shove /ali /bitchslap /shocked /dive /angryface", thePlayer, 255, 194, 14)
	outputChatBox("/shockedface /huhface /chew /what", thePlayer, 255, 194, 14)
	outputChatBox("/stopanim or press the spacebar to cancel animations.", thePlayer, 255, 194, 14)
end
addCommandHandler("animlist", animationList, false, false)
addCommandHandler("animhelp", animationList, false, false)
addCommandHandler("anims", animationList, false, false)
addCommandHandler("animations", animationList, false, false)

-- /cover animtion -------------------------------------------------
function coverAnimation(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		exports.global:applyAnimation(thePlayer, "ped", "DUCK_cower", false, 1.0, false, false)
	end
end
addCommandHandler("cover", coverAnimation, false, false)

-- /cpr animtion -------------------------------------------------
function cprAnimation(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		exports.global:applyAnimation(thePlayer, "MEDIC", "CPR", false, 1.0, true, false)
	end
end
addCommandHandler("cpr", cprAnimation, false, false)

-- cop away Animation -------------------------------------------------------------------------
function copawayAnimation(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		exports.global:applyAnimation(thePlayer, "police", "coptraf_away", false, 1.0, 1.0, 0.0, true, false)
	end
end
addCommandHandler("copaway", copawayAnimation, false, false)

-- Cop come animation
function copcomeAnimation(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		exports.global:applyAnimation(thePlayer, "POLICE", "CopTraf_Come", false, 1.0, 1.0, 0.0, true, false)
	end
end
addCommandHandler("copcome", copcomeAnimation, false, false)

-- Cop Left Animation -------------------------------------------------------------------------
function copleftAnimation(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		exports.global:applyAnimation(thePlayer, "POLICE", "CopTraf_Left", false, 1.0, 1.0, 0.0, true, false)
	end
end
addCommandHandler("copleft", copleftAnimation, false, false)

-- Cop Stop Animation -------------------------------------------------------------------------
function copstopAnimation(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		exports.global:applyAnimation(thePlayer, "POLICE", "CopTraf_Stop", false, 1.0, 1.0, 0.0, true, false)
	end
end
addCommandHandler("copstop", copstopAnimation, false, false)

-- Wait Animation -------------------------------------------------------------------------
function pedWait(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
	exports.global:applyAnimation( thePlayer, "COP_AMBIENT", "Coplook_loop", false, 1.0, 1.0, 0.0, true, false)
	end
end
addCommandHandler ( "wait", pedWait, false, false )

-- Think Animation (/wait modifier) ---------------------------------------------------------------
function pedThink(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
	exports.global:applyAnimation( thePlayer, "COP_AMBIENT", "Coplook_think", false, 1.0, 1.0, 0.0, true, false)
	end
end
addCommandHandler ( "think", pedThink, false, false )

-- Shake Animation(/wait modifier) ---------------------------------------------------------------
function pedShake(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
	exports.global:applyAnimation( thePlayer, "COP_AMBIENT", "Coplook_shake", false, 1.0, 1.0, 0.0, true, false)
	end
end
addCommandHandler ( "shake", pedShake, false, false )

-- Lean Animation -------------------------------------------------------------------------
function pedLean(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
	exports.global:applyAnimation( thePlayer, "GANGS", "leanIDLE", false, 1.0, 1.0, 0.0, true, false)
	end
end
addCommandHandler ( "lean", pedLean, false, false )

-- /idle animtion -------------------------------------------------
function idle1Animation(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		exports.global:applyAnimation(thePlayer, "DEALER", "DEALER_IDLE_01", false, 1.0, 1.0, 0.0, true, false)
	end
end
addCommandHandler("idle", idle1Animation, false, false)

-- Piss Animation -------------------------------------------------------------------------
function pedPiss(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
	exports.global:applyAnimation( thePlayer, "PAULNMAC", "Piss_loop", false, 1.0, 1.0, 0.0, true, false)
	end
end
addCommandHandler ( "piss", pedPiss, false, false )

-- Wank Animation -------------------------------------------------------------------------
function pedWank(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		exports.global:applyAnimation( thePlayer, "PAULNMAC", "wank_loop", false, 1.0, 1.0, 0.0, true, false)
	end
end
addCommandHandler ( "wank", pedWank, false, false )

-- Slap Ass Animation -------------------------------------------------------------------------
function pedSlapAss(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
	exports.global:applyAnimation( thePlayer, "SWEET", "sweet_ass_slap", false, 1.0, 1.0, 0.0, false, false)
	setTimer(setPedAnimation, 4000, 1, thePlayer)
	end
end
addCommandHandler ( "slapass", pedSlapAss, false, false )

-- Car fix Animation -------------------------------------------------------------------------
function pedCarFix(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
	exports.global:applyAnimation( thePlayer, "CAR", "Fixn_Car_loop", false, 1.0, 1.0, 0.0, true, false)
	end
end
addCommandHandler ( "fixcar", pedCarFix, false, false )

-- Hands Up Animation -------------------------------------------------------------------------
function pedHandsup(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
	exports.global:applyAnimation( thePlayer, "SHOP", "SHP_Rob_HandsUp", false, 1.0, 1.0, 0.0, true, false)
	end
end
addCommandHandler ( "handsup", pedHandsup, false, false )

-- Hail Taxi -----------------------------------------------------------------------------------
function pedTaxiHail(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
	exports.global:applyAnimation( thePlayer, "MISC", "Hiker_Pose", false, 1.0, 1.0, 0.0, true, false)
	end
end
addCommandHandler ("hailtaxi", pedTaxiHail, false, false )

-- Scratch Balls Animation -------------------------------------------------------------------------
function pedScratch(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
	exports.global:applyAnimation( thePlayer, "MISC", "Scratchballs_01", false, 1.0, 1.0, 0.0, true, false)
	setTimer(setPedAnimation, 4000, 1, thePlayer)
	end
end
addCommandHandler ( "scratch", pedScratch, false, false )

-- F*** You Animation -------------------------------------------------------------------------
function pedFU(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
	exports.global:applyAnimation( thePlayer, "RIOT", "RIOT_FUKU", false, 1.0, 1.0, 0.0, false, false)
	setTimer(setPedAnimation, 4000, 1, thePlayer)
	end
end
addCommandHandler ( "fu", pedFU, false, false )

-- Strip Animation -------------------------------------------------------------------------
function pedStrip1( thePlayer )
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
	exports.global:applyAnimation( thePlayer, "STRIP", "strip_D", false, 1.0, 1.0, 0.0, true, false)
	end
end
addCommandHandler ( "strip1", pedStrip1, false, false )

function pedStrip2 ( thePlayer )
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
	exports.global:applyAnimation( thePlayer, "STRIP", "STR_Loop_C", false, 1.0, 1.0, 0.0, true, false)
	end
end
addCommandHandler ( "strip2", pedStrip2, false, false )

-- Light up Animation -------------------------------------------------------------------------
function pedLightup ()
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
	exports.global:applyAnimation( thePlayer, "SMOKING", "M_smk_in", false, 1.0, 1.0, 0.0, false, false)
	setTimer(setPedAnimation, 4000, 1, thePlayer)
	end
end
addCommandHandler ( "lightup", pedLightup, false, false )

-- Drink Animation -------------------------------------------------------------------------
function pedDrink( thePlayer )
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		exports.global:applyAnimation( thePlayer, "BAR", "dnk_stndM_loop", false, 1.0, 1.0, 0.0, true, false)
	end
end
addCommandHandler ( "drink", pedDrink, false, false )

-- Lay Animation -------------------------------------------------------------------------
function ped1Lay( thePlayer )
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		exports.global:applyAnimation( thePlayer, "BEACH", "Lay_Bac_Loop", false, 1.0, 1.0, 0.0, true, false)
	end
end
addCommandHandler ( "lay1", ped1Lay, false, false )

function ped2Lay( thePlayer )
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		exports.global:applyAnimation( thePlayer, "BEACH", "sitnwait_Loop_W", false, 1.0, 1.0, 0.0, true, false)
	end
end
addCommandHandler ( "lay2", ped2Lay, false, false )

-- beg Animation -------------------------------------------------------------------------
function begAnimation( thePlayer )
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		exports.global:applyAnimation( thePlayer, "SHOP", "SHP_Rob_React", false, 1.0, 1.0, 0.0, true, false)
		setTimer(setPedAnimation, 4000, 1, thePlayer)
	end
end
addCommandHandler ( "beg", begAnimation, false, false )

-- Mourn Animation -------------------------------------------------------------------------
function pedMourn( thePlayer )
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		exports.global:applyAnimation( thePlayer, "GRAVEYARD", "mrnM_loop", false, 1.0, 1.0, 0.0, true, false)
	end
end
addCommandHandler ( "mourn", pedMourn, false, false )

-- Cry Animation -------------------------------------------------------------------------
function pedCry( thePlayer )
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		exports.global:applyAnimation( thePlayer, "GRAVEYARD", "mrnF_loop", false, 1.0, 1.0, 0.0, true, false)
	end
end
addCommandHandler ( "cry", pedCry, false, false )

-- Cheer Amination -------------------------------------------------------------------------
function ped1Cheer(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
	exports.global:applyAnimation( thePlayer, "STRIP", "PUN_HOLLER", false, 1.0, 1.0, 0.0, true, false)
	end
end
addCommandHandler ( "cheer1", ped1Cheer, false, false )

function ped2Cheer(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
	exports.global:applyAnimation( thePlayer, "OTB", "wtchrace_win", false, 1.0, 1.0, 0.0, true, false)
	end
end
addCommandHandler ( "cheer2", ped2Cheer, false, false )

function ped3Cheer(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
	exports.global:applyAnimation( thePlayer, "RIOT", "RIOT_shout", false, 1.0, 1.0, 0.0, true, false)
	end
end
addCommandHandler ( "cheer3", ped3Cheer, false, false )

-- Dance Animation -------------------------------------------------------------------------
function dance1Animation(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
	exports.global:applyAnimation( thePlayer, "DANCING", "DAN_Right_A", false, 1.0, 1.0, 0.0, true, false)
	end
end
addCommandHandler ( "dance1", dance1Animation, false, false )

function dance2Animation(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
	exports.global:applyAnimation( thePlayer, "DANCING", "DAN_Down_A", false, 1.0, 1.0, 0.0, true, false)
	end
end
addCommandHandler ( "dance2", dance2Animation, false, false )

function dance3Animation(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
	exports.global:applyAnimation( thePlayer, "DANCING", "dnce_M_d", false, 1.0, 1.0, 0.0, true, false)
	end
end
addCommandHandler ( "dance3", dance3Animation, false, false )

-- Crack Animation -------------------------------------------------------------------------
function crack1Animation(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
	exports.global:applyAnimation( thePlayer, "CRACK", "crckidle2", false, 1.0, 1.0, 0.0, true, false)
	end
end
addCommandHandler ( "crack1", crack1Animation, false, false )

function crack2Animation(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
	exports.global:applyAnimation( thePlayer, "CRACK", "crckderh2", false, 1.0, 1.0, 0.0, true, false)
	end
end
addCommandHandler ( "crack2", crack2Animation, false, false )

-- /gsign animtion -------------------------------------------------
function gsign1Animation(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		exports.global:applyAnimation(thePlayer, "GHANDS", "gsign1", false, 1.0, 1.0, 0.0, false, false)
		setTimer(setPedAnimation, 4000, 1, thePlayer)
	end
end
addCommandHandler("gsign1", gsign1Animation, false, false)

function gsign2Animation(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		exports.global:applyAnimation(thePlayer, "GHANDS", "gsign2", false, 1.0, 1.0, 0.0, false, false)
		setTimer(setPedAnimation, 4000, 1, thePlayer)
	end
end
addCommandHandler("gsign2", gsign2Animation, false, false)

function gsign3Animation(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		exports.global:applyAnimation(thePlayer, "GHANDS", "gsign3", false, 1.0, 1.0, 0.0, false, false)
		setTimer(setPedAnimation, 4000, 1, thePlayer)
	end
end
addCommandHandler("gsign3", gsign3Animation, false, false)

function gsign4Animation(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		exports.global:applyAnimation(thePlayer, "GHANDS", "gsign4", false, 1.0, 1.0, 0.0, false, false)
		setTimer(setPedAnimation, 4000, 1, thePlayer)
	end
end
addCommandHandler("gsign4", gsign4Animation, false, false)

function gsign5Animation(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		exports.global:applyAnimation(thePlayer, "GHANDS", "gsign5", false, 1.0, 1.0, 0.0, false, false)
		setTimer(setPedAnimation, 4000, 1, thePlayer)
	end
end
addCommandHandler("gsign5", gsign5Animation, false, false)

-- /puke animtion -------------------------------------------------
function pukeAnimation(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		exports.global:applyAnimation(thePlayer, "FOOD", "EAT_Vomit_P", false, 1.0, 1.0, 0.0, false, false)
		setTimer(setPedAnimation, 8000, 1, thePlayer)
	end
end
addCommandHandler("puke", pukeAnimation, false, false)

-- /rap animtion -------------------------------------------------
function rap1Animation(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		exports.global:applyAnimation(thePlayer, "LOWRIDER", "RAP_A_Loop", false, 1.0, 1.0, 0.0, true, false)
	end
end
addCommandHandler("rap1", rap1Animation, false, false)

function rap2Animation(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		exports.global:applyAnimation(thePlayer, "LOWRIDER", "RAP_B_Loop", false, 1.0, 1.0, 0.0, true, false)
	end
end
addCommandHandler("rap2", rap2Animation, false, false)

function rap3Animation(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		exports.global:applyAnimation(thePlayer, "LOWRIDER", "RAP_C_Loop", false, 1.0, 1.0, 0.0, true, false)
	end
end
addCommandHandler("rap3", rap3Animation, false, false)

-- /aim animtion -------------------------------------------------
function aimAnimation(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		exports.global:applyAnimation(thePlayer, "SHOP", "ROB_Loop_Threat", false, 1.0, 1.0, 0.0, true, false)
	end
end
addCommandHandler("aim", aimAnimation, false, false)

-- /sit animtion -------------------------------------------------
function sit1Animation(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		exports.global:applyAnimation(thePlayer, "ped", "SEAT_idle", false, 1.0, 1.0, 0.0, true, false)
	end
end
addCommandHandler("sit1", sit1Animation, false, false)

function sit2Animation(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		exports.global:applyAnimation(thePlayer, "FOOD", "FF_Sit_Look", false, 1.0, 1.0, 0.0, true, false)
	end
end
addCommandHandler("sit2", sit2Animation, false, false)

function sit3Animation(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		exports.global:applyAnimation(thePlayer, "Attractors", "Stepsit_loop", false, 1.0, 1.0, 0.0, true, false)
	end
end
addCommandHandler("sit3", sit3Animation, false, false)

-- /smoke animtion -------------------------------------------------
function smoke1Animation(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		exports.global:applyAnimation(thePlayer, "GANGS", "smkcig_prtl", false, 1.0, 1.0, 0.0, true, false)
	end
end
addCommandHandler("smoke1", smoke1Animation, false, false)

function smoke2Animation(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		exports.global:applyAnimation(thePlayer, "SMOKING", "M_smkstnd_loop", false, 1.0, 1.0, 0.0, true, false)
	end
end
addCommandHandler("smoke2", smoke2Animation, false, false)

function smoke3Animation(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		exports.global:applyAnimation(thePlayer, "LOWRIDER", "M_smkstnd_loop", false, 1.0, 1.0, 0.0, true, false)
	end
end
addCommandHandler("smoke3", smoke3Animation, false, false)

-- /smokelean animtion -------------------------------------------------
function smokelean1Animation(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		exports.global:applyAnimation(thePlayer, "LOWRIDER", "M_smklean_loop", false, 1.0, 1.0, 0.0, true, false)
	end
end
addCommandHandler("smokelean", smokelean1Animation, false, false)

-- /drag animtion -------------------------------------------------
function smokedragAnimation(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		exports.global:applyAnimation(thePlayer, "SMOKING", "M_smk_drag", false, 1.0, 1.0, 0.0, false, false)
		setTimer(setPedAnimation, 4000, 1, thePlayer)
	end
end
addCommandHandler("drag", smokedragAnimation, false, false)

-- /laugh animtion -------------------------------------------------
function laughAnimation(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		exports.global:applyAnimation(thePlayer, "RAPPING", "Laugh_01", false, 1.0, 1.0, 0.0, false, false)
	end
end
addCommandHandler("laugh", laughAnimation, false, false)

-- /startrace animtion -------------------------------------------------
function startraceAnimation(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		exports.global:applyAnimation(thePlayer, "CAR", "flag_drop", false, 1.0, 1.0, 0.0, false, false)
	end
end
addCommandHandler("startrace", startraceAnimation, false, false)

-- /carchat animtion -------------------------------------------------
function carchatAnimation(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		exports.global:applyAnimation(thePlayer, "CAR_CHAT", "car_talkm_loop", false, 1.0, 1.0, 0.0, true, false)
	end
end
addCommandHandler("carchat", carchatAnimation, false, false)

-- /tired animtion -------------------------------------------------
function tiredAnimation(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		exports.global:applyAnimation(thePlayer, "FAT", "idle_tired", false, 1.0, 1.0, 0.0, true, false)
	end
end
addCommandHandler("tired", tiredAnimation, false, false)

-- /daps animtion -------------------------------------------------
function handshake1Animation(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		exports.global:applyAnimation(thePlayer, "GANGS", "hndshkfa", false, 1.0, 1.0, 0.0, false, false)
	end
end
addCommandHandler("daps1", handshake1Animation, false, false)

function handshake2Animation(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		exports.global:applyAnimation(thePlayer, "GANGS", "hndshkca", false, 1.0, 1.0, 0.0, false, false)
	end
end
addCommandHandler("daps2", handshake2Animation, false, false)

-- /shove animtion -------------------------------------------------
function shoveAnimation(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		exports.global:applyAnimation(thePlayer, "GANGS", "shake_car_SH", false, 1.0, 1.0, 0.0, false, false)
	end
end
addCommandHandler("shove", shoveAnimation, false, false)

-- /ali animtion -------------------------------------------------
function aliAnimation(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		exports.global:applyAnimation(thePlayer, "GYMANSIUM", "GYMshadowbox", false, 1.0, 1.0, 0.0, true, false)
	end
end
addCommandHandler("ali", aliAnimation, false, false)

-- /bitchslap animtion -------------------------------------------------
function bitchslapAnimation(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		exports.global:applyAnimation(thePlayer, "MISC", "bitchslap", false, 1.0, 1.0, 0.0, false, false)
	end
end
addCommandHandler("bitchslap", bitchslapAnimation, false, false)

-- /shocked animtion -------------------------------------------------
function shockedAnimation(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		exports.global:applyAnimation(thePlayer, "ON_LOOKERS", "panic_loop", false, 1.0, 1.0, 0.0, false, false)
	end
end
addCommandHandler("shocked", shockedAnimation, false, false)

-- /dive animtion -------------------------------------------------
function diveAnimation(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		exports.global:applyAnimation(thePlayer, "ped", "EV_dive", false, 1.0, 1.0, 0.0, false, false)
	end
end
addCommandHandler("dive", diveAnimation, false, false)

-- /face animtions -------------------------------------------------
function angryfaceAnimation(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		exports.global:applyAnimation(thePlayer, "ped", "faceanger", false, 1.0, 1.0, 0.0, true, false)
	end
end
addCommandHandler("angryface", angryfaceAnimation, false, false)

function shockedfaceAnimation(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		exports.global:applyAnimation(thePlayer, "ped", "facesup", false, 1.0, 1.0, 0.0, true, false)
	end
end
addCommandHandler("shockedface", shockedfaceAnimation, false, false)

function curiousfaceAnimation(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		exports.global:applyAnimation(thePlayer, "ped", "facecurios", false, 1.0, 1.0, 0.0, true, false)
	end
end
addCommandHandler("huhface", curiousfaceAnimation, false, false)

-- /chew animtions -------------------------------------------------
function chewAnimation(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		exports.global:applyAnimation(thePlayer, "ped", "facegum", false, 1.0, 1.0, 0.0, true, false)
	end
end
addCommandHandler("chew", chewAnimation, false, false)

-- /what Amination -------------------------------------------------------------------------
function whatAnimation(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
	exports.global:applyAnimation( thePlayer, "RIOT", "RIOT_ANGRY", false, 1.0, 1.0, 0.0, false, false)
	end
end
addCommandHandler ( "what", whatAnimation, false, false )