class_name StateMachine 
extends Node

# Reference to node which is going to be controlled.
@onready var controller_node : Node = self.owner
# Default state.
@export var default_state : StateBase
# Current state.
var current_state : StateBase = null


func _ready() -> void:
	call_deferred("_state_default_start")

# Safe way to call the method.
func _state_default_start() -> void:
	current_state = default_state
	_state_start()

# Prepare variables to the new state and launch start() function.
func _state_start() -> void:
	print("StateMachine: ", controller_node.name, " start state ", current_state.name)
	current_state.controller_node = controller_node
	current_state.state_machine = self
	current_state.start()

# Allows to change the state to another.
func change_to(new_state: String) -> void:
	# If has method "end()", call it.
	if current_state and current_state.has_method("end"): current_state.end()
	# Set new state.
	current_state = get_node(new_state)
	# Update the state.
	_state_start()

func _process(delta: float) -> void:
	if current_state and current_state.has_method("on_process"):
		current_state.on_process(delta)

func _physics_process(delta: float) -> void:
	if current_state and current_state.has_method("on_physics_process"):
		current_state.on_physics_process(delta)

func _input(event: InputEvent) -> void:
	if current_state and current_state.has_method("on_input"):
		current_state.on_input(event)

func _unhandled_input(event: InputEvent) -> void:
	if current_state and current_state.has_method("on_unhandled_input"):
		current_state.on_unhandled_input(event)
	
func _unhandled_key_input(event: InputEvent) -> void:
	if current_state and current_state.has_method("on_unhandled_key_input"):
		current_state.on_unhandled_key_input(event)
