local config = require("ssl_config")

local init_ssl = {}

init_ssl.init = function ()
  if config.use_ssl then
    tls.cert.verify(config.cert)
  end
end

return init_ssl
