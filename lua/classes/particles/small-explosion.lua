SmallExplosion = Particle:new({
  ttl = 12,
  radius = 6,
  process_particle = function(_ENV)
  end,
  draw = function(_ENV)
    local r = t / ttl * radius

    circ(x, y, r + 3, 6)

    circfill(x, y, r, 15)
    circfill(x, y, r - 2, 7)
  end
})