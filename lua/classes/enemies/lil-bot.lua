LilBot = Actor:new({
  width = 6,
  height = 7,
  spr_offset = { default = { x = -1, y = -1 }, flipped = { x = -1, y = -1 } },
  speed = 0.2,
  update = function(_ENV)
    vy = min(vy + gravity, vy_max)

    local x_hit = nil
    x, vx, x_hit = collide_x(_ENV)
    y, vy, grounded = collide_y(_ENV)
    local falling_off = check_edge(_ENV)

    if x_hit or falling_off then
      flipped = not flipped
    end

    vx = flipped and -speed or speed

    x += vx
    y += vy
  end,
  check_edge = function(_ENV)
    local cel_x = flr((x + (flipped and -1 or (width + 7))) / 8)
    local cel_y = flr((y + height + 2) / 8)

    if fget(mget(cel_x, cel_y), 0) or fget(mget(cel_x, cel_y), 2) then
      return false
    end

    return true
  end,
  draw = function(_ENV)
    draw_spr(_ENV, 64, { flipped = t() % 1 < .5 })
  end
})