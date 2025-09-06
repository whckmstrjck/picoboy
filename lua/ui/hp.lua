function draw_hp()
  local lost_hp = (player.max_hp - player.hp) / player.max_hp
  local height = flr(lost_hp * 57)
  local color = lost_hp > .7 and 8 or 0

  if t() * 2 % 1 < .5 then
    color = 0
  end

  rectfill(3, 23, 9, 81, color)
  fillp(▤)
  rectfill(4, 24, 8, 80, 15)
  rectfill(5, 24, 7, 80, 7)
  fillp()

  rectfill(3, 23, 8, 23 + height, color)
end