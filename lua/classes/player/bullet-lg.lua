BulletLg = Bullet:new({
  width = 8,
  height = 7,
  damage = 4,
  spr_offset = {
    default = { x = 0, y = -2 },
    flipped = { x = -3, y = -2 }
  },
  spr_id = 31,
  draw = function(_ENV)
    if (t() * 60) % 10 < 5 then
      pal(7, 9)
      pal(15, 10)
      pal(14, 8)
    end
    draw_spr(_ENV, spr_id)
    pal()
  end
})