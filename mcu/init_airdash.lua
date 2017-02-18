local airdash = require("airdash")

local init_airdash = {}

init_airdash.init = function ()
  local ping_timer = tmr.create()
  ping_timer:register(20 * 1000, tmr.ALARM_AUTO, function ()
    print(wifi.sta.getip())
    airdash:ping()
  end)
  ping_timer:start()
end

return init_airdash
