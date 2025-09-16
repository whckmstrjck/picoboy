Platform = Actor:new({
  type = 'solid', -- solid, semisolid
  moving = false,
  direction = 'vertical', -- horizontal, vertical
  width = 16,
  height = 8,
  actors = {},
  speed = .2,
  range = 30,
  dir = 1,
  update = function(_ENV)
    if not moving then return end

    local move_amount = speed * dir
    if direction == 'vertical' then
      y = y + move_amount
    else
      x = x + move_amount
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

    if y > 60 then dir = -1 end
    if y < 20 then dir = 1 end
  end,
  draw = function(_ENV)
    for i = 0, width - 8, 8 do
      log(i)
      spr(130, x + i, y)
    end
    -- rectfill(x, y, x + width - 1, y + height - 1, 5)
  end
})