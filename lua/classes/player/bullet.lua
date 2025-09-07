Bullet = Actor:new({
  width = 5,
  height = 3,
  vx = 2.8,
  spr_offset = {
    default = { x = 0, y = 0 },
    flipped = { x = -3, y = 0 }
  },

  flipped = false,

  update = function(_ENV)
    x += vx * (flipped and -1 or 1)

    if cam:out_of_bounds(_ENV) then
      destroy(_ENV)
    end

    check_enemy_hit(_ENV)
  end,
  draw = function(_ENV)
    draw_spr(_ENV, 15)
  end,
  destroy = function(_ENV)
    del(bullets, _ENV)
  end,
  check_enemy_hit = function(_ENV)
    for enemy in all(enemies) do
      if not cam:out_of_bounds(enemy) and collide_other(_ENV, enemy) and enemy.hp > 0 then
        enemy:damage(1)
        destroy(_ENV)
        break
      end
    end
  end
})