Platform = Actor:new({
  type = 'solid', -- solid, semisolid
  moving = false,
  direction = 'vertical', -- horizontal, vertical
  max_pos = 0,
  min_pos = 0,
  width = 16,
  height = 8,
  actors = {},
  speed = .24,
  range = 10,
  dir = 1,
  new = function(_ENV, tbl)
    tbl = tbl or {}

    if (tbl.direction or direction) == 'vertical' then
      tbl.max_pos = tbl.y + (tbl.range or range) * (tbl.dir or dir)
      tbl.min_pos = tbl.y
    else
      tbl.max_pos = tbl.x + (tbl.range or range) * (tbl.dir or dir)
      tbl.min_pos = tbl.x
    end

    return setmetatable(
      tbl, {
        __index = _ENV
      }
    )
  end,
  try_push_actor = function(_ENV, pushed_actor, amount)
    for actor in all(actors) do
      if actor == pushed_actor then return end
    end
    if cam:out_of_bounds(_ENV) then return end
    if not collide_other(_ENV, pushed_actor) then return end

    if direction == 'vertical' then
      log('pushhh')
      if (dir < 0 and y > (pushed_actor.y + pushed_actor.height)) or (dir > 0 and (y + height) < pushed_actor.y) then
        log(y)
        log(pushed_actor.y + pushed_actor.height)
        log('---')
        pushed_actor.y = pushed_actor.y + amount
      end
    else
      if (dir < 0 and x < (pushed_actor.x + pushed_actor.width))
          or (dir > 0 and (x + width) > pushed_actor.x) then
        pushed_actor.x = pushed_actor.x + amount
      end
    end
  end,
  update = function(_ENV)
    if not moving then return end

    local move_amount = speed * dir

    if direction == 'vertical' then
      y = y + move_amount
      if y > max_pos or y < min_pos then dir = dir * -1 end
    else
      x = x + move_amount
      if x > max_pos or x < min_pos then dir = dir * -1 end
    end

    try_push_actor(_ENV, G.player, move_amount)
    for enemy in all(G.enemies) do
      try_push_actor(_ENV, enemy, move_amount)
    end

    for actor in all(actors) do
      if not cam:out_of_bounds(actor) then
        if direction == 'vertical' then
          actor.y = actor.y + move_amount
        else
          actor.x = actor.x + move_amount
        end
      end
    end

    actors = {}
  end,
  draw = function(_ENV)
    for i = 0, width - 8, 8 do
      spr(130, x + i, y)
    end
    -- rectfill(x, y, x + width - 1, y + height - 1, 5)
  end
})