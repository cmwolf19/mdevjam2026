extends PanelContainer

@onready var tutorial: CanvasLayer = $"../../Tutorial"
var hovered : bool


func _process(delta: float) -> void:
	if !hovered:
		offset_transform_scale = Vector2.ONE + (Vector2.ONE * sin(Time.get_ticks_msec()/100.0)/16.0)
	else:
		offset_transform_scale = Vector2.ONE

func _on_mouse_entered() -> void:
	Global.CueSFX.emit("Paper")
	owner.get_tree().paused = true
	tutorial.show()
	hovered = true

func _on_mouse_exited() -> void:
	owner.get_tree().paused = false
	tutorial.hide()
