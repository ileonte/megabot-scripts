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
	local msg = string.format("%d new commit(s) on %s:\n", #commits, obj['repository']['name'])
	for i, com in ipairs(commits) do
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
	send_room_message(msg)
end

port = 12345
if os.getenv('HOOK_PORT') ~= nil then
	local p = tonumber(os.getenv('HOOK_PORT'))
	if p ~= nil then
		if p > 1024 and p < 65536 then
			port = p
		end
	end
end
ok, err = server_listen('test', port)
if (not ok) then
	dout(string.format("server_listen() failed: %s", err))
	os.exit(1)
end
