function stopAnimation(thePlayer)
	local tazed = getElementData(thePlayer, "tazed")
	
	if (tazed) then
		if (tazed~=1) then
			setPedAnimation(thePlayer)
		end
	end
end
addCommandHandler("stopanim", stopAnimation, false, false)
addCommandHandler("stopani", stopAnimation, false, false)

function animationList(thePlayer)
	outputChatBox("/crack1-2 /dance1-5 /cpr /copaway /copcome /copleft /copstop", thePlayer, 255, 194, 14)
	outputChatBox("/mourn /lay1-2 /drink /lean /strip1-2 /fu /scratch /piss /drag", thePlayer, 255, 194, 14)
	outputChatBox("/hailtaxi /cheer1-2 /handsup /fixcar /slapass /wank /wait /think", thePlayer, 255, 194, 14)
	outputChatBox("/lightup /smokelean /smoke1-3 /sit1-4 /aim /rap1-3 /laugh", thePlayer, 255, 194, 14)
	outputChatBox("/cry /puke /beg /shake /gsign1-10 /cover /idle", thePlayer, 255, 194, 14)
	outputChatBox("/stopanim to cancel animations.", thePlayer, 255, 194, 14)
end
addCommandHandler("animlist", animationList, false, false)
addCommandHandler("animhelp", animationList, false, false)
addCommandHandler("anims", animationList, false, false)
addCommandHandler("animations", animationList, false, false)

