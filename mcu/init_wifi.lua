local config = require("config")

local wifi_config = config.wifi

local init_wifi = {}

init_wifi.init = function ()
  wifi.setmode(wifi.STATION)
  wifi.sta.config(wifi_config)
end

return init_wifi
