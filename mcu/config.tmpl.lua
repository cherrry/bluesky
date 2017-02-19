local config = {}

config.device_id = "default"

config.bluesky = {
  base_url = "http://www.example.com"
  api_key = ""
  push_frequency = 10 * 1000
  endpoints = {
    put = "/put"
  }
}

config.sntp = {
  sync_frequency = 30 * 1000
  server = "pool.ntp.org"
  callback = nil
}

config.ssl = {
  use_ssl = false
  cert = [[
  ]]
}

config.wifi = {
  ssid = ""
  pwd = ""
}

return config
