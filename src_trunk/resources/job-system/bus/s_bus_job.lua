function payBusDriver()
	exports.global:givePlayerSafeMoney(source, 18)
end
addEvent("payBusDriver",true)
addEventHandler("payBusDriver", getRootElement(), payBusDriver)