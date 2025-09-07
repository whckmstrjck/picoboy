Particle = Class:new({
  x = 0,
  y = 0,
  t = 0,
  ttl = 0,
  update = function(_ENV)
    t += 1
    if t >= ttl then
      destroy(_ENV)
    elseif update_particle then
      process_particle(_ENV)
    end
  end,
  draw = function(_ENV)
    -- override this
  end,
  destroy = function(_ENV)
    del(particles, _ENV)
  end
})