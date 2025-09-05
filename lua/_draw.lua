function _draw()
  camera()

  draw_sky()

  cam:update()
  map()

  for enemy in all(enemies) do
    enemy:draw()
  end

  player:draw()
  player:draw_debug()

  cam:reset()

  player:draw_debug_static()
end