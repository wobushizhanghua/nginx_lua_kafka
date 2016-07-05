local producer = require("producer")
local broker_mgr = require("broker_mgr")

local m = {}

function m.run()

	local req = producer.create_request("url", "helloworld")

	local broker = broker_mgr.get_broker("127.0.0.1", 9092)

	local bytes = broker:send(req)
	
	ngx.say("send bytes", bytes)

end

return m
