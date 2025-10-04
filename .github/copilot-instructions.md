# AI Agent Instructions for UnnamedDashGame

## Project Overview
This is a Godot-based 2D platformer/dash game. The core gameplay revolves around a character that can run, jump, and dash through levels.

## Code Architecture

### Character Controller (`Scenes/Testing/MainChar.gd`)
The main character controller follows these key patterns:

1. **State Management**
   - Uses an enum `PlayerState` for state machine: `IDLE`, `RUN`, `JUMP`, `DASH`, `DEATH`
   - State transitions are handled in `_calculate_state()` based on physics and input
   - State rendering is managed in `_match_state()` for animations

2. **Naming Conventions**
   - Internal/private functions are prefixed with underscore (e.g., `_get_input`, `_update_debug_label`)
   - Constants are in SCREAMING_CASE (e.g., `fall_limit`)
   - Variables use snake_case

3. **Movement System**
   - Base movement speed: 1500.0
   - Dash speed: 2x base speed
   - Gravity is asymmetric: 1800 up / 3000 down for better jump feel
   - Jump force: 800

4. **Component Organization**
   ```gdscript
   @onready var anim_player = $AnimationPlayer
   @onready var debug_label = $DebugLabel
   @onready var dash_timer = $DashTimer
   ```

## Common Development Tasks

### Extending Character States
1. Add new state to `PlayerState` enum
2. Add state transition logic in `_calculate_state()`
3. Add animation handling in `_match_state()`
4. Create corresponding animation in AnimationPlayer

### Debug Features
- Debug label shows current state, floor status, dash status, and vertical velocity
- Use `_update_debug_label()` to modify debug information display

## Project-Specific Conventions

1. **Physics Processing**
   - All movement/physics updates happen in `_physics_process()`
   - Order of operations:
     1. Input handling
     2. Position checking
     3. State calculation
     4. Animation updates
     5. Gravity application
     6. Debug updates

2. **Safety Checks**
   - Fall limit check at y > 200.0
   - State transitions validate current state before changing

## Important Files/Directories
- `/Scenes/Testing/MainChar.gd` - Main character controller script
- Animation files should be in the same directory as the scene

## Common Pitfalls
- Remember to use `_set_state()` instead of directly modifying `_state`
- Always check `is_on_floor()` before allowing jumps
- Dash state needs proper timeout handling via DashTimer