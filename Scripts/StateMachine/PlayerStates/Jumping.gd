extends PlayerStateBase

func start():
	player.animated_sprite.play("jumping")

func on_physics_process(delta):
	# Apply player state physics.
	player.move_x(delta)
	player.flip()
	player.jump()
	handle_gravity(delta)
	player.move_and_slide()
	
	# Checks
	if player.is_idying():
		state_machine.change_to(player.states.IDLE)
	elif player.is_falling():
		state_machine.change_to(player.states.FALLING)
	elif Input.is_action_just_pressed(player.controls.JUMP):
		player.buffer_jump_start()
	elif not Input.is_action_pressed(player.controls.JUMP):
		player.on_jump_released()
	elif player.is_on_wall_only():
		state_machine.change_to(player.states.WALLSLIDING)

func on_input(event):
	if Input.is_action_just_pressed(player.controls.DASH) and player.can_dash:
		state_machine.change_to(player.states.DASHING)
	elif Input.is_action_just_pressed(player.controls.JUMP):
		state_machine.change_to(player.states.JUMPING)
