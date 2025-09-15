Platform = Actor:new({
  type = 'solid', -- solid, semisolid
  moving = false,
  width = 8,
  height = 8,
  actors = {},
  update = function(_ENV)
    if not moving then return end
  end,
  draw = function(_ENV)
    rectfill(x, y, x + width - 1, y + height - 1, 5)
  end
})