LilBot = Actor:new({
  speed = -0.5,
  update = function(_ENV)
    vx = flipped and -speed or speed
    vy = min(vy + gravity, vy_max)

    collide_x(_ENV)
    collide_y(_ENV)

    x += vx
    y += vy
  end,
  draw = function(_ENV)
    spr(64, x, y, 1, 1, t() % 1 < .5)
  end
})