local config = require("config")
local pms5003 = require("pms5003")

local bluesky_config = config.bluesky

function api(endpoint)
  return bluesky_config.base_url .. bluesky_config.endpoints[endpoint] .. "?_" -- Avoid caching
end

local headers = "X-Api-Key: " .. bluesky_config.api_key .. "\r\n"
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
  local readings = pms5003.get()
  local payload = {
    device_id = config.device_id,
    timestamp = sec
  }
  payload["pm1.0"] = readings.pm_1_0
  payload["pm2.5"] = readings.pm_2_5
  payload["pm10"] = readings.pm_10_0
  local payload_json = cjson.encode(payload)
  print(payload_json)
  http.put(api("put"), headers, payload_json, function (status, resp)
    if status < 0 then
      print("HTTP request failed")
    else
      print(status, resp)
    end
  end)
end

return bluesky
