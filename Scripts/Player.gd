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
@onready var debug_label := $DebugLabel
@onready var debug_label2 := $DebugLabel2

# Basic physics variables.
var gravity: float
var jump_speed: float
var move_speed: float

# Fancy physics variables. 
var jump_buffer := false
var coyote_time_jump := true
var was_on_floor := true

# Animation variables.
var _is_facing_right := true

##### METHODS #####

func _ready() -> void:
	gravity = (2 * jump_height) / (jump_peak_time * jump_peak_time)
	jump_speed = gravity * jump_peak_time
	move_speed = jump_distance / (2 * jump_peak_time)
	
func _physics_process(delta: float) -> void:
	if was_on_floor and not is_on_floor():
		coyote_time_start()
	was_on_floor = is_on_floor()


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
		debug_label.text = "FALSE"

func handle_gravity(delta) -> void:
	if not is_on_floor():
		velocity.y = min(velocity.y + gravity * delta, velocity.y + stats.MAX_FALL_SPEED)

##### FANCY PHYSICS #####

func jump_buffer_start() -> void:
	buffer_jump_timer.start()
	jump_buffer = true
	debug_label.text = "TRUE"
	
func coyote_time_start() -> void:
	coyote_time_timer.start()
	coyote_time_jump = true
	debug_label2.text = "YES"
	
func on_jump_released() -> void:
	velocity.y /= jump_height_decrease

##### SIGNALS #####

func _on_buffer_jump_timer_timeout() -> void:
	jump_buffer = false
	debug_label.text = "FALSE"

func _on_coyote_time_timer_timeout() -> void:
	debug_label2.text = "NO"
	coyote_time_jump = false

##### IS_STATE #####

func is_idying() -> bool:
	return is_on_floor() and velocity.y >= 0 and is_zero_approx(velocity.x)

func is_running() -> bool:
	return velocity.x != 0.0 and is_on_floor()

func is_jumping() -> bool:
	return velocity.y < 0

func is_falling() -> bool:
	return velocity.y > 0
