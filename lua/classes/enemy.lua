Enemy = Actor:new({
  hp = 1,
  damage_time = 0,
  damage_cooldown = 4,

  damage = function(_ENV, amount)
    hp -= amount
    damage_time = damage_cooldown
    if hp <= 0 then
      sfx(3, 3)
      del(enemies, _ENV)
    else
      sfx(2, 3)
    end
  end
})