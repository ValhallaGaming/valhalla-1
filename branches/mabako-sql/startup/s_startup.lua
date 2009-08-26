-- This is a fix for the global resource not starting up

function resStart()
	setTimer(loadGlobal, 1000, 1)
end
addEventHandler("onResourceStart", getResourceRootElement(), resStart)


function loadGlobal()
	restartResource(getResourceFromName("global"))
	setTimer(displayCredits, 1000, 1)
end

function displayCredits()
	exports.irc:sendMessage("-------------------------------------------------------------")
	exports.irc:sendMessage("--  VG MTA:RP Script V2 Loaded - By vG.MTA Scripting Team  --")
	exports.irc:sendMessage("--              www.valhallagaming.net                     --")
	exports.irc:sendMessage("-------------------------------------------------------------")
end