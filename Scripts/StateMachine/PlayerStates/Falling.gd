extends PlayerStateBase

func start():
	player.animated_sprite.play("falling")

func on_physics_process(delta):
	# Apply player state physics.
	player.move_x()
	player.flip()
	handle_gravity(delta * player.fall_speed_increase)
	player.move_and_slide()
	
	# Checks.
	if player.is_idying():
		state_machine.change_to(player.states.IDLE)
	elif player.is_running():
		state_machine.change_to(player.states.RUNNING)
	elif Input.is_action_just_pressed(player.controls.JUMP):
		player.jump_buffer_start()
		if player.can_jump():
			state_machine.change_to(player.states.JUMPING)
	elif player.is_on_wall_only():
		state_machine.change_to(player.states.WALLSLIDING)

func on_input(event):
	if Input.is_action_just_pressed(player.controls.DASH):
		state_machine.change_to(player.states.DASHING)
	elif Input.is_action_just_pressed("reset"):
		player.position = Vector2(0,0)
