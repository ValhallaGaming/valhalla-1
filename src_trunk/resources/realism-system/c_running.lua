local run = 0

addEventHandler( "onClientPreRender", getRootElement(), 
	function( slice )
		if getControlState( "sprint" ) then
			run = run + slice
			if run >= 12000 then
				exports.global:applyAnimation(getLocalPlayer(), "FAT", "idle_tired", 5000, true, false, true)
			end
		elseif run > 0 then
			run = math.max( 0, run - math.ceil( slice / 3 ) )
		end
	end
)