extends Node2D
class_name BoxDrawer
const STRIKE_BOX = preload("uid://c0x8fn028ngl6")

signal spawn_box(box : StrikeBox)

@export var require_pitch : bool

#Click and Drag
func _input(event: InputEvent) -> void:
	if "live_ball" in owner && owner.live_ball == false : return
	if event is not InputEventMouseButton : return
	
	if require_pitch && Pitch.current_pitch == null : return
	if event.is_action_pressed("left_click"):
		spawn_strike_box()

func spawn_strike_box():
	var new_box = STRIKE_BOX.instantiate()
	add_child(new_box)
	new_box.global_position = get_global_mouse_position()
	spawn_box.emit(new_box)
