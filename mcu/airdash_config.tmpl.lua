--[[
Airdash API config file.
Save this file as `wifi_config.lua`
--]]

local config = {}

config.use_https = false
config.base_url = "http://www.example.com"

config.api = {}
config.api.ping = "/ping"

return config
