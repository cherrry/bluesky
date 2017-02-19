--[[
BlueSky API config file.
Save this file as `bluesky_config.lua`
--]]

local config = {}

config.use_https = false
config.base_url = "http://www.example.com"
config.api_key = ""

config.endpoints = {}
config.endpoints.put = "/put"

return config
