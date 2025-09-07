SmallExplosion = Particle:new({
  ttl = 12,

  process_particle = function(_ENV)
  end,
  draw = function(_ENV)
    circfill(x, y, 1 + flr(t / 4), 8)
  end
})