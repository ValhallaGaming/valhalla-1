local run = 0
local down = 0

addEventHandler( "onClientPreRender", getRootElement(), 
	function( slice )
		if getControlState( "sprint" ) or down > 0 then
			run = run + slice
			if run >= 20000 then
				exports.global:applyAnimation(getLocalPlayer(), "FAT", "idle_tired", 5000, true, false, true)
			end
			if not getControlState( "sprint" ) then
				down = math.max( 0, down - slice )
			else
				down = 500
			end
		else
			if run > 0 then
				run = math.max( 0, run - math.ceil( slice / 3 ) )
			end
		end
	end
)