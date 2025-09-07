Enemy = Actor:new({
  hp = 1,
  damage_time = 0,
  damage_cooldown = 8,

  damage = function(_ENV, amount)
    hp -= amount
    damage_time = damage_cooldown
    if hp <= 0 then
      add(
        particles, SmallExplosion:new({
          x = x + flr(width / 2),
          y = y + flr(height / 2)
        })
      )
      sfx(3, 3)
    else
      sfx(2, 3)
    end
  end,

  draw = function(_ENV)
    local half_time = flr(damage_cooldown / 2)
    if damage_time > half_time then
      pal_damage()
      draw_enemy(_ENV)
      pal()
    elseif damage_time == 0 then
      draw_enemy(_ENV)
    end

    if hp <= 0 and damage_time <= 1 then
      destroy(_ENV)
    end
  end,

  destroy = function(_ENV)
    del(enemies, _ENV)
  end
})