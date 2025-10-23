function _init()
  G = _ENV

  player = Player:new({
    x = 24,
    y = -30
  })

  -- music(0)

  platforms = {
    Platform:new({ type = 'semisolid', width = 16, height = 5, sequence = { { 48, 56 }, { 64, 40 }, { 48, 24 } } }),
    -- Platform:new({ x = 40, y = 10, width = 16, range = 20 }),
    -- Platform:new({ x = 64, y = 24, width = 16, range = 44, type = 'semisolid' }),
    Platform:new({ x = 80, y = 16, width = 8, range = 3 * 8, type = 'solid', direction = 'horizontal', moving = true }),
    Platform:new({ x = 16 * 8, y = 16, width = 8 * 2, range = 6 * 8, type = 'solid', direction = 'vertical', moving = true })
  }
  -- platforms = {}
  enemies = {}
  particles = {}

  add(
    enemies, LilBot:new({
      x = 64,
      y = 40
    })
  )

  add(
    enemies, LilBot:new({
      x = 100,
      y = 1
    })
  )
  add(
    enemies, LilBot:new({
      x = 140,
      y = 1
    })
  )

  cam = Camera:new({ target_actor = player, state = 'follow' })

  -- poke(0x5f2e, 1)
  -- pal({ [0] = -15, 1, -14, -13, -11, -10, 15, 7, -8, 9, -9, 3, 12, -4, -2, -6 }, 1)
end