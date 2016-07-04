local broker = require "resty.kafka.broker"

local m = {}

function m.get_broker(host, port, socketcfg)
	if m.broker then
		return m.broker
	end

	m.broker = broker:new(host, port, socketcfg)

	return m.broker
end

return m
