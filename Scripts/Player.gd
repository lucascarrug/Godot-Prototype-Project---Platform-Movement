extends CharacterBody2D
class_name Player

##### PLAYER UTILS #####

var states: PlayerStateNames = PlayerStateNames.new()
var controls: PlayerControls = PlayerControls.new()
var stats: PlayerStats = PlayerStats.new()

##### PLAYER STATS #####

@export_group("Player Stats")

@export_subgroup("Speed")
# Max distance (in pixels) that player can reach with a single jump.
@export var max_jump_distance := stats.MAX_JUMP_DISTANCE

@export_subgroup("Gravity")
# Gravity multiplier when player is falling.
@export var fall_speed_increase := stats.FALL_SPEED_INCREASE
# Maximum velocity the player can fall.
@export var max_fall_speed := stats.MAX_FALL_SPEED

@export_subgroup("Jump")
# Maximum number of jumps the player can perform while in the air.
@export var max_air_jumps := stats.MAX_AIR_JUMPS
# Maximum height (in pixels) reached with a single jump.
@export var jump_height := stats.JUMP_HEIGHT
# Time it takes for the player to reach the highest jump height.
@export var jump_peak_time := stats.JUMP_PEAK_TIME
# How much the jump height is reduced when the jump button is released early.
@export var jump_height_decrease := stats.JUMP_HEIGHT_DECREASE
# Velocity multiplier applied to the player when performing a wall jump.
@export var walljump_pushback_force := stats.WALLJUMP_PUSHBACK_FORCE

@export_subgroup("Dash")
# Enables or disables the ability to dash.
@export var available_dash := true
#Velocity multiplier when player dashes.
@export var dash_force := stats.DASH_FORCE
# Dash duration.
@export var dash_time := stats.DASH_TIME
# Time required to recover the dash ability after use.
@export var dash_recover_time := stats.DASH_RECOVER_TIME

@export_subgroup("Forces")
# How increased is velocity when player moves.
@export var acceleration := stats.ACCELETARION
# How velocity is decreased in air.
@export var air_resistance := stats.AIR_RESISTANCE
# How velocity is decreased on floor.
@export var floor_friction := stats.FLOOR_FRICTION

@export_subgroup("Timers")
# Time margin allowed to perform a jump slightly before touching the ground.
@export var buffer_jump_timer_time := stats.BUFFER_JUMP_TIMER_TIME
# Time margin allowed to perform a jump shortly after leaving the ground.
@export var coyote_time_timer_time := stats.COYOTE_TIME_TIMER_TIME

##### ANIMATION #####

@onready var animated_sprite := $AnimatedSprite2D

##### TIMERS #####

@onready var buffer_jump_timer := $Timers/BufferJumpTimer
@onready var coyote_time_timer := $Timers/CoyoteTimeTimer
@onready var dash_timer := $Timers/DashTimer
@onready var dash_recover_timer := $Timers/DashRecoverTimer

##### RAYCASTS #####

@onready var raycast_right := $RayCasts/Right
@onready var raycast_left := $RayCasts/Left

##### BASIC PHYSICS VARIABLES #####

var gravity: float
var jump_speed: float
var move_speed: float

##### BASIC CONTROL VARIABLES #####

var last_direction := 0.0
var last_point := 0.0
var current_air_jumps := 0

##### FANCY PHYSICS VARIABLES #####

var jump_buffer := false
var coyote_time_jump := true
var has_jumped := false
var was_on_floor := true

##### FANCY MOVEMENT CONTROL VARIABLES #####

var is_dashing := false
var can_recover_dash := true
var can_dash := false
var is_walljumping := false

##### ANIMATION #####

var _is_facing_right := true

##### METHODS #####

func _ready() -> void:
	# Set basic physics.
	reset_physics()
	
	# Set timers.
	dash_timer.wait_time = dash_time
	dash_recover_timer.wait_time = dash_recover_time
	buffer_jump_timer.wait_time = buffer_jump_timer_time
	coyote_time_timer.wait_time = coyote_time_timer_time 

func _physics_process(delta: float) -> void:
	## Coyote Time.
	if was_on_floor and not is_on_floor():
		coyote_time_start()
	was_on_floor = is_on_floor()
	
	## Air jump.
	if is_on_wall():
		current_air_jumps = 0
		if can_recover_dash:
			if available_dash: can_dash = true
	
	if is_on_floor():
		coyote_time_jump = true
		has_jumped = false
		current_air_jumps = 0
		
		if can_recover_dash:
			if available_dash: can_dash = true

	## General.
	calculate_x_displacement()

