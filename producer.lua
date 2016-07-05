local request = require "request"

local m 

function m.create_request(topic, message)
	local req = request:new(request.ProduceRequest, 0, "client0")
	req:int16(0)	--no accept reply
	req:int32(2000)	--timeout
	req:string(topic)
	req:int32(1)	--partition
	req:message_set({"", message})
	return req
end

return m


