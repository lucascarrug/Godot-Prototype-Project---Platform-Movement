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
	
	if player.is_running():
		state_machine.change_to(player.states.RUNNING)
	
	if Input.is_action_just_pressed(player.controls.JUMP):
		print("JUmo")
		player.jump_buffer_start()
		state_machine.change_to(player.states.JUMPING)
		
	if not player.coyote_time_timer.is_stopped() and Input.is_action_just_pressed(player.controls.JUMP):
		state_machine.change_to(player.states.JUMPING)

	if player.is_on_wall_only():
		state_machine.change_to(player.states.WALLSLIDING)
	
func end():
	pass

func on_input(event):
	if Input.is_action_just_pressed(player.controls.DASH):
		state_machine.change_to(player.states.DASHING)
	elif Input.is_action_just_pressed("reset"):
		player.position = Vector2(0,0)
