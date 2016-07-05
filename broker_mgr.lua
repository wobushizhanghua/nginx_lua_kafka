local broker = require "resty.kafka.broker"

local m = {}

function m.get_broker(host, port)
	if m.broker then
		return m.broker
	end

    local socket_config = {
        socket_timeout = 3000,
        keepalive_timeout = 60 * 1000,   -- 10 min
        keepalive_size = 2,
    }

	m.broker = broker:new(host, port, socketcfg)

	return m.broker
end

return m
