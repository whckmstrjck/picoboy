function _init()
  G = _ENV

  player = Player:new({
    x = 24,
    y = -30
  })

  platforms = {
    Platform:new({ x = 40, y = 10, width = 16, range = 20, moving = true }),
    Platform:new({ x = 64, y = 50, width = 16, moving = true, type = 'semisolid' }),
    Platform:new({ x = 80, y = 10, width = 8, type = 'semisolid', direction = 'horizontal', moving = true })
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

  cam = Camera:new({ target_actor = player, state = 'follow' })

  -- poke(0x5f2e, 1)
  -- pal({ [0] = -15, 1, -14, -13, -11, -10, 15, 7, -8, 9, -9, 3, 12, -4, -2, -6 }, 1)
end