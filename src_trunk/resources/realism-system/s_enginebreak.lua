function engineBreak()
	local health = getElementHealth(source)
	local driver = getVehicleController(source)
	
	if (driver) and (health<=400) then
		local rand = math.random(1, 10)

		if (rand==1) then -- 10% chance
			setVehicleEngineState(source, false)
			setElementData(source, "engine", 0)
			exports.global:sendLocalDoAction(driver, "The engine breaks down.")
		end
	end
end
addEventHandler("onVehicleDamage", getRootElement(), engineBreak)