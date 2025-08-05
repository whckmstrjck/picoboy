function _draw()
  camera()

  cls(1)
  fillp(▤)
  rectfill(0, 0, 128, 26, 0)
  rectfill(0, 104, 128, 128, 2)
  fillp()
  rectfill(0, 0, 128, 20, 0)
  rectfill(0, 110, 128, 128, 2)
  fillp(▤)
  rectfill(0, 114, 128, 128, 8)
  fillp()
  rectfill(0, 120, 128, 128, 8)

  circfill(98, 102, 14, 8)
  circfill(98, 102, 12, 2)
  circfill(98, 102, 10, 15)
  circfill(98, 102, 8, 7)

  camera(max(min(player.x - 64, 48), 0), player.y - 64)

  map()
  player:draw()
end