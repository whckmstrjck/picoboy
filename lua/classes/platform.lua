Platform = Actor:new({
  type = 'solid', -- solid, semisolid
  direction = 'vertical', -- horizontal, vertical
  x = 0,
  y = 0,
  max_pos = 0,
  min_pos = 0,
  width = 8,
  height = 8,
  riders = {},
  speed = .2,
  range = 0,
  dir = 1,
  sequence = nil,
  sequence_index = 1,
  time_current = 0,
  time_max = 140,
  new = function(_ENV, tbl)
    tbl = tbl or {}

    time_current = tbl.time_max or time_max

    if (tbl.direction or direction) == 'vertical' then
      tbl.max_pos = (tbl.y or y) + (tbl.range or range) * (tbl.dir or dir)
      tbl.min_pos = (tbl.y or y)
    else
      tbl.max_pos = (tbl.x or x) + (tbl.range or range) * (tbl.dir or dir)
      tbl.min_pos = (tbl.x or x)
    end

    return setmetatable(
      tbl, {
        __index = _ENV
      }
    )
  end,
  try_push_actor = function(_ENV, pushed_actor, amount)
    for actor in all(riders) do
      if actor == pushed_actor then return end
    end
    if cam:out_of_bounds(_ENV) then return end
    if not collide_other(_ENV, pushed_actor) then return end

    -- if direction == 'vertical' then
    --   if (dir < 0 and y > (pushed_actor.y + pushed_actor.height)) or (dir > 0 and (y + height) < pushed_actor.y) then
    --     pushed_actor.y = pushed_actor.y + amount
    --   end
    -- else
    if (dir < 0 and x < (pushed_actor.x + pushed_actor.width))
        or (dir > 0 and (x + width) > pushed_actor.x) then
      pushed_actor.x = pushed_actor.x + amount
    end
    -- end
  end,
  update = function(_ENV)
    local move_amount = speed * dir

    if sequence != nil then
      time_current -= 1

      if time_current <= 0 then
        time_current = time_max
        sequence_index += 1
        sfx(5)
        if sequence_index > #sequence then
          sequence_index = 1
        end
      end

      x = sequence[sequence_index][1]
      y = sequence[sequence_index][2]
    elseif range >= 0 then
      -- log('move')
      if direction == 'vertical' then
        y = y + move_amount
        if y > max_pos or y < min_pos then dir = dir * -1 end
      else
        x = x + move_amount
        if x > max_pos or x < min_pos then dir = dir * -1 end
      end

      if (direction == 'horizontal' and type == 'solid') then
        try_push_actor(_ENV, G.player, move_amount)
        for enemy in all(G.enemies) do
          try_push_actor(_ENV, enemy, move_amount)
        end
      end

      for actor in all(riders) do
        if direction == 'vertical' then
          actor.y = actor.y + move_amount
        else
          actor.x = actor.x + move_amount
        end
      end

      riders = {}
    end
  end,
  draw = function(_ENV)
    local draw = true
    if sequence != nil then
      if time_current > (time_max - 16) then
        pal(12, 15)
        pal(2, 8)
        pal(13, 12)
      end
      if time_current > (time_max - 8) then
        pal_set_all(7)
      end

      if time_current < 16 then
        pal(12, 2)
        pal(13, 2)
        pal(7, 8)
        if (time_current % 4 < 2) then
          draw = false
        end
      end
    end

    if draw then
      for i = 0, width - 8, 8 do
        spr(type == 'solid' and 132 or 148, x + i, y)
      end
    end

    -- rectfill(x, y, x + width - 1, y + height - 1, 5)
    pal()

    if sequence == nil then return end

    for i = 1, #sequence do
      if i != sequence_index then
        -- print(i, sequence[i][1] + width / 2 - 2, sequence[i][2] + height / 2 - 3, 5)
        pset(sequence[i][1], sequence[i][2], 5)
        pset(sequence[i][1], sequence[i][2] + height - 1, 5)
        pset(sequence[i][1] + width - 1, sequence[i][2], 5)
        pset(sequence[i][1] + width - 1, sequence[i][2] + height - 1, 5)

        pset(sequence[i][1] + 1, sequence[i][2], 5)
        pset(sequence[i][1], sequence[i][2] + 1, 5)
        pset(sequence[i][1] + width - 2, sequence[i][2], 5)
        pset(sequence[i][1] + width - 1, sequence[i][2] + 1, 5)

        pset(sequence[i][1], sequence[i][2] + height - 2, 5)
        pset(sequence[i][1] + 1, sequence[i][2] + height - 1, 5)
        pset(sequence[i][1] + width - 1, sequence[i][2] + height - 2, 5)
        pset(sequence[i][1] + width - 2, sequence[i][2] + height - 1, 5)
      end
    end
  end
})