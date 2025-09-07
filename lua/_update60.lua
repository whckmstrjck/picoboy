function _update60()
  for enemy in all(enemies) do
    enemy:update()
  end
  for particle in all(particles) do
    particle:update()
  end
  player:update()
end