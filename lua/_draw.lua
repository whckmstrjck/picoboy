function _draw()
  cam:reset()

  draw_sky()

  cam:update()
  map()

  for platform in all(platforms) do
    platform:draw()
  end
  for enemy in all(enemies) do
    enemy:draw()
  end

  player:draw()
  player:draw_debug()

  for particle in all(particles) do
    particle:draw()
  end

  cam:reset()

  player:draw_debug_static()
  draw_ui()
end