-- /cover animtion -------------------------------------------------
function coverAnimation(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		setPedAnimation(thePlayer, "ped", "DUCK_cower", -1, false, false, true)
		setTimer(setPedAnimation, 4000, 1, thePlayer)
	end
end
addCommandHandler("cover", coverAnimation, false, false)

-- /cpr animtion -------------------------------------------------
function cprAnimation(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		setPedAnimation(thePlayer, "MEDIC", "CPR", -1, false, false, true)
		setTimer(setPedAnimation, 4000, 1, thePlayer)
	end
end
addCommandHandler("cpr", cprAnimation, false, false)

-- cop away Animation -------------------------------------------------------------------------
function copawayAnimation(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		setPedAnimation(thePlayer, "POLICE", "CopTraf_Away", -1, true, false, true)
	end
end
addCommandHandler("copaway", copawayAnimation, false, false)

-- Cop come animation
function copcomeAnimation(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		setPedAnimation(thePlayer, "POLICE", "CopTraf_Come", -1, true, false, true)
	end
end
addCommandHandler("copcome", copcomeAnimation, false, false)

-- Cop Left Animation -------------------------------------------------------------------------
function copleftAnimation(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		setPedAnimation(thePlayer, "POLICE", "CopTraf_Left", -1, true, false, true)
	end
end
addCommandHandler("copleft", copleftAnimation, false, false)

-- Cop Stop Animation -------------------------------------------------------------------------
function copstopAnimation(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		setPedAnimation(thePlayer, "POLICE", "CopTraf_Stop", -1, true, false, true)
	end
end
addCommandHandler("copstop", copstopAnimation, false, false)

-- Wait Animation -------------------------------------------------------------------------
function pedWait(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
	setPedAnimation ( thePlayer, "COP_AMBIENT", "Coplook_loop", -1, true, false, true)
	end
end
addCommandHandler ( "wait", pedWait, false, false )

-- Think Animation (/wait modifier) ---------------------------------------------------------------
function pedThink(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
	setPedAnimation ( thePlayer, "COP_AMBIENT", "Coplook_think", -1, false, false, true)
	end
end
addCommandHandler ( "think", pedThink, false, false )

-- Shake Animation(/wait modifier) ---------------------------------------------------------------
function pedShake(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
	setPedAnimation ( thePlayer, "COP_AMBIENT", "Coplook_shake", -1, false, false, true)
	end
end
addCommandHandler ( "shake", pedShake, false, false )

-- Lean Animation -------------------------------------------------------------------------
function pedLean(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
	setPedAnimation ( thePlayer, "GANGS", "leanIDLE", -1, false, false, true)
	end
end
addCommandHandler ( "lean", pedLean, false, false )

-- /idle animtion -------------------------------------------------
function idle1Animation(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		setPedAnimation(thePlayer, "DEALER", "DEALER_IDLE_01", -1, true, false, true)
	end
end
addCommandHandler("idle", idle1Animation, false, false)

-- Piss Animation -------------------------------------------------------------------------
function pedPiss(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
	setPedAnimation ( thePlayer, "PAULNMAC", "Piss_loop", -1, true, false, true)
	end
end
addCommandHandler ( "piss", pedPiss, false, false )

-- Wank Animation -------------------------------------------------------------------------
function pedWank(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		setPedAnimation ( thePlayer, "PAULNMAC", "wank_loop", -1, true, false, true)
	end
end
addCommandHandler ( "wank", pedWank, false, false )

-- Slap Ass Animation -------------------------------------------------------------------------
function pedSlapAss(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
	setPedAnimation ( thePlayer, "SWEET", "sweet_ass_slap", -1, false, false, true)
	setTimer(setPedAnimation, 4000, 1, thePlayer)
	end
end
addCommandHandler ( "slapass", pedSlapAss, false, false )

-- Car fix Animation -------------------------------------------------------------------------
function pedCarFix(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
	setPedAnimation ( thePlayer, "CAR", "Fixn_Car_loop", -1, true, false, true)
	end
end
addCommandHandler ( "fixcar", pedCarFix, false, false )

-- Hands Up Animation -------------------------------------------------------------------------
function pedHandsup(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
	setPedAnimation ( thePlayer, "ped", "handsup", -1, false, true, true)
	end
end
addCommandHandler ( "handsup", pedHandsup, false, false )

-- Hail Taxi -----------------------------------------------------------------------------------
function pedTaxiHail(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
	setPedAnimation ( thePlayer, "MISC", "Hiker_Pose", -1, false, false, true )
	end
end
addCommandHandler ("hailtaxi", pedTaxiHail, false, false )

-- Scratch Balls Animation -------------------------------------------------------------------------
function pedScratch(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
	setPedAnimation ( thePlayer, "MISC", "Scratchballs_01", -1, false, false, true)
	setTimer(setPedAnimation, 4000, 1, thePlayer)
	end
end
addCommandHandler ( "scratch", pedScratch, false, false )

-- F*** You Animation -------------------------------------------------------------------------
function pedFU(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
	setPedAnimation ( thePlayer, "ped", "fucku", -1, false, false, true)
	setTimer(setPedAnimation, 4000, 1, thePlayer)
	end
end
addCommandHandler ( "fu", pedFU, false, false )

-- Strip Animation -------------------------------------------------------------------------
function pedStrip1( thePlayer )
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
	setPedAnimation ( thePlayer, "STRIP", "strip_D", -1, true, false, true)
	end
end
addCommandHandler ( "strip1", pedStrip1, false, false )

function pedStrip2 ( thePlayer )
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
	setPedAnimation ( thePlayer, "STRIP", "STR_Loop_C", -1, true, false, true)
	end
end
addCommandHandler ( "strip2", pedStrip2, false, false )

-- Light up Animation -------------------------------------------------------------------------
function pedLightup ()
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
	setPedAnimation ( thePlayer, "SMOKING", "M_smk_in", -1, false, false, true)
	setTimer(setPedAnimation, 4000, 1, thePlayer)
	end
end
addCommandHandler ( "lightup", pedLightup, false, false )

-- Drink Animation -------------------------------------------------------------------------
function pedDrink( thePlayer )
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		setPedAnimation ( thePlayer, "BAR", "dnk_stndM_loop", -1, true, false, true)
	end
end
addCommandHandler ( "drink", pedDrink, false, false )

-- Lay Animation -------------------------------------------------------------------------
function ped1Lay( thePlayer )
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		setPedAnimation ( thePlayer, "SUNBATHE", "ParkSit_M_IdleA", -1, true, false, true)
	end
end
addCommandHandler ( "lay1", ped1Lay, false, false )

function ped2Lay( thePlayer )
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		setPedAnimation ( thePlayer, "INT_HOUSE", "BED_Loop_R", -1, true, false, true)
	end
end
addCommandHandler ( "lay2", ped2Lay, false, false )

-- beg Animation -------------------------------------------------------------------------
function begAnimation( thePlayer )
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		setPedAnimation ( thePlayer, "SHOP", "SHP_Rob_React", -1, false, false, true)
		setTimer(setPedAnimation, 4000, 1, thePlayer)
	end
end
addCommandHandler ( "beg", begAnimation, false, false )

-- Mourn Animation -------------------------------------------------------------------------
function pedMourn( thePlayer )
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		setPedAnimation ( thePlayer, "GRAVEYARD", "mrnM_loop", -1, false, false, true)
	end
end
addCommandHandler ( "mourn", pedMourn, false, false )

-- Cry Animation -------------------------------------------------------------------------
function pedCry( thePlayer )
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		setPedAnimation ( thePlayer, "GRAVEYARD", "mrnF_loop", -1, true, false, true)
	end
end
addCommandHandler ( "cry", pedCry, false, false )
-- Cheer Amination -------------------------------------------------------------------------
function ped1Cheer(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
	setPedAnimation ( thePlayer, "STRIP", "PUN_HOLLER", -1, true, false, true)
	end
end
addCommandHandler ( "cheer1", ped1Cheer, false, false )

function ped2Cheer(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
	setPedAnimation ( thePlayer, "OTB", "wtchrace_win", -1, true, false, true)
	end
end
addCommandHandler ( "cheer2", ped2Cheer, false, false )

-- Dance Animation -------------------------------------------------------------------------
function dance1Animation(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
	setPedAnimation ( thePlayer, "DANCING", "dnce_M_a", -1, true, false, true)
	end
end
addCommandHandler ( "dance1", dance1Animation, false, false )

function dance2Animation(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
	setPedAnimation ( thePlayer, "DANCING", "dnce_M_b", -1, true, false, true)
	end
end
addCommandHandler ( "dance2", dance2Animation, false, false )

function dance3Animation(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
	setPedAnimation ( thePlayer, "DANCING", "bd_clap1", -1, true, false, true)
	end
end
addCommandHandler ( "dance3", dance3Animation, false, false )

function dance4Animation(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
	setPedAnimation ( thePlayer, "DANCING", "dnce_M_d", -1, true, false, true)
	end
end
addCommandHandler ( "dance4", dance4Animation, false, false )

function dance5Animation(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
	setPedAnimation ( thePlayer, "DANCING", "dnce_M_e", -1, true, false, true)
	end
end
addCommandHandler ( "dance5", dance5Animation, false, false )

-- Crack Animation -------------------------------------------------------------------------
function crack1Animation(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
	setPedAnimation ( thePlayer, "CRACK", "crckidle2", -1, true, false, true)
	end
end
addCommandHandler ( "crack1", crack1Animation, false, false )

function crack2Animation(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
	setPedAnimation ( thePlayer, "CRACK", "crckidle1", -1, true, false, true)
	end
end
addCommandHandler ( "crack2", crack2Animation, false, false )

-- /gsign animtion -------------------------------------------------
function gsign1Animation(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		setPedAnimation(thePlayer, "GHANDS", "gsign1", -1, false, false, true)
		setTimer(setPedAnimation, 4000, 1, thePlayer)
	end
end
addCommandHandler("gsign1", gsign1Animation, false, false)

function gsign2Animation(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		setPedAnimation(thePlayer, "GHANDS", "gsign2", -1, false, false, true)
		setTimer(setPedAnimation, 4000, 1, thePlayer)
	end
end
addCommandHandler("gsign2", gsign2Animation, false, false)

function gsign3Animation(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		setPedAnimation(thePlayer, "GHANDS", "gsign3", -1, false, false, true)
		setTimer(setPedAnimation, 4000, 1, thePlayer)
	end
end
addCommandHandler("gsign3", gsign3Animation, false, false)

function gsign4Animation(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		setPedAnimation(thePlayer, "GHANDS", "gsign4", -1, false, false, true)
		setTimer(setPedAnimation, 4000, 1, thePlayer)
	end
end
addCommandHandler("gsign4", gsign4Animation, false, false)

function gsign5Animation(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		setPedAnimation(thePlayer, "GHANDS", "gsign5", -1, false, false, true)
		setTimer(setPedAnimation, 4000, 1, thePlayer)
	end
end
addCommandHandler("gsign5", gsign5Animation, false, false)

-- /puke animtion -------------------------------------------------
function pukeAnimation(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		setPedAnimation(thePlayer, "FOOD", "EAT_Vomit_P", -1, false, false, true)
		setTimer(setPedAnimation, 8000, 1, thePlayer)
	end
end
addCommandHandler("puke", pukeAnimation, false, false)

-- /rap animtion -------------------------------------------------
function rap1Animation(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		setPedAnimation(thePlayer, "LOWRIDER", "RAP_A_Loop", -1, true, false, true)
	end
end
addCommandHandler("rap1", rap1Animation, false, false)

function rap2Animation(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		setPedAnimation(thePlayer, "LOWRIDER", "RAP_B_Loop", -1, true, false, true)
	end
end
addCommandHandler("rap2", rap2Animation, false, false)

function rap3Animation(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		setPedAnimation(thePlayer, "LOWRIDER", "RAP_C_Loop", -1, true, false, true)
	end
end
addCommandHandler("rap3", rap3Animation, false, false)

-- /aim animtion -------------------------------------------------
function aimAnimation(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		setPedAnimation(thePlayer, "SHOP", "ROB_Loop_Threat", -1, true, false, true)
	end
end
addCommandHandler("aim", aimAnimation, false, false)

-- /sit animtion -------------------------------------------------
function sit1Animation(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		setPedAnimation(thePlayer, "ped", "SEAT_idle", -1, true, false, true)
	end
end
addCommandHandler("sit1", sit1Animation, false, false)

function sit2Animation(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		setPedAnimation(thePlayer, "MISC", "SEAT_LR", -1, true, false, true)
	end
end
addCommandHandler("sit2", sit2Animation, false, false)

function sit3Animation(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		setPedAnimation(thePlayer, "Attractors", "Stepsit_loop", -1, true, false, true)
	end
end
addCommandHandler("sit3", sit3Animation, false, false)

function sit4Animation(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		setPedAnimation(thePlayer, "INT_OFFICE", "OFF_Sit_Bored_Loop", -1, true, false, true)
	end
end
addCommandHandler("sit4", sit4Animation, false, false)

-- /smoke animtion -------------------------------------------------
function smoke1Animation(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		setPedAnimation(thePlayer, "GANGS", "smkcig_prtl", -1, true, false, true)
	end
end
addCommandHandler("smoke1", smoke1Animation, false, false)

function smoke2Animation(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		setPedAnimation(thePlayer, "SMOKING", "M_smkstnd_loop", -1, true, false, true)
	end
end
addCommandHandler("smoke2", smoke2Animation, false, false)

function smoke3Animation(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		setPedAnimation(thePlayer, "LOWRIDER", "M_smkstnd_loop", -1, true, false, true)
	end
end
addCommandHandler("smoke3", smoke3Animation, false, false)

-- /smokelean animtion -------------------------------------------------
function smokelean1Animation(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		setPedAnimation(thePlayer, "LOWRIDER", "M_smklean_loop", -1, true, false, true)
	end
end
addCommandHandler("smokelean", smokelean1Animation, false, false)

-- /drag animtion -------------------------------------------------
function smokedragAnimation(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		setPedAnimation(thePlayer, "SMOKING", "M_smk_drag", -1, false, false, true)
		setTimer(setPedAnimation, 4000, 1, thePlayer)
	end
end
addCommandHandler("drag", smokedragAnimation, false, false)

-- /laugh animtion -------------------------------------------------
function laughAnimation(thePlayer)
	local logged = getElementData(thePlayer, "loggedin")
	
	if (logged==1) then
		setPedAnimation(thePlayer, "RAPPING", "Laugh_01", -1, true, false, true)
	end
end
addCommandHandler("laugh", laughAnimation, false, false)
