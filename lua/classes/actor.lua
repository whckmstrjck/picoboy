Actor = Class:new({
  -- position and movement
  x = 0,
  y = 0,
  vx = 0,
  vy = 0,
  vy_max = 4,
  gravity = .14,
  grounded = nil, -- nil, solid, semisolid, ladder

  -- collisions
  platform = nil,
  width = 8,
  height = 8,
  skin_w = 0.4,
  collider = function(_ENV)
    return {
      x = {
        min = x,
        max = x + width
      },
      y = {
        min = y,
        max = y + height
      }
    }
  end,
  collide_other = function(_ENV, other)
    local a = collider(_ENV)
    local b = other.collider(other)

    return not (a.x.max < b.x.min or a.x.min > b.x.max or a.y.max < b.y.min or a.y.min > b.y.max)
  end,
  collide_point = function(_ENV, px, py)
    local coll = collider(_ENV)

    return not (px < coll.x.min or px > coll.x.max or py < coll.y.min or py > coll.y.max)
  end,
  collide_x = function(_ENV)
    local dir = sgn(vx)
    local x_check = x
    local y_checks = {
      y + skin_w,
      y + height / 2,
      y + height - skin_w
    }

    if dir < 0 then
      x_check += vx
    else
      x_check += width + vx
    end

    local hit = nil
    local platform_hit = nil
    local cel_x = flr(x_check / 8)

    for y_check in all(y_checks) do
      for platform in all(platforms) do
        if not cam:out_of_bounds(platform) then
          if platform:collide_point(x_check, y_check) then
            platform_hit = platform
            break
          end
        end
      end
    end

    if not platform_hit then
      for y_check in all(y_checks) do
        if not hit then
          local cel_y = flr(y_check / 8)
          if fget(mget(cel_x, cel_y), 0) then
            hit = 'solid'
          end
        end
      end
    end

    local new_x = x
    local new_vx = vx

    if platform_hit then
      hit = platform_hit.type
      new_vx = 0
      if dir < 0 then
        new_x = platform_hit.x + platform_hit.width
      else
        new_x = platform_hit.x - width
      end
    elseif hit then
      new_vx = 0
      if dir < 0 then
        new_x = cel_x * 8 + 8
      else
        new_x = cel_x * 8 - width
      end
    end

    return new_x, new_vx, hit
  end,
  collide_y = function(_ENV)
    local dir = sgn(vy)
    local x_checks = {
      x + vx + skin_w,
      x + vx + (width + skin_w * 2) / 2,
      x + vx + width - skin_w
    }
    local y_check = y

    if dir < 0 then
      y_check += vy
    else
      y_check += vy + height
    end

    local hit = nil
    local platform_hit = nil
    local cel_y = flr(y_check / 8)

    for x_check in all(x_checks) do
      for platform in all(platforms) do
        if not cam:out_of_bounds(platform) then
          if platform:collide_point(x_check, y_check) then
            platform_hit = platform
            break
          end
        end
      end
    end

    for x_check in all(x_checks) do
      local cel_x = flr(x_check / 8)

      -- solid
      if fget(mget(cel_x, cel_y), 0) then
        hit = 'solid'
      end

      if not hit and dir > 0 and y + height - 1 < cel_y * 8 then
        -- semisolid
        if fget(mget(cel_x, cel_y), 2) then
          if fget(mget(cel_x, cel_y), 3) then
            hit = 'ladder'
          else
            hit = 'semisolid'
          end
        end
      end
    end

    if platform_hit and platform_hit.direction == 'vertical' and platform_hit.dir == -1 then
      hit = nil
    elseif hit then
      platform_hit = nil
    end

    local new_y = y
    local new_vy = vy

    if platform_hit then
      hit = platform_hit.type
      new_vy = 0
      if dir < 0 then
        new_y = platform_hit.y + platform_hit.height
      else
        new_y = platform_hit.y - height
        platform = platform_hit
        add(platform_hit.riders, _ENV)
      end
    elseif hit then
      new_vy = 0
      if dir < 0 then
        new_y = cel_y * 8 + 8
      else
        new_y = cel_y * 8 - height
      end
    end

    if vy > 0 then
      return new_y, new_vy, hit
    else
      return new_y, new_vy, nil
    end
  end,

  -- drawing
  spr_size = { x = 1, y = 1 },
  spr_offset = { default = { x = 0, y = 0 }, flipped = { x = 0, y = 0 } },
  flipped = false,
  draw = function(_ENV)
    -- passed in by instance
    -- draw_spr(_ENV, 23) eg.
  end,
  draw_spr = function(_ENV, spr_id, options)
    options = options or {}
    local offset
    local spr_flipped = flipped

    if options.flipped != nil then
      spr_flipped = options.flipped
    end

    if options.offset_key then
      offset = spr_offset[options.offset_key]
    else
      if not flipped then
        offset = spr_offset.default
      else
        offset = spr_offset.flipped
      end
    end

    spr(spr_id, x + offset.x, y + offset.y, spr_size.x, spr_size.y, spr_flipped)
  end
})