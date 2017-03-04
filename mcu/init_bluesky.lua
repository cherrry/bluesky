local bluesky = require("bluesky")
local config = require("config")
local pms5003 = require("pms5003")

local bluesky_config = config.bluesky

local init_bluesky = {}

init_bluesky.init = function ()
  pms5003:init()
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
