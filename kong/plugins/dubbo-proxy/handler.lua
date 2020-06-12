local cjson = require "cjson.safe"

local ngx = ngx
local kong = kong
local req_set_body_data   = ngx.req.set_body_data


local DubboProxyHandler = {
  PRIORITY = 1000,
  VERSION = "0.1.0",
}


function DubboProxyHandler:access(conf)
  local data = kong.request.get_raw_body()
  if not data then return end

  data = cjson.decode(data)
  if data then
    local serviceID = conf.interface_name
    if conf.group then
      serviceID = conf.group .. '/' .. serviceID
    end
    if conf.version then
      serviceID = serviceID .. ':' .. conf.version
    end

    local body = {
      application = conf.application_name,
      serviceID = serviceID,
      methodName = conf.method_name,
      paramTypes = conf.param_types,
      paramValues = data
    }

    req_set_body_data(cjson.encode(body))
  else
    return kong.response.exit(400, { message = "Bad Request" })
  end
end


return DubboProxyHandler
