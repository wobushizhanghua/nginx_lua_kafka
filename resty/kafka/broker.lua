local response = require "resty.kafka.response"

local to_int32 = response.to_int32
local setmetatable = setmetatable
local tcp = ngx.socket.tcp

local _M = { _VERSION = "0.01" }
local mt = { __index = _M }

function _M.new(self, host, port, socket_config)
    return setmetatable({
        host = host,
        port = port,
        config = socket_config,
	sock = nil
    }, mt)
end

function _M.connect()
	local sock, err = tcp()
    if not sock then
        return nil, err, true
    end

    sock:settimeout(self.config.socket_timeout)

    local ok, err = sock:connect(self.host, self.port)
    if not ok then
        ngx.log(ngx.ERR, "connect error:", err)
        return nil, err, true
    end

	self.sock = sock
end

function _M.send_receive(self, request)
    if not self.sock then
		self.connect()
    end

    sock = self.sock

    local bytes, err = sock:send(request:package())
    if not bytes then
        return nil, err, true
    end

    local data, err = sock:receive(4)
    if not data then
        if err == "timeout" then
            sock:close()
            return nil, err
        end
        return nil, err, true
    end

    local len = to_int32(data)

    local data, err = sock:receive(len)
    if not data then
        if err == "timeout" then
            sock:close()
            return nil, err
        end
        return nil, err, true
    end

    sock:setkeepalive(self.config.keepalive_timeout, self.config.keepalive_size)

    return response:new(data), nil, true
end

function _M.send(self, request)
    if not self.sock then
		self.connect()
    end

    sock = self.sock

    local bytes, err = sock:send(request:package())
    if not bytes then
        return nil, err, true
    end
end

return _M
