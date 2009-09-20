local sx, sy = guiGetScreenSize()
local localPlayer = getLocalPlayer()

local statusLabel = nil
local openReports = 0
local handledReports = 0
local unansweredReports = {}
local ownReports = {}

-- Admin Titles
function getAdminTitle(thePlayer)
	local adminLevel = tonumber(getElementData(thePlayer, "adminlevel")) or 0
	local text = ({ "Trial Admin", "Admin", "Super Admin", "Lead Admin", "Head Admin", "Owner" })[adminLevel] or "Player"
	
	local hiddenAdmin = getElementData(thePlayer, "hiddenadmin") or 0
	if (hiddenAdmin==1) then
		text = text .. " (Hidden)"
	end
	return text
end

function getAdminCount()
	local online, duty, lead, leadduty = 0, 0, 0, 0
	for key, value in ipairs(getElementsByType("player")) do
		if (isElement(value)) then
			local level = getElementData( value, "adminlevel" ) or 0
			if level >= 1 then
				online = online + 1
				
				local aod = getElementData( value, "adminduty" ) or 0
				if aod == 1 then
					duty = duty + 1
				end
				
				if level >= 4 then
					lead = lead + 1
					if aod == 1 then
						leadduty = leadduty + 1
					end
				end
			end
		end
	end
	return online, duty, lead, leadduty
end

-- update the labels
local function updateGUI()
	if statusLabel then
		local online, duty, lead, leadduty = getAdminCount()
		
		local reporttext = ""
		if #unansweredReports > 0 then
			reporttext = ": #" .. table.concat(unansweredReports, ", #")
		end
		
		local ownreporttext = ""
		if #ownReports > 0 then
			ownreporttext = ": #" .. table.concat(ownReports, ", #")
		end
		
		local onduty = "Off Duty"
		if getElementData( localPlayer, "adminduty" ) == 1 then
			onduty = "On Duty"
		end
		guiSetText( statusLabel, getAdminTitle( localPlayer ) .. " :: " .. onduty .. " :: " .. getElementData( localPlayer, "gameaccountusername" ) .. " :: " .. duty .. "/" .. online .. " Admins :: " .. leadduty .. "/" .. lead .. " Lead+ Admins :: " .. ( openReports - handledReports ) .. " unanswered reports" .. reporttext .. " :: " .. handledReports .. " handled reports" .. ownreporttext )
	end
end

-- create the gui
local function createGUI()
	if statusLabel then
		destroyElement(statusLabel)
		statusLabel = nil
	end
	
	local adminlevel = getElementData( localPlayer, "adminlevel" )
	
	if adminlevel then
		if adminlevel > 0 then
			statusLabel = guiCreateLabel( 5, sy - 20, sx - 10, 15, "", false )
			updateGUI()
		--guiCreateLabel ( float x, float y, float width, float height, string text, bool relative, [element parent = nil] )
		end
	end
end

addEventHandler( "onClientResourceStart", getResourceRootElement(), createGUI, false )
addEventHandler( "onClientElementDataChange", localPlayer, 
	function(n)
		if n == "adminlevel" or n == "hiddenadmin" then
			createGUI()
		end
	end, false
)

addEventHandler( "onClientElementDataChange", getRootElement(), 
	function(n)
		if getElementType(source) == "player" and ( n == "adminlevel" or n == "adminduty" ) then
			updateGUI()
		end
	end
)

addEvent( "updateReportsCount", true )
addEventHandler( "updateReportsCount", getLocalPlayer(),
	function( open, handled, unanswered, own )
		openReports = open
		handledReports = handled
		unansweredReports = unanswered
		ownReports = own or {}
		updateGUI()
	end, false
)

addEventHandler( "onClientPlayerQuit", getRootElement(), updateGUI )