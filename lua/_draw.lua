function _draw()
  camera()

  -- sky
  cls(1)
  fillp(▤)
  rectfill(0, 0, 128, 24, 0)
  fillp()
  rectfill(0, 0, 128, 20, 0)

  for i = 128, 0, -1 do
    line(
      76 - (128 - i) * .3 + sin(t() / 2 + i / 20) * 3,
      i,
      76 - (128 - i) * .6 + sin(t() / 2 + i / 20) * 3,
      i,
      5
    )
  end

  for i = 128, 0, -1 do
    line(
      40 - (128 - i) * .1 + sin(t() / 2 + i / 20) * 3,
      i,
      40 - (128 - i) * .3 + sin(t() / 2 + i / 20) * 3,
      i,
      5
    )
  end

  for i = 128, 0, -1 do
    line(
      129 - (128 - i) * .02 + sin(t() / 2 + i / 25) * 3,
      i,
      130 - (128 - i) * .2 + sin(t() / 2 + i / 25) * 3,
      i,
      5
    )
  end

  -- sky
  fillp(▤)
  rectfill(0, 104, 128, 128, 2)
  fillp()
  rectfill(0, 108, 128, 128, 2)
  fillp(▤)
  rectfill(0, 114, 128, 128, 8)
  fillp()
  rectfill(0, 118, 128, 128, 8)

  -- stars
  -- circfill(10, 10, .5, 7)
  -- circfill(16, 22, .5, 7)
  -- circfill(36, 32, 1, 7)
  circfill(52, 8, 1, 7)
  circfill(56, 16, .5, 7)
  circfill(82, 18, 1, 7)
  circfill(94, 16, .5, 7)
  -- circfill(110, 20, .5, 7)

  -- sun
  circfill(98, 102, 14, 8)
  circfill(98, 102, 12, 2)
  circfill(98, 102, 10, 15)
  circfill(98, 102, 8 + sin(t()) * .9, 7)

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

  player:draw()
  test_enemy:draw()
end