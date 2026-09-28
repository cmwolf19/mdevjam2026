extends Node2D
class_name BoxDrawer
const STRIKE_BOX = preload("uid://c0x8fn028ngl6")

signal spawn_box(box : StrikeBox)
@onready var game_manager: Node = $"../Game Manager"

#Click and Drag
func _input(event: InputEvent) -> void:
	if game_manager.live_ball == false : return
	if event is not InputEventMouseButton : return
	
	if event.is_action_pressed("left_click"):
		spawn_strike_box()

func spawn_strike_box():
	var new_box = STRIKE_BOX.instantiate()
	add_child(new_box)
	new_box.global_position = get_global_mouse_position()
	spawn_box.emit(new_box)
