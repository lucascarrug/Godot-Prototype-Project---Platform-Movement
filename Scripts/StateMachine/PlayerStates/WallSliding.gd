extends PlayerStateBase

func enter():
	player.animated_sprite.play("wall_sliding")

func on_physics_process(delta):
	# Apply player state physics.
	player.move_x(delta)
	player.flip()
	
	player.wall_slide_gravity(delta)
	player.move_and_slide()
	
	# Checks.
	if Input.is_action_just_pressed(player.controls.JUMP):
		player.buffer_jump_start()
		state_machine.change_to(player.states.JUMPING)
	elif not player.is_on_wall() and not player.is_on_floor():
		state_machine.change_to(player.states.FALLING)
	elif player.is_on_floor():
		state_machine.change_to(player.states.IDLE)

func on_input(event):
	if Input.is_action_just_pressed("reset"):
		player.position = Vector2(0,0)
