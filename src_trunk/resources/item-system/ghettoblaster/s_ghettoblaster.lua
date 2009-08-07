function updateItemValue(item, newvalue)
	setElementData(item, "itemValue", newvalue)
	mysql_free_result(mysql_query(handler, "UPDATE worlditems SET itemvalue='" .. newvalue .. "' WHERE id=" .. getElementData(item, "id"))) 
end

function toggleGhettoblaster(item)
	local state = tonumber(getElementData(item, "itemValue"))
	if state > 0 then
		exports.global:sendLocalMeAction(source, "turns the Ghettoblaster off.")
	else
		exports.global:sendLocalMeAction(source, "turns the Ghettoblaster on.")
	end
	updateItemValue(item, -state)
end

addEvent("toggleGhettoblaster", true)
addEventHandler("toggleGhettoblaster", getRootElement(), toggleGhettoblaster)

function changeTrack(item, step)
	local current = getElementData(item, "itemValue")
	if current > 0 then
		current = current + step
		if current > #tracks then
			current = 1
		elseif current < 1 then
			current = #tracks
		end
		updateItemValue(item, current)
		exports.global:sendLocalMeAction(source, "retunes the Ghettoblaster.")
	end
end
addEvent("changeGhettoblasterTrack", true)
addEventHandler("changeGhettoblasterTrack", getRootElement(), changeTrack)