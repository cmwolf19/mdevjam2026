extends TextureRect

var active_tween : Tween

func _on_mouse_entered() -> void:
	if active_tween != null :
		active_tween.stop()
	
	active_tween = create_tween()
	active_tween.tween_property(self, "position", Vector2(-88.0, 247.0), 0.5)

func _on_mouse_exited() -> void:
	if active_tween != null :
		active_tween.stop()
	
	active_tween = create_tween()
	active_tween.tween_property(self, "position", Vector2(-88, 623), 0.5)
