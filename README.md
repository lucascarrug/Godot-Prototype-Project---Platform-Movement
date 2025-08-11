# Godot-Prototype-Project---Platform-Movement
<p>This repository has the basic platform movement with some features, such as "BufferJump" and "CoyoteTime" and some mechanics like "Dashing", "DoubleJumping", "WallSliding" and "WallJumping" that resemble the controls of Hollow Knight. Most of the code was developed by me, but I implemented elements from other sources to faithfully replicate the mechanics.</p>
<p>I would like to highlight that this project is not perfect, - I'm only experimenting - but I believe that the result is enough to provide a great base to work with.</p>
<br>

## Sources
<p>State machine: https://www.youtube.com/watch?v=bX-C6C03Jnc</p>
<p>Jump height: https://www.youtube.com/watch?v=bn3ZUCZ0vMo&t</p>
<p>Dash: https://www.youtube.com/watch?v=zLdI0TnD_0w&t</p>
<p>Better jump building: https://www.youtube.com/watch?v=fE8f5-ZHD_k&t</p>
<p>Wall sliding & walljump: https://www.youtube.com/watch?v=fYnURBEIogk&t</p>
<br>

## Notes
<p>If you want to try this project and explore its possibilities, be aware that not all parameter variations provide a good experience. That's why I created 3 easy levels just to give you a quick glimpse of what you can do.</p>
<p>In addition, the player can reload their dash only when touching the floor, but can reload their air jump when touching either the floor or a wall. These rules can be changed in Player's _physics_process().</p>
<br>

## Player Parameters
![Parameters](https://github.com/lucascarrug/Godot-Prototype-Project---Platform-Movement/blob/main/GitImages/Parameters.png)

### Speed
- **Max Jump Distance**: Maximum distance (in pixels) the player can reach with a single jump.

### Gravity
- **Fall Speed Increase**: Gravity multiplier applied when the player is falling.
- **Max Fall Speed**: Maximum falling velocity the player can reach.

### Jump
- **Max Air Jumps**: Maximum number of jumps the player can perform while in the air.
- **Jump Height**: Maximum height (in pixels) reached with a single jump.
- **Jump Peak Time**: Time it takes for the player to reach the highest jump height.
- **Jump Height Decrease**: How much the jump height is reduced when the jump button is released early.
- **Walljump Pushback Force**: Velocity multiplier applied to the player when performing a wall jump.

### Dash
- **Available Dash**: Enables or disables the ability to dash.
- **Dash Force**: Velocity multiplier applied while dashing.
- **Dash Time**: Duration of the dash.
- **Dash Recover Time**: Time required to recover the dash ability after use.

### Forces
- **Acceleration**: How much the player's velocity increases when moving.
- **Air Resistance**: How much velocity decreases while in the air.
- **Floor Friction**: How much velocity decreases when on the ground.

### Timers
- **Buffer Jump Timer Time**: Time margin allowed to perform a jump slightly before touching the ground.
- **Coyote Time Timer Time**: Time margin allowed to perform a jump shortly after leaving the ground.
