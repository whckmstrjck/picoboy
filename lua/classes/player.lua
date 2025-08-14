Player = Actor:new({
  state = 'default', -- default, jumping, falling, climbing

  x = 10,
  y = -15,
  width = 5,
  height = 11,

  speed = .8,
  jump_force = 3,
  climbing = false,
  climbing_y = 0,
  climbing_speed = 0.5,

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

  set_state = function(_ENV, new_state)
    if state == new_state then return end

    if new_state == 'jumping' then
      vy = -jump_force
      grounded = false
    end

    if new_state == 'climbing' then
      if grounded == 'ladder' then
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
        x = ladder_x + 1.5
      else
        y -= 2
        x = flr((x + width / 2) / 8) * 8 + 1.5
      end

      spr_size = { x = 1, y = 2 }
      vy = 0
      grounded = nil
    end

    if new_state == 'falling' then
      vy = 0
      if state == 'climbing' then
        y -= 1 -- fix later, avoids colliding
        spr_size = { x = 2, y = 2 }
      end
    end

    state = new_state
  end,

  update = function(_ENV)
    if state == 'default' then
      state_default(_ENV)
    elseif state == 'climbing' then
      state_climbing(_ENV)
    elseif state == 'jumping' then
      state_jumping(_ENV)
    elseif state == 'falling' then
      state_falling(_ENV)
    end

    shoot(_ENV)
  end,

  -- DEFAULT STATE
  state_default = function(_ENV)
    if btnp(🅾️) then
      if btn(⬇️) and grounded == 'semisolid' then
        y += 1
      else
        set_state(_ENV, 'jumping')
      end
    end

    if try_climb_up(_ENV) or try_climb_down(_ENV) then
      set_state(_ENV, 'climbing')
      return
    end

    apply_move_and_collide(_ENV)

    if vy > 0 then
      set_state(_ENV, 'falling')
    end
  end,

  -- CLIMBING STATE
  state_climbing = function(_ENV)
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

    if shooting == 0 then
      if btn(⬆️) then
        y -= climbing_speed
      elseif btn(⬇️) then
        y += climbing_speed
      end
    end

    if btnp(🅾️) and not btn(⬆️) then
      set_state(_ENV, 'falling')
      return
    end

    if not fget(mget((x + width / 2) / 8, (y + height - 1) / 8), 3) then
      set_state(_ENV, 'falling')
    end
  end,

  -- JUMPING STATE
  state_jumping = function(_ENV)
    if try_climb_up(_ENV) then
      set_state(_ENV, 'climbing')
      return
    end

    if vy >= 0 or not btn(🅾️) then
      if grounded then
        set_state(_ENV, 'default')
      else
        set_state(_ENV, 'falling')
      end
    end

    apply_move_and_collide(_ENV)
  end,

  -- FALLING STATE
  state_falling = function(_ENV)
    if try_climb_up(_ENV) then
      set_state(_ENV, 'climbing')
      return
    end

    if grounded then
      set_state(_ENV, 'default')
    end

    apply_move_and_collide(_ENV)
  end,

  apply_move_and_collide = function(_ENV)
    vx = 0

    vy = min(vy + gravity, vy_max)

    if btn(⬅️) then
      vx = -speed
      flipped = true
    end

    if btn(➡️) then
      vx = speed
      flipped = false
    end

    x, vx = collide_x(_ENV)
    y, vy, grounded = collide_y(_ENV)

    x += vx
    y += vy

    if y > 260 then
      y = -100
    end
  end,
  try_jump = function(_ENV)
  end,
  try_climb_up = function(_ENV)
    return btn(⬆️) and fget(mget((x + width / 2) / 8, (y + 2) / 8), 3)
  end,
  try_climb_down = function(_ENV)
    return btn(⬇️) and grounded == 'ladder'
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

      if climbing then
        spr(arm_cannon_spr, x + (flipped and -9 or 7), y + 3, 1, 1, flipped)
      else
        spr(arm_cannon_spr, x + (flipped and -10 or 7), y + 3, 1, 1, flipped)
      end
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
    else
      if vx != 0 then
        spr_id += flr((t() * 10 % 3 + 1)) * 2
      else
        spr_id = 2
      end
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

    if state == 'climbing' then
      draw_climbing(_ENV)
    else
      draw_default(_ENV)
    end

    draw_cannon(_ENV)

    draw_debug(_ENV, false)
  end,
  draw_debug = function(_ENV, enabled)
    if not enabled then return end
    -- draw collider
    rect(x, y, x + width - 1, y + height - 1, 7)
    print(state, x + width / 2 - (#state * 4 / 2), y - 10, 7)
  end
})