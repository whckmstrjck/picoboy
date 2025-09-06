function draw_hp()
  local x = 3
  local y = 23
  local height = 50
  local width = 5

  local lost_hp = (player.max_hp - player.hp) / player.max_hp
  local lost_height = min(flr(lost_hp * 57), height)
  local bg_color = lost_hp > .7 and 8 or 0

  if t() * 2 % 1 < .5 then
    bg_color = 0
  end

  rectfill(x, y, x + width, y + height, bg_color)
  fillp(▤)
  rectfill(x + 1, y + 1, x + width - 1, y + height - 1, 15)
  rectfill(x + 2, y + 1, x + width - 2, y + height - 1, 7)
  fillp()

  rectfill(x, y, x + width, y + lost_height, bg_color)
end