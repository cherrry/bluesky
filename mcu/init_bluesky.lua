local bluesky = require("bluesky")

local init_bluesky = {}

init_bluesky.init = function ()
  local ping_timer = tmr.create()
  ping_timer:register(20 * 1000, tmr.ALARM_AUTO, function ()
    print(wifi.sta.getip())
    bluesky:ping()
  end)
  ping_timer:start()
end

return init_bluesky
