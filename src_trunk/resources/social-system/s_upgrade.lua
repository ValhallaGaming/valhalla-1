addEventHandler( "onResourceStart", getResourceRootElement( ),
	function( )
		-- upgrade existing friends list
		local result = mysql_query( handler, "SELECT id, friends FROM accounts WHERE friends != ''" )
		if result then
			for result, row in mysql_rows( result ) do
				local id = tonumber( row[1] )
				print( id )
				local friends = row[2]
				
				for i = 1, 100 do
					local friend = gettok(friends, i, 59)
					
					if friend then
						mysql_free_result( mysql_query( handler, "INSERT INTO friends VALUES (" .. id .. ", " .. friend .. ")" ) )
					else
						break
					end
				end
				mysql_free_result( mysql_query( handler, "UPDATE accounts SET friends = '' WHERE id = " .. id ) )
			end
			mysql_free_result( result )
		else
			outputDebugString( "Friends Upgrade: " .. mysql_error( handler ) )
		end
	end
)