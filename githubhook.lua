require "JSON"

pushes = {}

function handle_room_config(config)
end

function handle_room_message(message)
end

function handle_room_presence(presence)
end

function handle_new_connection(info)
	pushes[info['client']] = ""
	return true
end

function handle_connection_data(info)
	pushes[info['client']] = pushes[info['client']] .. info['data']
end

function handle_closed_connection(info)
	local obj = JSON.Decode(pushes[info['client']])
	pushes[info['client']] = nil

	if type(obj['commits']) ~= 'table' then
		return
	end

	local commits = obj['commits']
	local msg = string.format("New commit(s) on:\n", obj['repository']['name'])
	for i = 1, #commits, 1 do
		local com = commits[i]
		local added = com['added']
		local removed = com['removed']
		local modified = com['modified']
		msg = msg .. string.format("%s: \"%s\" (%d modified, %d added, %d deleted)",
		                           com['author']['username'],
						   com['message'],
						   #modified,
						   #added,
						   #removed)
	end
end

ok, err = server_listen('test', 12345)
if (not ok) then
	dout(string.format("server_listen() failed: %s", err))
	quit()
end
