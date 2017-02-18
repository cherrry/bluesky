local config = require("wifi_config")

local init_wifi = {}

init_wifi.init = function ()
  if config.enable_ap then
    wifi.setmode(wifi.STATIONAP)
    wifi.ap.config(config.ap)
  else
    wifi.setmode(wifi.STATION)
  end
  wifi.sta.config(config.sta)
end

return init_wifi
