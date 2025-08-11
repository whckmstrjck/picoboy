Player = Actor:new({
  x = 10,
  y = -15,

  speed = .8,
  jump_force = 2.6,
  climbing = false,
  climbing_y = 0,
  climbing_speed = 0.5,

  width = 5,
  height = 11,

  shooting = 0,
  shooting_dur = 26,
  shots = {},
  shots_v = 2.8,
  shots_limit = 3,

  spr_size = { x = 2, y = 2 },
  spr_offset = { default = { x = -3, y = -1 }, flipped = { x = -8, y = -1 } },

  new = function(_ENV)
    spr_offset.climbing = { x = -1.5, y = -1 }
    return _ENV
  end,

  update = function(_ENV)
    move(_ENV)
    shoot(_ENV)
  end,

  -- move method
  move = function(_ENV)
    if climbing then
      if btn(⬅️) then
        if not flipped then
          shooting = 0
        end
        flipped = true
      end
      if btn(➡️) then
        if flipped then
          shooting = 0
        end
        flipped = false
      end

      if btnp(🅾️) and not btn(⬆️) then
        climbing = false
        spr_size = { x = 2, y = 2 }
        return
      end

      if shooting == 0 then
        if btn(⬆️) then
          y -= climbing_speed
        elseif btn(⬇️) then
          y += climbing_speed
        end
      end

      if not fget(mget((x + width / 2) / 8, (y + height) / 8), 3) then
        climbing = false
        spr_size = { x = 2, y = 2 }
        if flipped then
          x += 1
        end
      end

      return
    end

    vy = min(vy + gravity, vy_max)

    if btnp(🅾️) and grounded then
      if btn(⬇️) and grounded == 'semisolid' then
        -- jump through semisolid
        y += 2
      else
        vy = -jump_force
        grounded = false
      end
    end

    if btn(⬆️) and fget(mget((x + width / 2) / 8, (y + 2) / 8), 3) then
      climbing = true
      spr_size = { x = 1, y = 2 }
      y -= 2
      x = flr((x + width / 2) / 8) * 8 + 1.5
      vy = 0
      return
    end

    if btn(⬇️) and grounded == 'ladder' then
      spr_size = { x = 1, y = 2 }
      grounded = nil
      climbing = true

      local ladder_x

      for i = 1.5, width, 1.5 do
        local cel_x = flr((x + i) / 8)
        local cel_y = flr((y + height) / 8)

        if fget(mget(cel_x, cel_y), 3) then
          ladder_x = cel_x * 8
          break
        end
      end

      y += 3
      G.log('Old x: ' .. x)
      x = ladder_x + 1.5
      G.log('Climbing at X: ' .. x)
      vy = 0
      return
    end

    vx = 0
    walking = false

    if btn(⬅️) then
      vx = -speed
      walking = true
      flipped = true
    end

    if btn(➡️) then
      vx = speed
      walking = true
      flipped = false
    end

    collide_x(_ENV)
    collide_y(_ENV)

    x += vx
    y += vy

    if y > 260 then
      y = -100
    end
  end,

  -- shooting
  shoot = function(_ENV)
    if btnp(❎) and #shots < shots_limit then
      sfx(0)
      if flipped then
        add(shots, { x = x - 4, y = y + 5, flipped = true })
      else
        add(shots, { x = x + width + 3, y = y + 5, flipped = false })
      end
      shooting = shooting_dur
    elseif shooting > 0 then
      shooting = max(shooting - 1, 0)
    end

    for shot in all(shots) do
      if shot.destroy then
        sfx(1)
        del(shots, shot)
      end

      if shot.flipped then
        shot.x -= shots_v
      else
        shot.x += shots_v
      end

      if abs(shot.x - x) > 100 then
        del(shots, shot)
      end

      if fget(mget(shot.x / 8, shot.y / 8), 1) then
        shot.destroy = true
        shot.x = flr(shot.x / 8) * 8
        if shot.flipped then
          shot.x += 8
        end
      end
    end
  end,

  -- draw
  draw_shots = function(_ENV)
    for shot in all(shots) do
      spr(15, shot.x + (flipped and -3 or -4), shot.y - 1, 1, 1, shot.flipped)
    end
  end,
  draw_cannon = function(_ENV)
    if shooting > 0 then
      local arm_cannon_spr = 14

      if shooting > shooting_dur - 4 then
        arm_cannon_spr = 30
      elseif shooting > shooting_dur - 8 then
        arm_cannon_spr = 31
      end

      spr(arm_cannon_spr, x + (flipped and -10 or 7), y + 3, 1, 1, flipped)
    end
  end,
  draw_default = function(_ENV)
    local spr_id = 2

    if not grounded then
      if vy < 0 then
        spr_id = 10
      else
        spr_id = 12
      end
    elseif walking then
      spr_id += flr((t() * 10 % 3 + 1)) * 2
    end

    draw_spr(_ENV, spr_id)
  end,
  draw_climbing = function(_ENV)
    local spr_id = 34
    local climbing_flipped = y / 20 % 1 < 0.5

    if shooting > 0 then
      climbing_flipped = flipped
    end

    draw_spr(
      _ENV, spr_id, {
        offset_key = 'climbing',
        flipped = climbing_flipped
      }
    )
  end,
  draw = function(_ENV)
    draw_shots(_ENV)

    if climbing then
      draw_climbing(_ENV)
    else
      draw_default(_ENV)
    end
    -- rect(x, y, x + width - 1, y + height - 1, 7)

    draw_cannon(_ENV)
  end
})