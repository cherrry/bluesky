local config = require("config")

local sntp_config = config.sntp

local init_sntp = {}

function sync()
  sntp.sync(
    sntp_config.server,
    function ()
      if sntp_config.callback then
        sec, usec = rtctime.get()
        sntp_config:callback(sec, usec)
      end
    end,
    nil, nil
  )
end

init_sntp.init = function ()
  local timer = tmr.create()
  timer:register(sntp_config.sync_frequency, tmr.ALARM_AUTO, function ()
    if wifi.sta.getip() then
      sync()
    end
  end)
  sync()
  timer:start()
end

return init_sntp
