function draw_hp()
  local x = 3
  local y = 13
  local height = 40
  local width = 5

  local lost_hp_ratio = (player.max_hp - player.hp) / player.max_hp
  local lost_height = min(flr(lost_hp_ratio * height), height)
  local bg_color = 0

  if lost_hp_ratio > .7 and (t() * 2 % 1 < .5) then
    bg_color = 8
  end

  rectfill(x, y, x + width, y + height, bg_color)
  fillp(▤)
  rectfill(x + 1, y + 1, x + width - 1, y + height - 1, 14)
  rectfill(x + 2, y + 1, x + width - 2, y + height - 1, 15)
  fillp()

  rectfill(x, y, x + width, y + lost_height, bg_color)
end