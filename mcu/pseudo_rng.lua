local pseudo_rng = {}

local seed = 123456789
pseudo_rng.next = function ()
  seed = (1103515245 * seed + 12345)
  return seed
end

return pseudo_rng
