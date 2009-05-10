-- ADAMA
local adamaobject = createObject(2052, 1583.53125, 1776.1925048828, 9.8203125)
local adamashape = createColSphere(1583.53125, 1776.1925048828, 9.8203125, 5)
exports.pool:allocateElement(adamaobject)
exports.pool:allocateElement(adamashape)

function giveAdamaAchievement(hitElement, matchingDimension)
	if (matchingDimension) and (getElementType(hitElement)=="player") then
		exports.global:givePlayerAchievement(hitElement, 23)
	end
end
addEventHandler("onColShapeHit", adamashape, giveAdamaAchievement)

-- JACK
local jackobject = createObject(1484, 1685.2446289063, 2050.5109863281, 10.46875)
local jackshape = createColSphere(1685.2446289063, 2050.5109863281, 10.46875, 5)
exports.pool:allocateElement(jackobject)
exports.pool:allocateElement(jackshape)

function giveJackAchievement(hitElement, matchingDimension)
	if (matchingDimension) and (getElementType(hitElement)=="player") then
		exports.global:givePlayerAchievement(hitElement, 24)
	end
end
addEventHandler("onColShapeHit", jackshape, giveJackAchievement)

-- BEN
local benobject = createObject(17060, 945.12390136719, 2432.2255859375, 9.944062232971)
local benshape = createColSphere(942.28002929688, 2434.1198730469, 13.959688186646, 10)
exports.pool:allocateElement(benobject)
exports.pool:allocateElement(benshape)

function giveBenAchievement(hitElement, matchingDimension)
	if (matchingDimension) and (getElementType(hitElement)=="player") then
		exports.global:givePlayerAchievement(hitElement, 25)
	end
end
addEventHandler("onColShapeHit", benshape, giveBenAchievement)
