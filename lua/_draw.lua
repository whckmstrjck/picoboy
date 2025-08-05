function _draw()
  cls(1)
  camera()

  fillp(▤)
  rectfill(0, 0, 128, 26, 0)
  fillp()
  rectfill(0, 0, 128, 20, 0)

  camera(max(min(player.x - 64, 48), 0), player.y - 64)
  map()

  player:draw()
end