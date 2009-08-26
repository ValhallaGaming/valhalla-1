x = 0
y = 0
z = 0
timer = nil
function resourceStart(res)
	timer = setTimer(checkAFK, 300000, 0)
end
addEventHandler("onClientResourceStart", getResourceRootElement(), resourceStart)

function checkAFK()
	local px, py, pz = getElementPosition(getLocalPlayer())
	local adminlevel = getElementData(getLocalPlayer(), "adminlevel")
	local logged = getElementData(getLocalPlayer(), "loggedin")
	
	if (adminlevel==0 and logged==1) then
		if (px==x) and (py==y) and (pz==z) then
			triggerServerEvent("AFKKick", getLocalPlayer())
		else
			x = px
			y = py
			z = pz
		end
	end
end

function reset()
	killTimer(timer)
	timer = setTimer(checkAFK, 300000, 0)
end
addEventHandler("onClientCursorMove", getRootElement(), reset)