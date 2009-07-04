job = 0
localPlayer = getLocalPlayer()

function playerSpawn()
	job = getElementData(source, "job")
end
addEventHandler("onClientPlayerSpawn", localPlayer, playerSpawn)

