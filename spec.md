# Volley Ball 2D

## Current State
A 2D volleyball game with menu, game, and game-over screens. Supports vs AI and vs Friend (local) modes. Canvas-based with keyboard controls (WASD for P1, arrows for P2). Ball physics use automatic collision on proximity. No difficulty settings, no fullscreen, no mobile support, no online multiplayer.

## Requested Changes (Diff)

### Add
- Platform selection screen (Mobile / PC) shown before main menu
- AI difficulty selection screen: Easy / Medium / Hard (shown when VS AI is chosen)
- Explicit hit button requirement: player must press a specific key/button to hit the ball (Space for P1, RightCtrl/NumpadEnter for P2); automatic proximity collision is removed for hitting - the ball will only respond to a hit if the hit button is pressed while the player is close to the ball
- Mobile controls overlay: virtual joystick (left side) for movement + jump, and a large HIT button (right side)
- Online multiplayer mode: host creates a room and gets a 4-character code; guest enters code to join; host runs game loop locally and syncs state to backend; guest sends inputs and renders host's state
- Backend room system: createRoom, joinRoom, sendState, getState, sendInput, getInput endpoints

### Modify
- Game canvas fills entire viewport (true fullscreen layout, no top bar)
- Ball physics: fix erratic movement by adding a hit cooldown per player (cannot hit same player twice in <20 frames), and capping max speed more tightly
- Menu: add Online Multiplayer button alongside VS Friend and VS AI
- AI difficulty levels affect AI speed, reaction time, and jump accuracy

### Remove
- Top bar HUD (score is drawn on canvas instead)
- Automatic ball deflection on proximity - only deflects if hit button pressed

## Implementation Plan
1. Backend: add room management actor with createRoom, joinRoom, sendState, getState, sendInput, getInput
2. Frontend screens: PlatformSelect → Menu → (DifficultySelect if AI) → Game | GameOver
3. Online flow: host creates room, shares code; guest joins; host sends full game state each frame via backend; guest polls and renders; guest sends input; host polls and applies
4. Mobile layout: detect touch, show joystick + HIT button overlay on canvas
5. Hit button: only trigger ball deflection if the hit key/button was pressed this frame AND player is within range
6. Fullscreen: canvas fills 100vw/100vh with aspect-ratio scaling
7. Difficulty: Easy = slow AI + random mistakes, Medium = current, Hard = near-perfect tracking
