SmallExplosion = Particle:new({
  ttl = 12,
  radius = 6,
  process_particle = function(_ENV)
  end,
  draw = function(_ENV)
    local r = t / ttl * radius
    local ll = (ttl - t) / ttl * 9

    line(x - ll, y, x + ll, y, 7)
    line(x, y - ll, x, y + ll, 7)

    circ(x, y, r + 3, 6)
    -- circ(x, y, r + 4, 6)

    circfill(x, y, r, 15)
    circfill(x, y, r - 1, 7)
    circfill(x, y, r - 3, 0)
  end
})