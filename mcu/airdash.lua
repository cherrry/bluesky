local config = require("airdash_config")

function api(endpoint)
  return config.base_url .. config.endpoints[endpoint]
end

local airdash = {}
airdash.ping = function ()
  local ip = wifi.sta.getip()
  if ip == nil then
    print("Connection not ready yet")
    return
  end

  http.get(api("ping"), "", function (status, resp)
    if status < 0 then
      print("HTTP request failed")
    else
      print(statsu, resp)
    end
  end)
end

return airdash
