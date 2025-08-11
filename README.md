# Godot-Prototype-Project---Platform-Movement
<p>This repository has the basic platform movement with some features, such as "BufferJump" and "CoyoteTime" and some mechanics like "Dashing", "DoubleJumping", "WallSliding" and "WallJumping" that resemble the controls of Hollow Knight. Most of the code was developed by me, but I implemented elements from other sources to faithfully replicate the mechanics.</p>
<p>I would like to highlight that this project is not perfect, - I'm only experimenting - but I believe that the result is enough to provide a great base to work with.</p>

## Sources
<p>State machine: https://www.youtube.com/watch?v=bX-C6C03Jnc</p>
<p>Jump height: https://www.youtube.com/watch?v=bn3ZUCZ0vMo&t</p>
<p>Dash: https://www.youtube.com/watch?v=zLdI0TnD_0w&t</p>
<p>Better jump building: https://www.youtube.com/watch?v=fE8f5-ZHD_k&t</p>
<p>Wall sliding & walljump: https://www.youtube.com/watch?v=fYnURBEIogk&t</p>

## Notes
<p>If you want to try this project and explore its possibilities, be aware that not all parameter variations provide a good experience. That's why I created 3 easy levels just to give you a quick glimpse of what you can do.</p>
<p>In addition, the player can reload their dash only when touching the floor, but can reload their air jump when touching either the floor or a wall. These rules can be changed in Player's _physics_process().</p>
