-- This is a fix for the global resource not starting up

function resStart(res)
	if (res==getThisResource()) then
		setTimer(loadGlobal, 1000, 1)
	end
end
addEventHandler("onResourceStart", getRootElement(), resStart)

function loadGlobal()
	restartResource(getResourceFromName("account-system"))
	restartResource(getResourceFromName("global"))
	setTimer(displayCredits, 1000, 1)
end

function displayCredits()
	exports.irc:sendMessage("-------------------------------------------------------------")
	exports.irc:sendMessage("--  VG MTA:RP Script V2 Loaded - By vG.MTA Scripting Team  --")
	exports.irc:sendMessage("--              www.valhallagaming.net                     --")
	exports.irc:sendMessage("-------------------------------------------------------------")
end