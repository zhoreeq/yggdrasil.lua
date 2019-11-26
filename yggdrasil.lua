local json = require("dkjson")
local socket = require("socket")
socket.unix = require("socket.unix")

local SOCK_PATH = "/var/run/yggdrasil.sock"

local control = {}

function control:request(command, args)
	if args == nil then	args = {} end
	args["request"] = command
	local data = json.encode(args)

	local c = assert(socket.unix())
	if c:connect(SOCK_PATH) == nil then return nil end
	if c:send(data) == nil then return nil end

	local resp = c:receive("*a")
	return json.decode(resp)
end

function control:get_DHT()
	return control:request("getDHT")
end

function control:get_peers()
	return control:request("getPeers")
end

function control:add_peer(uri)
	return control:request("addPeer", {uri = uri})
end

function control:remove_peer(port)
	return control:request("removePeer", {port = port})
end

function control:get_switch_peers()
	return control:request("getSwitchPeers")
end

function control:get_self()
	return control:request("getSelf")
end

function control:get_sessions()
	return control:request("getSessions")
end

function control:get_tun_tap()
	return control:request("getTunTap")
end

function control:get_allowed_encryption_public_keys()
	return control:request("getAllowedEncryptionPublicKeys")
end

function control:add_allowed_encryption_public_key(box_pub_key)
	return control:request("addAllowedEncryptionPublicKey",
	{box_pub_key = box_pub_key})
end

function control:remove_allowed_encryption_public_key(box_pub_key)
	return control:request("removeAllowedEncryptionPublicKey",
	{box_pub_key = box_pub_key})
end

function control:get_multicast_interfaces()
	return control:request("getMulticastInterfaces")
end

function control:get_routes()
	return control:request("getRoutes")
end

function control:add_route(subnet, box_pub_key)
	return control:request("addRoute", 
	{subnet = subnet, box_pub_key = box_pub_key})
end

function control:remove_route(subnet, box_pub_key)
	return control:request("removeRoute", 
	{subnet = subnet, box_pub_key = box_pub_key})
end

function control:get_source_subnets()
	return control:request("getSourceSubnets")
end

function control:add_source_subnet(subnet)
	return control:request("addSourceSubnet", {subnet = subnet})
end

function control:remove_source_subnet(subnet)
	return control:request("removeSourceSubnet", {subnet = subnet})
end

function control:dht_ping(box_pub_key, coords, target)
	args = {box_pub_key = box_pub_key, coords = coords}
	if target ~= nil then
		args["target"] = target
	end
	return control:request("dhtPing", args)
end

function control:get_node_info(box_pub_key, coords)
	return control:request("getNodeInfo", 
	{box_pub_key = box_pub_key, coords = coords})
end

return control