##### BASIC PHYSICS #####

func idle(delta) -> void:
	apply_friction(delta)

func move_x(delta) -> void:
	if is_walljumping:
		return
		
	accelerate(delta)

func flip() -> void:
	if has_changed_x_direction():
		scale.x *= -1
		_is_facing_right = not _is_facing_right
	
	var direction = sign(velocity.x)
	if direction == 0:
		return
	walljump_pushback_force = abs(walljump_pushback_force) * direction

func jump() -> void:
	if jump_buffer and (is_on_floor() or (coyote_time_jump and not has_jumped)):
		velocity.y = -jump_speed
	elif is_on_wall_only():
		walljump()
	elif jump_buffer and current_air_jumps < max_air_jumps:
		velocity.y = -jump_speed
		if coyote_time_timer.is_stopped(): current_air_jumps += 1
		
	jump_buffer = false
	has_jumped = true
	
func handle_gravity(delta) -> void:
	if not is_on_floor():
		velocity.y = min(velocity.y + gravity * delta, max_fall_speed)

##### FANCY PHYSICS #####

func buffer_jump_start() -> void:
	buffer_jump_timer.start()
	jump_buffer = true
	
func coyote_time_start() -> void:
	coyote_time_timer.start()
	coyote_time_jump = true
	
func on_jump_released() -> void:
	velocity.y /= jump_height_decrease

func dash() -> void:
	if is_dashing or not can_dash:
		return
		
	is_dashing = true
	can_recover_dash = false
	can_dash = false
	animated_sprite.play("dashing")
	
	var dash_direction = Input.get_action_strength(controls.RIGHT) - Input.get_action_strength(controls.LEFT)
	if abs(dash_direction) != 0:
		dash_direction /= abs(dash_direction)
	else:
		dash_direction = last_direction
	
	velocity = Vector2(move_speed * dash_direction * dash_force, 0)
	dash_timer.start()
	dash_recover_timer.start()

func calculate_x_displacement() -> void:
	if last_point != position.x:
		var current_point = position.x
		last_direction = current_point - last_point
		last_direction /= abs(last_direction)
	last_point = position.x

func wall_slide_gravity(delta) -> void:
	if is_jumping():
		handle_gravity(delta)
	if is_falling():
		velocity.y = min(velocity.y + gravity * delta, stats.MAX_FALL_SPEED / 7)

func walljump() -> void:
	if raycast_left.is_colliding():
		velocity = Vector2(-move_speed * walljump_pushback_force, -jump_speed)
	elif raycast_right.is_colliding():
		velocity = Vector2(-move_speed * walljump_pushback_force, -jump_speed)
		
	is_walljumping = true
	await get_tree().create_timer(0.15).timeout
	is_walljumping = false

func apply_friction(delta):
	var friction = floor_friction if is_on_floor() else air_resistance
	velocity.x = move_toward(velocity.x, 0, friction * delta)
	
func accelerate(delta):
	var dir = Input.get_axis(controls.LEFT, controls.RIGHT)
	if dir != 0:
		velocity.x = clamp(velocity.x + dir * acceleration * delta, -move_speed, move_speed)

##### SIGNALS #####

func _on_buffer_jump_timer_timeout() -> void:
	jump_buffer = false

func _on_coyote_time_timer_timeout() -> void:
	coyote_time_jump = false
	
func _on_dash_timer_timeout() -> void:
	velocity.x = 0
	move_and_slide()
	is_dashing = false
	
func _on_dash_recover_timer_timeout() -> void:
	can_recover_dash = true

##### IS_STATE #####

func is_idying() -> bool:
	return is_on_floor() and velocity.y >= 0 and is_zero_approx(velocity.x)

func is_running() -> bool:
	return velocity.x != 0.0 and is_on_floor()

func is_jumping() -> bool:
	return velocity.y < 0

func is_falling() -> bool:
	return velocity.y >= 0 and not is_on_floor()


##### CAN_ACTION #####

func can_jump():
	return (jump_buffer and (is_on_floor() or (coyote_time_jump and not has_jumped))
	or is_on_wall_only()
	or jump_buffer and current_air_jumps < max_air_jumps)
	
func has_changed_x_direction():
	return ((_is_facing_right and Input.is_action_pressed(controls.LEFT)) 
	or (not _is_facing_right and Input.is_action_pressed(controls.RIGHT)))

func reset_physics() -> void:
	gravity = (2 * jump_height) / (jump_peak_time * jump_peak_time)
	jump_speed = gravity * jump_peak_time
	move_speed = max_jump_distance / (2 * jump_peak_time)
