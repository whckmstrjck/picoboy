Bullet = Actor:new({
  width = 5,
  height = 3,
  vx = 2.8,
  -- spr_offset = { default = { x = -6, y = -4 }, flipped = { x = -5, y = -4 } },

  flipped = false,


  update = function(_ENV)
    x += vx * (flipped and -1 or 1)

    if cam:out_of_bounds(_ENV) then
      destroy(_ENV)
    end
  end,
  draw = function(_ENV)
    draw_spr(_ENV, 15)
  end,
  destroy = function(_ENV)
    del(bullets, _ENV)
  end
})