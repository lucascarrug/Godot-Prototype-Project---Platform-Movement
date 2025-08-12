extends PlayerStateBase

func start():
	player.animated_sprite.play("falling")

func on_physics_process(delta):
	# Apply player state physics.
	player.move_x(delta)
	if not Input.is_action_pressed(player.controls.RIGHT) and not Input.is_action_pressed(player.controls.LEFT):
		player.idle(delta)
	player.flip()
	handle_gravity(delta * player.fall_speed_increase)
	player.move_and_slide()
	
	# Checks.
	if Input.is_action_just_pressed(player.controls.JUMP):
		player.buffer_jump_start()
	if player.jump_buffer and player.can_jump():
		state_machine.change_to(player.states.JUMPING)
	elif player.is_on_wall_only():
		state_machine.change_to(player.states.WALLSLIDING)
	elif (not Input.is_action_pressed(player.controls.RIGHT) and not Input.is_action_pressed(player.controls.LEFT)) and player.is_on_floor():
		state_machine.change_to(player.states.IDLE)
	elif (Input.is_action_pressed(player.controls.RIGHT) or Input.is_action_pressed(player.controls.LEFT)) and player.is_on_floor():
		state_machine.change_to(player.states.RUNNING)

func on_input(event):
	if Input.is_action_just_pressed(player.controls.DASH) and player.can_dash:
		state_machine.change_to(player.states.DASHING)
	elif Input.is_action_just_pressed("reset"):
		checkpoint_manager.return_player_to_last_checkpoint()
