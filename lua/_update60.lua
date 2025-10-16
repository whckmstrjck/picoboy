function _update60()
  player:update()
  for enemy in all(enemies) do
    enemy:update()
  end

  for platform in all(platforms) do
    platform:update()
  end

  for particle in all(particles) do
    particle:update()
  end
end