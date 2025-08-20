Player = Actor:new({
  state = 'falling', -- default, dropping, jumping, falling, climbing

  x = 10,
  y = -15,
  width = 5,
  height = 11,

  speed = .8,
  jump_force = 3,
  climbing = false,
  climbing_y = 0,
  climbing_speed = 0.5,

  gravity = .14,
  grounded = nil, -- nil, solid, semisolid, ladder, coyote
  coyote_time = 0,
  coyote_frame_count = 3,

  shooting = 0,
  shooting_dur = 26,
  shots = {},
  shots_v = 2.8,
  shots_limit = 3,

  spr_size = { x = 2, y = 2 },
  spr_offset = { default = { x = -4, y = -1 }, flipped = { x = -7, y = -1 } },

  new = function(_ENV)
    spr_offset.climbing = { x = -1.5, y = -1 }
    return _ENV
  end,

  set_state = function(_ENV, new_state)
    if state == new_state then return end

    -- DEFAULT
    if new_state == 'default' then
      -- no op
    end

    -- CLIMBING
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

    -- DROPPING
    if new_state == 'dropping' then
      grounded = nil
      y += 1
    end

    -- JUMPING
    if new_state == 'jumping' then
      coyote_time = 0
      vy = -jump_force
      grounded = false
    end

    -- FALLING
    if new_state == 'falling' then
      vy = 1.2

      log(state)
      if state == 'default' then
        grounded = 'coyote'
        coyote_time = coyote_frame_count
      end

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
    elseif state == 'dropping' then
      state_dropping(_ENV)
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
    if not grounded then
      set_state(_ENV, 'falling')
      return
    end

    if try_drop(_ENV) then return end
    if try_jump(_ENV) then return end
    if try_climb_up(_ENV) then return end
    if try_climb_down(_ENV) then return end

    apply_move_and_collide(_ENV)
  end,

  -- DROPPING STATE
  state_dropping = function(_ENV)
    set_state(_ENV, 'falling')
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

    local drop_ladder = btnp(🅾️) and not btn(⬆️)
    local not_on_ladder = drop_ladder or not fget(mget((x + width / 2) / 8, (y + height - 1) / 8), 3)

    if drop_ladder or not_on_ladder then set_state(_ENV, 'falling') end
  end,

  -- JUMPING STATE
  state_jumping = function(_ENV)
    if try_climb_up(_ENV) then return end

    if vy >= 0 or not btn(🅾️) then
      set_state(_ENV, 'falling')
    end

    apply_move_and_collide(_ENV)
  end,

  -- FALLING STATE
  state_falling = function(_ENV)
    if try_jump(_ENV) then return end
    if try_climb_up(_ENV) then return end

    if grounded and grounded != 'coyote' then
      set_state(_ENV, 'default')
    end

    apply_move_and_collide(_ENV)
    coyote_time = max(coyote_time - 1, 0)
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

    local new_grounded = nil

    x, vx = collide_x(_ENV)
    y, vy, new_grounded = collide_y(_ENV)

    if coyote_time > 0 then
      grounded = 'coyote'
    else
      grounded = new_grounded
    end

    x += vx
    y += vy

    if y > 260 then
      y = -100
    end
  end,

  -- ACTIONS
  try_jump = function(_ENV)
    local will_jump = btnp(🅾️) and grounded
    if will_jump then set_state(_ENV, 'jumping') end
    return will_jump
  end,
  try_drop = function(_ENV)
    local will_drop = btnp(🅾️) and btn(⬇️) and grounded == 'semisolid'
    if will_drop then set_state(_ENV, 'dropping') end
    return will_drop
  end,
  try_climb_up = function(_ENV)
    local will_climb_up = btn(⬆️) and fget(mget((x + width / 2) / 8, (y + 2) / 8), 3)
    if will_climb_up then set_state(_ENV, 'climbing') end
    return will_climb_up
  end,
  try_climb_down = function(_ENV)
    local will_climb_down = btn(⬇️) and grounded == 'ladder'
    if will_climb_down then set_state(_ENV, 'climbing') end
    return will_climb_down
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

      local spr_x = x + (flipped and -9 or 6)
      if not flipped and state == 'climbing' then
        spr_x += 1
      end
      local spr_y = y + 3
      spr(arm_cannon_spr, spr_x, spr_y, 1, 1, flipped)
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
    local climbing_flipped = y / 12 % 1 < 0.5

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

    draw_debug(_ENV)
  end,


  draw_debug = function(_ENV)
    local pos_x = x - 10
    local pos_y = y - 10
    -- draw collider
    fillp(▒)
    rectfill(x, y, x + width - 1, y + height - 1, 8)
    fillp()
    rect(x, y, x + width - 1, y + height - 1, 7)

    local grounded_str = '…'
    if grounded == 'ladder' then
      grounded_str = "▤"
    elseif grounded == 'coyote' then
      grounded_str = "🐱"
    elseif grounded == 'semisolid' then
      grounded_str = "▒"
    elseif grounded then
      grounded_str = '█'
    end

    grounded_str = grounded_str .. ' (' .. coyote_time .. ')'

    rectfill(pos_x - 12, pos_y - 14, pos_x + 39, pos_y, 2)
    fillp(▒)
    rectfill(pos_x - 12, pos_y - 14, pos_x + 39, pos_y, 8)
    fillp()
    rect(pos_x - 12, pos_y - 14, pos_x + 39, pos_y, 7)
    print('gR: ' .. grounded_str .. '\nsT: ' .. state, pos_x - 10, pos_y - 12, 7)
  end
})