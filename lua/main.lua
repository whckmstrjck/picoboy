G = _ENV

function _init()
  player = Player:new()
end

function _update60()
  player:update()
end

function _draw()
  cls()
  map()
  camera(max(min(player.x - 64, 48), 0), player.y - 64)
  player:draw()
end