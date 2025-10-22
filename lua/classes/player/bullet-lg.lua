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
    if (t() * 60) % 6 < 3 then
      pal(7, 12)
      pal(15, 13)
      pal(14, 1)
    end
    draw_spr(_ENV, spr_id)
    pal()
  end
})