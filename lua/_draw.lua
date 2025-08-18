function _draw()
  camera()

  draw_sky()

  local str = '~~ pICObOY lIVES ~~ 2025 ~~ @TOBIASM.ART ~~'

  for i = 1, #str do
    print(
      str[i],
      128 - t() * 60 % (128 + #str * 4) + i * 4,
      2 + sin(t() * 3 + i * .1),
      7 + (i + t() * 14) % 8
    )
  end

  camera(max(min(player.x - 64, 48), 0), min(player.y - 72, 16))
  map()

  test_enemy:draw()
  player:draw()
end