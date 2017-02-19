local config = require("config")

local ssl_config = config.ssl

local init_ssl = {}

init_ssl.init = function ()
  if ssl_config.use_ssl then
    tls.cert.verify(ssl_config.cert)
  end
end

return init_ssl
