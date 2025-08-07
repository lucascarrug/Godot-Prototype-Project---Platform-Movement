extends PlayerStateBase

var is_falling_animation_played := false

func on_physics_process(delta):
	# Play player animation once.
	if not is_falling_animation_played:
		player.animated_sprite.play("falling")
		is_falling_animation_played = true
		
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
		player.jump_buffer_start()
		
	if not player.coyote_time_timer.is_stopped() and Input.is_action_just_pressed(player.controls.JUMP):
		state_machine.change_to(player.states.JUMPING)

func end():
	is_falling_animation_played = false
