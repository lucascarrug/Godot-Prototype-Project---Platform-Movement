extends StateBase
class_name PlayerStateBase

var player: Player:
	set(value):
		controller_node = value
	get:
		return controller_node

func handle_gravity(delta):
	player.handle_gravity(delta)
