Camera = Class:new({
  state = 'follow', -- follow, static
  x = 0,
  y = 0,
  target_actor = nil,
  bounds = { x_min = 0, y_min = -16, x_max = 40, y_max = 24 },
  update = function(_ENV)
    if state == 'static' then
    else
      if target_actor == nil then return end

      x = max(min(target_actor.x + flr(target_actor.width / 2) - 64, bounds.x_max), bounds.x_min)
      y = max(min(target_actor.y - 64, bounds.y_max), bounds.y_min)
    end
    camera(x, y)
  end,
  reset = function(_ENV)
    camera(0, 0)
  end,
  out_of_bounds = function(_ENV, actor)
    local padding = 10

    if (actor.x + actor.width + padding) < x or (actor.x - padding) > (x + 128) then
      return true
    end
    if (actor.y + actor.height + padding) < y or (actor.y - padding) > (y + 128) then
      return true
    end
    return false
  end
})