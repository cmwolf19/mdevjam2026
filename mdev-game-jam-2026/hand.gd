extends Node2D

var mouse_hide := false

func _ready() -> void:
	Toggle_Mouse()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_mouse"): Toggle_Mouse()

	if event.is_action_pressed("left_click"):
		Press_Mouse()
	if event.is_action_released("left_click"):
		Release_Mouse()

func Press_Mouse():
	modulate = Color(.5,.5,.5,1)
	scale = Vector2.ONE
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2(0.8, 0.8), 0.1)

func Release_Mouse():
	modulate = Color.WHITE
	scale = Vector2(0.8, 0.8)
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)	
	tween.tween_property(self, "scale", Vector2.ONE, 0.1)

func Toggle_Mouse():
	mouse_hide = !mouse_hide

	if mouse_hide:
		Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
	else:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _process(delta: float) -> void:
	global_position = lerp(global_position, get_global_mouse_position(), 0.45)
