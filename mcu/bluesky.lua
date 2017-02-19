local config = require("bluesky_config")
local pms5003 = require("pms5003")

function api(endpoint)
  return config.base_url .. config.endpoints[endpoint] .. "?_" -- Avoid caching
end

local headers = "X-Api-Key: " .. config.api_key .. "\r\n"
local bluesky = {}
bluesky.put = function ()
  local ip = wifi.sta.getip()
  if ip == nil then
    print("Connection not ready yet")
    return
  end
  sec, usec = rtctime.get()
  if sec == 0 then
    print("RTC time not ready yet")
    return
  end
  local payload = cjson.encode({
    timestamp = sec,
    readings = pms5003.get()
  })
  print(payload)
  http.put(api("put"), headers, payload, function (status, resp)
    if status < 0 then
      print("HTTP request failed")
    else
      print(status, resp)
    end
  end)
end

return bluesky
