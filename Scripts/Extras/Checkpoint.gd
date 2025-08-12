class_name Checkpoint extends Area2D

var checkpoint_manager: CheckpointManager

func _ready() -> void:
	checkpoint_manager = get_parent().get_parent().get_node("CheckpointManager")

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		print("New checkpoint reached.")
		checkpoint_manager.last_location = $RespawnPoint.global_position
