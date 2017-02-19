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

local readings = {
  pm_1_0 = 50,
  pm_2_5 = 50,
  pm_10_0 = 50
}

local pms5003 = {}
pms5003.get = function ()
  local next = {
    pm_1_0 = fluctuate(readings.pm_1_0),
    pm_2_5 = fluctuate(readings.pm_2_5),
    pm_10_0 = fluctuate(readings.pm_10_0)
  }
  readings = next
  return next
end

return pms5003
