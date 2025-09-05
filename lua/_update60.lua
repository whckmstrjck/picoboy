function _update60()
  for enemy in all(enemies) do
    enemy:update()
  end
  player:update()
end