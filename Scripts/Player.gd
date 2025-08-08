extends CharacterBody2D
class_name Player

# Player utils.
var states: PlayerStateNames = PlayerStateNames.new()
var controls: PlayerControls = PlayerControls.new()
var stats: PlayerStats = PlayerStats.new()

# Player stats.
@export_group("Player Stats")
@export var jump_distance: float = stats.JUMP_DISTANCE
@export var fall_speed_increase: float = stats.FALL_SPEED_INCREASE
@export var jump_peak_time: float = stats.JUMP_PEAK_TIME
@export var jump_height: float = stats.JUMP_HEIGHT
@export var jump_height_decrease: float = stats.JUMP_HEIGHT_DECREASE

# Nodes.
@onready var animated_sprite := $AnimatedSprite2D
@onready var buffer_jump_timer := $BufferJumpTimer
@onready var coyote_time_timer := $CoyoteTimeTimer
@onready var dash_timer := $DashTimer
@onready var dash_recover_timer := $DashRecoverTimer

# Basic physics variables.
var gravity: float
var jump_speed: float
var move_speed: float

# Fancy physics variables. 
var jump_buffer := false
var coyote_time_jump := true
var was_on_floor := true
var is_dashing := false
var can_dash := true
var last_direction := 0.0
var last_point := 0.0

# Animation variables.
var _is_facing_right := true

##### METHODS #####

func _ready() -> void:
	gravity = (2 * jump_height) / (jump_peak_time * jump_peak_time)
	jump_speed = gravity * jump_peak_time
	move_speed = jump_distance / (2 * jump_peak_time)
	
func _physics_process(delta: float) -> void:
	## Coyote Time
	if was_on_floor and not is_on_floor():
		coyote_time_start()
	was_on_floor = is_on_floor()
	
	calculate_x_displacement()

##### BASIC PHYSICS #####

func idle() -> void:
	velocity.x = 0
	move_x()

func move_x() -> void:
	var horizontal_direction = Input.get_action_strength(controls.RIGHT) - Input.get_action_strength(controls.LEFT)
	velocity.x = move_speed * horizontal_direction

func flip() -> void:
	if (_is_facing_right and velocity.x < 0) or (not _is_facing_right and velocity.x > 0):
		scale.x *= -1
		_is_facing_right = not _is_facing_right

func jump() -> void:
	if (is_on_floor() or coyote_time_jump) and jump_buffer:
		animated_sprite.play("jumping")
		velocity.y = -jump_speed
		jump_buffer = false

func handle_gravity(delta) -> void:
	if not is_on_floor():
		velocity.y = min(velocity.y + gravity * delta, velocity.y + stats.MAX_FALL_SPEED)

##### FANCY PHYSICS #####

func jump_buffer_start() -> void:
	buffer_jump_timer.start()
	jump_buffer = true
	
func coyote_time_start() -> void:
	coyote_time_timer.start()
	coyote_time_jump = true
	
func on_jump_released() -> void:
	velocity.y /= jump_height_decrease

func dash() -> void:
	print("is_dashing: ", not is_dashing, " can_dash: ", can_dash)
	
	if is_dashing or not can_dash:
		return
		
	is_dashing = true
	can_dash = false
	animated_sprite.play("dashing")
	velocity.x = move_speed * last_direction * 3
	velocity.y = 0
	dash_timer.start()
	dash_recover_timer.start()

func calculate_x_displacement() -> void:
	if last_point != position.x:
		var current_point = position.x
		last_direction = current_point - last_point
		last_direction /= abs(last_direction)
	last_point = position.x
	
	
##### SIGNALS #####

func _on_buffer_jump_timer_timeout() -> void:
	jump_buffer = false

func _on_coyote_time_timer_timeout() -> void:
	coyote_time_jump = false
	
func _on_dash_timer_timeout() -> void:
	velocity.x = 0
	move_and_slide()
	is_dashing = false
	print("timeout")
	
func _on_dash_recover_timer_timeout() -> void:
	can_dash = true
	print("Recovered from dash.")


##### IS_STATE #####

func is_idying() -> bool:
	return is_on_floor() and velocity.y >= 0 and is_zero_approx(velocity.x)

func is_running() -> bool:
	return velocity.x != 0.0 and is_on_floor()

func is_jumping() -> bool:
	return velocity.y < 0

func is_falling() -> bool:
	return velocity.y >= 0 and not is_on_floor()
