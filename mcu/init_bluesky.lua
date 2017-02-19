local bluesky = require("bluesky")

local init_bluesky = {}

init_bluesky.init = function ()
  local timer = tmr.create()
  timer:register(20 * 1000, tmr.ALARM_AUTO, function ()
    if wifi.sta.getip() then
      bluesky:put()
    end
  end)
  timer:start()
end

return init_bluesky
