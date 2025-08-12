class_name TriggerArea2D extends Node2D

@onready var player = $"../Player"
@onready var slider = $"Slider"
@onready var slider_label = $"Slider/Label"
@onready var area = $"Area2D/CollisionShape2D"

func _ready() -> void:
	visible = false
	var stat := name
	for i in range(0,10):
		stat = stat.replace(str(i), "")
	if slider_label: slider_label.text = stat

func _on_area_2d_body_entered(body: Node2D) -> void:
	if name != "Secret" and name != "Results":
		visible = true
	elif name == "Secret":
		slider.visible = false
		var new_label = Label.new()
		new_label.global_position = area.global_position
		new_label.text = "Hi there! :)"
		new_label.visible = true
		print(new_label.global_position)
		get_tree().current_scene.get_node("NumberLabels").add_child(new_label)
	elif name == "Results":
		slider.visible = false
		var new_label = Label.new()
		new_label.global_position = area.global_position + Vector2(100, -100)
		new_label.text = string_results()
		new_label.visible = true
		print(new_label.global_position)
		get_tree().current_scene.get_node("NumberLabels").add_child(new_label)

func _on_slider_value_changed(value: float) -> void:
	var stat := name
	for i in range(0,10):
		stat = stat.replace(str(i), "")
	
	match stat:
		"JumpHeight":
			player.jump_height = value
			player.reset_physics()
		"MaxJumpDistance":
			player.max_jump_distance = value
			player.reset_physics()
		"JumpPeakTime":
			player.jump_peak_time = value
			player.reset_physics()
		"Dash":
			if value == 1.0:
				player.available_dash = true
			else:
				player.available_dash = false
		"WalljumpPushback":
			player.walljump_pushback_force = value
		"AirJump":
			player.max_air_jumps = value
		
	slider_label.text = stat + ": " + str(value)
	print(value)

func _on_slider_drag_ended(value_changed: bool) -> void:
	$Slider.release_focus()

func string_results() -> String:
	var jump_height = " JumpHeight: " + str(player.jump_height)
	var max_jump_distance = "\n MaxJumpDistance: " + str(player.max_jump_distance)
	var jump_peak_time = "\n JumpPeakTime: " + str(player.jump_peak_time)
	var dash = "\n Dash: " + str(player.available_dash)
	var walljump_pushback = "\n WalljumpPushback: " + str(player.walljump_pushback_force)
	var air_jump = "\n AirJump: " + str(player.max_air_jumps)

	return "Your player final states:\n" + jump_height + max_jump_distance + jump_peak_time + dash + walljump_pushback + air_jump
