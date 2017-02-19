local bluesky = require("bluesky")
local config = require("config")

local bluesky_config = config.bluesky

local init_bluesky = {}

init_bluesky.init = function ()
  local timer = tmr.create()
  timer:register(bluesky_config.push_frequency, tmr.ALARM_AUTO, function ()
    if wifi.sta.getip() then
      bluesky:put()
    end
  end)
  bluesky:put()
  timer:start()
end

return init_bluesky
