local pseudo_rng = require("pseudo_rng")

function fluctuate(prev)
  local next = prev + pseudo_rng.next() % 20 - 10
  if next < 0 then
    return 0
  elseif next > 500 then
    return 500
  else
    return next
  end
end

local readings = {}
readings["pm1.0"] = 50
readings["pm2.5"] = 50
readings["pm10"] = 50

local pms5003 = {}
pms5003.get = function ()
  local next = {}
  next["pm1.0"] = fluctuate(readings["pm1.0"])
  next["pm2.5"] = fluctuate(readings["pm2.5"])
  next["pm10"] = fluctuate(readings["pm10"])
  readings = next
  return next
end

return pms5003
