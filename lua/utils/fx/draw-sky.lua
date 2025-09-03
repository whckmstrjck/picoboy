draw_sun = function(x, y)
  circfill(x, y, 14, 8)
  circfill(x, y, 12, 2)
  circfill(x, y, 10, 15)
  circfill(x, y, 8 + sin(t()) * .9, 7)
end

draw_smoke_stack = function(pos, w_bottom, w_top, slant)
  for i = 128, 0, -1 do
    local t = (128 - i) / 128
    local width = lerp(w_bottom, w_top, t)
    local x1 = pos - width / 2 + slant * t
    local x2 = pos + width / 2 + slant * t
    local color = 2

    -- if i < 20 then
    --   color = 5
    -- elseif i < 41 then
    --   if i % 3 > .5 then
    --     color = 5
    --   end
    -- elseif i < 56 then
    --   if i % 2 > .5 then
    --     color = 5
    --   end
    -- elseif i < 74 then
    --   if i % 3 < 1 then
    --     color = 5
    --   end
    -- elseif i < 88 then
    --   if i % 4 < 1 then
    --     color = 5
    --   end
    -- end

    local sway = cos(time() * .5 - (t * 3 * t)) * 4 * t

    line(
      x1 + sway,
      i,
      x2 + sway,
      i,
      color
    )

    local outline_width = 2 * t
    line(x1 + sway, i, x1 + sway - outline_width, i, 2)
    line(x2 + sway, i, x2 + sway + outline_width, i, 2)
  end
end

draw_sky = function()
  -- sky
  cls(0)

  if true then
    return
  end

  rectfill(0, 0, 128, 24, 0)
  fillp()
  rectfill(0, 0, 128, 20, 0)

  -- stars
  circfill(10, 10, .5, 7)
  circfill(16, 22, .5, 7)
  circfill(36, 32, 1, 7)
  circfill(52, 8, 1, 7)
  circfill(56, 16, .5, 7)
  circfill(82, 18, 1, 7)
  circfill(94, 16, .5, 7)
  circfill(110, 20, .5, 7)

  draw_smoke_stack(100, -5, 30, -200)
  draw_smoke_stack(100, -10, 70, -120)
  draw_smoke_stack(90, 0, 10, -60)
  draw_smoke_stack(114, -5, 30, -20)
  draw_smoke_stack(116, -5, 5, 10)

  -- for i = 128, 0, -1 do
  --   line(
  --     76 - (128 - i) * .3 + sin(t() / 2 + i / 20) * 3,
  --     i,
  --     76 - (128 - i) * .6 + sin(t() / 2 + i / 20) * 3,
  --     i,
  --     5
  --   )
  -- end

  -- for i = 128, 0, -1 do
  --   line(
  --     40 - (128 - i) * .1 + sin(t() / 2 + i / 20) * 3,
  --     i,
  --     40 - (128 - i) * .3 + sin(t() / 2 + i / 20) * 3,
  --     i,
  --     5
  --   )
  -- end

  -- for i = 128, 0, -1 do
  --   line(
  --     129 - (128 - i) * .02 + sin(t() / 2 + i / 25) * 3,
  --     i,
  --     130 - (128 - i) * .2 + sin(t() / 2 + i / 25) * 3,
  --     i,
  --     5
  --   )
  -- end

  -- sky
  fillp(▤)
  rectfill(0, 104, 128, 128, 2)
  fillp()
  rectfill(0, 108, 128, 128, 2)
  fillp(▤)
  rectfill(0, 114, 128, 128, 8)
  fillp()
  rectfill(0, 118, 128, 128, 8)

  -- sun
  draw_sun(92, 102)
end