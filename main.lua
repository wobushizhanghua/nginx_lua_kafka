local producer = require("producer")
local m = {}

function m.run()
	local cjson = require "cjson"
	local producer = require "resty.kafka.producer"

	local broker_list = {
		{ host = "127.0.0.1", port = 9092 },
	}

	local ps = {}
	local i
	p = producer:new(broker_list)

	local message = "halo world"

	local offset, err = producer:send("request", nil, message)
	if not offset then
		ngx.say("send err:", err)
		return
	end

	ngx.say("offset: ", tostring(offset))
end

return m
