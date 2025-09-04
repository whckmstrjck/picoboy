function _draw()
  camera()

  draw_sky()

  cam:update()
  map()

  test_enemy:draw()
  player:draw()
  player:draw_debug()
  cam:reset()
  player:draw_debug_static()
end