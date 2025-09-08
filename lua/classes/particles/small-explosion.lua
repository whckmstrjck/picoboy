SmallExplosion = Particle:new({
  ttl = 10,
  radius = 6,
  process_particle = function(_ENV)
  end,
  draw = function(_ENV)
    local r = t / ttl * radius
    local ll = (ttl - t) / ttl * 12
    local ll2 = ll * .64

    line(x - ll, y, x + ll, y, 7)
    line(x, y - ll, x, y + ll, 7)
    rectfill(x - ll2, y - 1, x + ll2, y + 1, 7)
    rectfill(x - 1, y - ll2, x + 1, y + ll2, 7)

    circ(x, y, r + 3, 7)
    -- circ(x, y, r + 4, 6)

    circfill(x, y, r, 15)
    circfill(x, y, r - 1, 7)
    circfill(x, y, r - 2, 0)
  end
})