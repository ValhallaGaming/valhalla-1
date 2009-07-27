function pedDamage()
	if getElementData(source,"shopkeeper") then
		setElementData(source,"ignores",false,true)
		cancelEvent()
	end
end
addEventHandler("onClientPedDamage", getRootElement(), pedDamage)

function clickPed(button, state, absX, absY, wx, wy, wz, element)
	if element and getElementType(element) == "ped" and state=="down" and getElementData(element,"shopkeeper") then
		local x, y, z = getElementPosition(getLocalPlayer())

		if getDistanceBetweenPoints3D(x, y, z, wx, wy, wz)<=4 then
			if not getElementData(element,"ignores") then
				triggerServerEvent("onClickStoreKeeper", getLocalPlayer(), element)
			else
				-- not sure yet
			end
		end
	end
end
addEventHandler("onClientClick", getRootElement(), clickPed, true)
