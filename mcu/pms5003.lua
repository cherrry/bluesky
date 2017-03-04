local pseudo_rng = require("pseudo_rng")

local pms5003 = {}

pms5003.init = function ()
  print("init pms5003")
end

pms5003.get = function ()
  local value = {}

  value["pm1.0"] = 0
  value["pm2.5"] = 0
  value["pm10"] = 0

  return value
end

-- Seperateor

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

local fake_pms5003 = {}
fake_pms5003.init = function ()
  pms5003:init()
end

fake_pms5003.get = function ()
  local real_value = pms5003:get()
  print("real pm1.0: ", real_value["pm1.0"])
  print("real pm2.5: ", real_value["pm2.5"])
  print("real pm10: ", real_value["pm10"])

  local next = {}
  next["pm1.0"] = fluctuate(readings["pm1.0"])
  next["pm2.5"] = fluctuate(readings["pm2.5"])
  next["pm10"] = fluctuate(readings["pm10"])
  readings = next
  return next
end

return fake_pms5003
