Bullet = Actor:new({
  vx = 2.8,
  flipped = false,
  new = function(_ENV)
    vx = vx * (flipped and -1 or 1)
    return _ENV
  end,
  update = function(_ENV)
    x += vx
  end
})