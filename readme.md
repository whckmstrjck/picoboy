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

- [ ] Add nudge "climbing" up ledge
- [ ] Jump buffering
- [ ] Add particle system
- [ ] Add edge nudge going up
- [ ] Moving platforms

## Done

- [x] Refactor hp ui
- [x] Add basic ui for hp
- [x] Add basic enemy w/ goomba-like behaviour
  - [x] Class
  - [x] Turn around on edge or solid
  - [x] Take damage from shots
  - [x] Destroy on 0 hp
  - [x] Deal damage to player
- [x] Rethink input reading (Fix "turbo-fire" on jump/shoot etc)
- [x] Basic tileset
- [x] Classify bullets and rethink updating
- [x] Bullets should be destroyed when leaving camera, not by distance to player
- [x] Add camera class, states, player ref, helper methods
- [x] Coyote time
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
