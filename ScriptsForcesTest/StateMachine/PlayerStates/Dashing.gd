extends PlayerStateBase

func start():
	player.dash()

func on_physics_process(delta):
	# Checks.
	if not player.is_dashing:
		if player.is_falling():
			state_machine.change_to(player.states.FALLING)
		elif player.is_jumping():
			state_machine.change_to(player.states.JUMPING)
		elif player.is_running():
			state_machine.change_to(player.states.RUNNING)
		elif player.is_on_wall_only():
			state_machine.change_to(player.states.WALLSLIDING)
		else:
			state_machine.change_to(player.states.IDLE)
			
	# Apply player state physics.
	player.move_and_slide()
	print("velocity: ", player.velocity.x)

func on_input(event):
	pass
