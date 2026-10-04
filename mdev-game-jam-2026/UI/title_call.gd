extends RichTextLabel

@onready var title_call: AudioStreamPlayer = $"../../Title Call"
var hovered : bool = false

func _input(event: InputEvent) -> void:
	if !hovered : return
	if event.is_action_pressed("left_click"):
		title_call.play()

func _on_mouse_entered() -> void:
	hovered = true

func _on_mouse_exited() -> void:
	hovered = false
