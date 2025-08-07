extends PlayerStateBase

func on_physics_process(delta):
	# Play player animation.
	player.animated_sprite.play("running")
	
	# Apply player state physics.
	player.move_x()
	player.flip()
	handle_gravity(delta)
	player.move_and_slide()
	
	# Checks.
	if player.is_falling():
		state_machine.change_to(player.states.FALLING)
		
	if player.is_idying():
		state_machine.change_to(player.states.IDLE)
	
	if Input.is_action_just_pressed(player.controls.JUMP):
		player.jump_buffer_start()
	if player.jump_buffer:
		state_machine.change_to(player.states.JUMPING)

func on_input(event):
	if not Input.is_action_pressed(player.controls.RIGHT) and not Input.is_action_pressed(player.controls.LEFT):
		state_machine.change_to(player.states.IDLE)
