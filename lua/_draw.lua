function _draw()
  cls(1)
  camera()

  fillp(▤)
  rectfill(0, 0, 128, 26, 0)
  rectfill(0, 110, 128, 128, 2)
  fillp()
  rectfill(0, 0, 128, 20, 0)
  rectfill(0, 116, 128, 128, 2)
  circfill(104, 24, 10, 15)
  circfill(104, 24, 8, 7)

  camera(max(min(player.x - 64, 48), 0), player.y - 64)

  map()
  player:draw()
end