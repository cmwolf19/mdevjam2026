extends TextureRect

var active_tween : Tween

func _on_mouse_entered() -> void:
	if active_tween != null :
		active_tween.stop()
	
	active_tween = create_tween()
	active_tween.tween_property(self, "position", Vector2(3, 400), 0.5)

func _on_mouse_exited() -> void:
	if active_tween != null :
		active_tween.stop()
	
	active_tween = create_tween()
	active_tween.tween_property(self, "position", Vector2(3, 595), 0.5)
