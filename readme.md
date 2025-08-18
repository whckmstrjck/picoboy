# PICOBOY

A Mega Man-like code exploration adventure in Pico 8.

## Controls

⬆️ Climb up ladders  
⬇️ Climb down ladders / Combine with 🅾️ to drop through semisolids  
⬅️ Move left  
➡️ Move right

🅾️ Jump (hold to jump higher) / Let go of ladders  
❎ Shoot

## Todo

- [ ] Add basic enemy w/ goomba-like behaviour
  - [x] Class
  - [x] Turn around on edge or solid
  - [ ] Deal damage to player
  - [ ] Take damage from shots
  - [ ] Destroy on 0 hp
- [ ] Coyote time
- [ ] Jump buffering
- [ ] Moving platforms
- [ ] Basic tileset
- [ ] Add particle system
- [ ] Add edge nudge going up
- [ ] Add nudge "climbing" up
- [ ] Fix "turbo-fire" on jump/shoot?

## Done

- [x] Fix jump controls, variable jumpheight
- [x] Add states to player
- [x] Change collision behaviour to return new values instead of manipulating them directly
- [x] Ladders
  - [x] Approximation of x not reliable
  - [x] Add climb up start
  - [x] add climb end
  - [x] Cannon offset climb
  - [x] Stop when shooting
  - [x] Correct climb sprite flipping, moving, shooting
- [x] Player sprite v1
- [x] Move
- [x] Jump + gravity
- [x] Classify generic actor v1
- [x] Semisolids
