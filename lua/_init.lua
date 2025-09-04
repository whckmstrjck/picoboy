function _init()
  G = _ENV
  player = Player:new()
  cam = Camera:new({ target_actor = player, state = 'follow' })
  test_enemy = LilBot:new({
    x = 100,
    y = 1
  })

  -- poke(0x5f2e, 1)
  -- pal({ [0] = -15, 1, -14, -13, -11, -10, 15, 7, -8, 9, -9, 3, 12, -4, -2, -6 }, 1)
end