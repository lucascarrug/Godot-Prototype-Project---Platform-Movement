extends StateBase
class_name PlayerStateBase

var player: Player:
	set(value):
		controller_node = value
	get:
		return controller_node

var checkpoint_manager: CheckpointManager:
	get:
		return get_tree().current_scene.get_node("CheckpointManager")

func handle_gravity(delta):
	player.handle_gravity(delta)
