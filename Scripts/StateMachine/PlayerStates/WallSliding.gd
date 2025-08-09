extends PlayerStateBase

func enter():
	player.animated_sprite.play("wall_sliding")

func on_physics_process(delta):
	# Apply player state physics.
	player.move_x()
	player.flip()
	
	if Input.is_action_just_pressed(player.controls.JUMP):
		player.jump_buffer_start()
	if player.jump_buffer:
		state_machine.change_to(player.states.JUMPING)
	
	player.wall_slide_gravity(delta)
	player.move_and_slide()

	# Checks.
	if not player.is_on_wall() and not player.is_on_floor():
		state_machine.change_to(player.states.FALLING)

func on_input(event):
	pass
