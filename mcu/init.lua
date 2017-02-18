local init_airdash = require("init_airdash")
local init_ssl = require("init_ssl")
local init_wifi = require("init_wifi")

init_wifi:init()
init_ssl:init()

init_airdash:init()
