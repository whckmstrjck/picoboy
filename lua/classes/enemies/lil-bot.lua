LilBot = Enemy:new({
  width = 4,
  height = 11,
  spr_offset = { default = { x = -6, y = -4 }, flipped = { x = -6, y = -4 } },
  spr_size = { x = 2, y = 2 },
  hp = 3,
  damage_power = 4,

  speed = 0.3,
  flipped = false,
  abs_vx = 0,
  update = function(_ENV)
    damage_time = max(damage_time - 1, 0)

    if collide_other(_ENV, player) then
      player:try_damage(damage_power)
    end

    vy = min(vy + gravity, vy_max)

    local t = time() % 1
    if t < .5 then
      abs_vx = lerp(abs_vx, 1, t)
    else
      local new_t = (1 - t) * 2
      abs_vx = lerp(0, abs_vx, new_t)
    end

    local x_hit = nil
    _, _, x_hit = collide_x(_ENV)
    y, vy, grounded = collide_y(_ENV)

    local falling_off = grounded and check_edge(_ENV) or false

    if x_hit or falling_off then
      flipped = not flipped
    end

    vx = speed * (abs_vx * (flipped and -1 or 1))

    x += vx
    y += vy
  end,
  check_edge = function(_ENV)
    local cel_x = flr((x + (flipped and -2 or (width + 1))) / 8)
    local cel_y = flr((y + height + 2) / 8)

    if fget(mget(cel_x, cel_y), 0) or fget(mget(cel_x, cel_y), 2) then
      return false
    end

    return true
  end,

  draw = function(_ENV)
    local spr_id = 64
    if (abs(vx) > .1) then spr_id = 66 end

    if damage_time == 0 then
      draw_spr(_ENV, spr_id)
    end

    -- draw collider

    -- rect(x, y, x + width - 1, y + height - 1, 7)
  end
})