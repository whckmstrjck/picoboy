function _init()
  G = _ENV

  player = Player:new({
    x = 24,
    y = -30
  })

  platforms = { Platform:new({ x = 30, y = 16, moving = true }) }
  enemies = {}
  particles = {}

  -- for i = 1, 5 do
  --   add(
  --     enemies, LilBot:new({
  --       x = rnd(140),
  --       y = rnd(120)
  --     })
  --   )
  -- end
  add(
    enemies, LilBot:new({
      x = 100,
      y = 1
    })
  )

  cam = Camera:new({ target_actor = player, state = 'follow' })

  -- poke(0x5f2e, 1)
  -- pal({ [0] = -15, 1, -14, -13, -11, -10, 15, 7, -8, 9, -9, 3, 12, -4, -2, -6 }, 1)
end