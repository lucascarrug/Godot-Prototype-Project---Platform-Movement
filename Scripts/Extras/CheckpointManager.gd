class_name CheckpointManager extends Node

var last_location := Vector2(0,0)
@onready var player := $"../Player"

func _ready() -> void:
	last_location = player.position

func return_player_to_last_checkpoint() -> void:
	player.position = last_location
