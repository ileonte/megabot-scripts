require( "mbutils" )
local sprintf = string.format

function handle_room_config( config )
end

function handle_room_message( message )
	if ( string.match( message.body, ":at11%s*$" ) ) then
		send_room_message( sprintf( "DOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOM ! [1]\n\n[1] http://www.youtube.com/watch?v=DMSHvgaUWc8" ) )
	end
	if ( string.match( message.body, ":correct%s*$" ) ) then
		send_room_message( "https://www.youtube.com/watch?v=hou0lU8WMgo" )
	end
end

function handle_room_presence( presence )
end

