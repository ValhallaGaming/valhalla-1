-- waves
function setInitialWaves(res)
	if (res==getThisResource()) then
		local hour, mins = getTime()
		
		if (hour%2==0) then -- even hour
			setWaveHeight(1)
		else
			setWaveHeight(0)
		end
	end
end
addEventHandler("onClientResourceStart", getRootElement(), setInitialWaves)

function updateWaves()
	local hour, mins = getTime()

	if (hour%2==0) then -- even hour
		setWaveHeight(1)
	else
		setWaveHeight(0)
	end
end
addEvent("updateWaves", false)
addEventHandler("updateWaves", getRootElement(), updateWaves)