enumTypes = {
[1] = "chat",
[2] = "ads",
[3] = "adminchat",
[4] = "admincmds",
[5] = "moneytransfers",
[6] = "policechat",
[7] = "meactions",
[8] = "pms",
[9] = "vehicles"
}


function logMessage(message, type)
	local filename = nil
	local time = getRealTime()
	local partialname = enumTypes[type]
	
	if (partialname == nil) then return end
	
	filename = "/logs/" .. partialname .. ".log"
	local file = createFileIfNotExists(filename)
	local size = fileGetSize(file)
	fileSetPos(file, size)
	fileWrite(file, "[" .. time.hour .. ":" .. time.minute .. "] " .. message .. "\r\n")
	fileFlush(file)
	fileClose(file)
end

function createFileIfNotExists(filename)
	local file = fileOpen(filename)
	
	if not (file) then
		file = fileCreate(filename)
	end
	
	return file
end