function _update60()
  for platform in all(platforms) do
    platform:update()
  end
  for enemy in all(enemies) do
    enemy:update()
  end
  for particle in all(particles) do
    particle:update()
  end
  player:update()
end