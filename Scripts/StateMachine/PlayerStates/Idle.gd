extends PlayerStateBase

func on_physics_process(delta):
	# Play player animation.
	player.animated_sprite.play("idle")
	
	# Apply player state physics.
	player.idle()
	handle_gravity(delta)
	player.move_and_slide()
	
	# Checks.
	if player.is_falling():
		state_machine.change_to(player.states.FALLING)
		
	if player.is_running():
		state_machine.change_to(player.states.RUNNING)
	
	if Input.is_action_just_pressed(player.controls.JUMP):
		player.jump_buffer_start()
	if player.jump_buffer:
		state_machine.change_to(player.states.JUMPING)
		
	
func on_input(event):
	if Input.is_action_pressed(player.controls.RIGHT) or Input.is_action_pressed(player.controls.LEFT):
		state_machine.change_to(player.states.RUNNING)
	elif Input.is_action_just_pressed(player.controls.DASH):
		state_machine.change_to(player.states.DASHING)
