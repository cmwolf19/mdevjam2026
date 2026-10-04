extends TextureRect

var active_tween : Tween

func _on_mouse_entered() -> void:
	Global.CueSFX.emit("Paper")
	if active_tween != null :
		active_tween.stop()
	owner.get_tree().paused = true
	active_tween = create_tween()
	active_tween.tween_property(self, "position", Vector2(-88.0, 244.0), 0.5)

func _on_mouse_exited() -> void:
	if active_tween != null :
		active_tween.stop()
	owner.get_tree().paused = false
	active_tween = create_tween()
	active_tween.tween_property(self, "position", Vector2(-88, 644.0), 0.5)
