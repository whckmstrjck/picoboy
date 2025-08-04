p = {
  x = 10,
  y = 10,
  w = 5,
  h = 11,
  skin_w = 0.4,
  vx = 0,
  vy = 0,
  vy_max = 4,
  gravity = .14,
  grounded = false,
  speed = .8,
  jump_force = 2.6,
  flipped = false,
  shooting = 0,
  shooting_dur = 26,
  shots = {},
  shots_v = 3.2,
  shots_limit = 3,

  -- move method
  move = function()
    p.vy = min(p.vy + p.gravity, p.vy_max)

    if btnp(❎) and p.grounded then
      p.vy = -p.jump_force
      p.grounded = false
    end

    p.vx = 0
    p.walking = false

    if btn(⬅️) then
      p.vx = -p.speed
      p.walking = true
      p.flipped = true
    end

    if btn(➡️) then
      p.vx = p.speed
      p.walking = true
      p.flipped = false
    end

    p.collide_x()
    p.collide_y()

    p.x += p.vx
    p.y += p.vy

    if p.y > 150 then
      p.y = -50
    end
  end,

  -- collisions
  collide_x = function()
    local dir = sgn(p.vx)
    local x = p.x
    local ys = { p.y + p.skin_w, p.y + p.h / 2, p.y + p.h - p.skin_w }

    if dir < 0 then
      x += p.vx
    else
      x += p.w + p.vx
    end

    local hit = false
    local cel_x = flr(x / 8)

    for y in all(ys) do
      if not hit then
        local cel_y = flr(y / 8)
        hit = fget(mget(cel_x, cel_y), 0)
      end
    end

    if hit then
      p.vx = 0
      if dir < 0 then
        p.x = cel_x * 8 + 8
      else
        p.x = cel_x * 8 - p.w
      end
    end
  end,
  collide_y = function()
    local dir = sgn(p.vy)
    local xs = { p.x + p.vx + p.skin_w, p.x + p.vx + p.w - p.skin_w }
    local y = p.y

    if dir < 0 then
      -- up
      y += p.vy
    else
      -- down
      y += p.vy + p.h
    end

    local hit = false
    local cel_y = flr(y / 8)

    for x in all(xs) do
      if not hit then
        local cel_x = flr(x / 8)
        hit = fget(mget(cel_x, cel_y), 0)
      end
    end

    if hit then
      p.vy = 0
      if dir < 0 then
        p.y = cel_y * 8 + 8
      else
        p.grounded = true
        p.y = cel_y * 8 - p.h
      end
    else
      p.grounded = false
    end
  end,

  -- shooting
  shoot = function()
    if btnp(🅾️) and #p.shots < p.shots_limit then
      sfx(0)
      if p.flipped then
        add(p.shots, { x = p.x - 4, y = p.y + 5, flipped = true })
      else
        add(p.shots, { x = p.x + p.w + 3, y = p.y + 5, flipped = false })
      end
      p.shooting = p.shooting_dur
    elseif p.shooting > 0 then
      p.shooting = max(p.shooting - 1, 0)
    end

    for shot in all(p.shots) do
      if shot.destroy then
        sfx(1)
        del(p.shots, shot)
      end

      if shot.flipped then
        shot.x -= p.shots_v
      else
        shot.x += p.shots_v
      end

      if abs(shot.x - p.x) > 100 then
        del(p.shots, shot)
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
  draw = function()
    for shot in all(p.shots) do
      local x = shot.x - 4
      local y = shot.y - 1

      if shot.flipped then
        x = shot.x - 3
      end

      spr(11, x, y, 1, 1, shot.flipped)
    end

    local x = p.x - 4
    local y = p.y - 1
    local sprt = 2

    if p.flipped then
      x = p.x - 7
    end

    if not p.grounded then
      sprt = 8
    elseif p.walking then
      sprt += flr((time() * 6 % 2 + 1)) * 2
    end

    spr(sprt, x, y, 2, 2, p.flipped)

    if p.shooting > 0 then
      if p.flipped then
        x_offset = -2
      else
        x_offset = 10
      end

      local shoot_spr = 10

      if p.shooting > p.shooting_dur - 2 then
        shoot_spr = 26
      elseif p.shooting > p.shooting_dur - 4 then
        shoot_spr = 27
      end

      spr(shoot_spr, x + x_offset, y + 4, 1, 1, p.flipped)
    end
  end
}