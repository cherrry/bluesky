--[[
RTC/SNTP config file.
Save this file as `rtc_config.lua`
--]]

local config = {}

config.sync_frequency = 30 * 1000
config.sntp_server = "pool.ntp.org"
config.sntp_callback = nil

return config
