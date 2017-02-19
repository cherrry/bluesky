local config = require("rtc_config")

local init_rtc = {}

init_rtc.init = function ()
  local timer = tmr.create()
  timer:register(config.sync_frequency, tmr.ALARM_AUTO, function ()
    if wifi.sta.getip() then
      sntp.sync(
        config.sntp_server,
        function ()
          if config.sntp_callback then
            sec, usec = rtctime.get()
            config:sntp_callback(sec, usec)
          end
        end,
        nil, nil
      )
    end
  end)
  timer:start()
end

return init_rtc
