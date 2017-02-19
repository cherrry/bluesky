local config = require("bluesky_config")

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
  http.put(api("put"), headers, "", function (status, resp)
    if status < 0 then
      print("HTTP request failed")
    else
      print(status, resp)
    end
  end)
end

return bluesky
