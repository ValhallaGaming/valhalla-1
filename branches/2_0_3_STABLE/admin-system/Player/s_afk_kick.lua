function kickAFKPlayer()
	kickPlayer(source, getRootElement(), "Away From Keyboard")
end
addEvent("AFKKick", true)
addEventHandler("AFKKick", getRootElement(), kickAFKPlayer)