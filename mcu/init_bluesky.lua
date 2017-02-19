local bluesky = require("bluesky")
local config = require("bluesky_config")

local init_bluesky = {}

init_bluesky.init = function ()
  local timer = tmr.create()
  timer:register(config.push_frequency, tmr.ALARM_AUTO, function ()
    if wifi.sta.getip() then
      bluesky:put()
    end
  end)
  bluesky:put()
  timer:start()
end

return init_bluesky
