Player = Actor:new({
  state = 'falling', -- default, dropping, jumping, falling, climbing

  x = 10,
  y = -15,
  width = 5,
  height = 11,

  speed = .8,
  jump_force = 2.4,
  climbing = false,
  climbing_y = 0,
  climbing_speed = 0.5,

  gravity = .1,
  grounded = nil, -- nil, solid, semisolid, ladder, coyote
  coyote_time = 0,
  coyote_frame_count = 3,

  shooting = 0,
  shooting_cooldown = 26,
  bullets = {},
  bullets_max_count = 3,

  spr_size = { x = 2, y = 2 },
  spr_offset = { default = { x = -6, y = -4 }, flipped = { x = -5, y = -4 }, climbing = { x = -5, y = -3 } },

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

        if not ladder_x then
          set_state(_ENV, 'default')
          return
        end

        y += 3
        x = ladder_x + 1.5
      else
        y -= 2
        x = flr((x + width / 2) / 8) * 8 + 1.5
      end

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

      if state == 'default' then
        grounded = 'coyote'
        coyote_time = coyote_frame_count
      end

      if state == 'climbing' then
        y -= 1 -- fix later, avoids colliding
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

    for bullet in all(bullets) do
      bullet:update()
    end
    try_shoot(_ENV)
  end,

  -- DEFAULT STATE
  state_default = function(_ENV)
    if not grounded then
      set_state(_ENV, 'falling')
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
    if try_jump(_ENV) then
      return
    end
    if try_climb_up(_ENV) then return end

    if grounded and grounded != 'coyote' then
      set_state(_ENV, 'default')
    end

    apply_move_and_collide(_ENV)
    coyote_time = max(coyote_time - 1, 0)
  end,

  apply_move_and_collide = function(_ENV)
    vx = 0

    if grounded == 'coyote' then
      vy = 0
    else
      vy = min(vy + gravity, vy_max)
    end

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
  try_shoot = function(_ENV)
    shooting = max(shooting - 1, 0)

    if not btnp(❎) or #bullets >= bullets_max_count then return end
    sfx(0)

    -- recoil!
    -- x = x + (flipped and 1 or -1)

    local shot_x = x + (flipped and -4 or width + 3)
    local shot_y = y + (state == 'climbing' and 4 or 5)

    add(bullets, Bullet:new({ x = shot_x, y = shot_y, bullets = bullets, flipped = flipped }))
    shooting = shooting_cooldown
  end,

  -- DRAW METHODS
  draw_shots = function(_ENV)
    for shot in all(shots) do
      spr(15, shot.x + (flipped and -3 or -4), shot.y - 1, 1, 1, shot.flipped)
    end
  end,
  draw_cannon = function(_ENV)
    if shooting > 0 then
      local arm_cannon_spr = 14

      if shooting > shooting_cooldown - 4 then
        arm_cannon_spr = 30
      elseif shooting > shooting_cooldown - 8 then
        arm_cannon_spr = 31
      end

      local spr_x = x + (flipped and -8 or 5)
      local spr_y = y + 5

      if state == 'climbing' then
        if not flipped then
          spr_x += 1
        end
        spr_y -= 1
      end

      spr(arm_cannon_spr, spr_x, spr_y, 1, 1, flipped)
    end
  end,
  draw_default = function(_ENV)
    local spr_id = ((t() >> 2) % 1) > .95 and 32 or 0

    if shooting > 0 then
      spr_id = 2
    end

    if not grounded and state == 'falling' then
      spr_id = 12
    elseif state == 'jumping' then
      spr_id = 10
    else
      if vx != 0 then
        spr_id = 2
        spr_id += flr((t() * 8 % 3 + 1)) * 2
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
    for bullet in all(bullets) do
      bullet:draw()
    end

    if state == 'climbing' then
      draw_climbing(_ENV)
    else
      draw_default(_ENV)
    end

    draw_cannon(_ENV)
  end,

  -- DEBUG DRAW METHODS
  draw_debug = function(_ENV)
    -- draw collider
    -- fillp(▒)
    -- rectfill(x, y, x + width - 1, y + height - 1, 8)
    -- fillp()
    -- rect(x, y, x + width - 1, y + height - 1, 7)
  end,
  draw_debug_static = function(_ENV)
    -- draw state and grounded info
    local debug_x = 2
    local debug_y = 2
    local debug_w = 54
    local debug_h = 16

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

    grounded_str = grounded_str .. ' cT: ' .. (coyote_time == 0 and '-' or coyote_time)

    rectfill(debug_x + 1, debug_y + 1, debug_x + debug_w + 1, debug_y + debug_h + 1, 2)
    rectfill(debug_x, debug_y, debug_x + debug_w, debug_y + debug_h, 5)
    fillp(▤)
    rectfill(debug_x + 2, debug_y, debug_x + debug_w, debug_y + debug_h, 3)
    fillp()
    rect(debug_x, debug_y, debug_x + debug_w, debug_y + debug_h, 15)
    print('gR: ' .. grounded_str .. '\nsT: ' .. state, debug_x + 5, debug_y + 3, 2)
    print('gR: ' .. grounded_str .. '\nsT: ' .. state, debug_x + 4, debug_y + 3, 15)
  end
})