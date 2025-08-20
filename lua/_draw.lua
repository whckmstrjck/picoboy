function _draw()
  camera()

  draw_sky()

  camera(max(min(player.x - 64, 48), 0), min(player.y - 72, 16))
  map()

  test_enemy:draw()
  player:draw()
end