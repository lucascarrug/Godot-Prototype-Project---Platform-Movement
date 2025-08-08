extends PlayerStateBase

func start():
	player.dash()

func on_physics_process(delta):
	if not player.is_dashing:
		if player.is_falling():
			state_machine.change_to(player.states.FALLING)
		elif player.is_jumping():
			state_machine.change_to(player.states.JUMPING)
		elif player.is_running():
			state_machine.change_to(player.states.RUNNING)
		else:
			state_machine.change_to(player.states.IDLE)

	player.move_and_slide()
	
	
func end():
	pass

func on_input(event):
	pass
