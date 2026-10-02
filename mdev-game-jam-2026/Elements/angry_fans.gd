extends Node2D

func _ready() -> void:
	Global.CueSFX.connect(Check)

func Check(key):
	if key != "Sus": return
	
	var show_tween = create_tween()
	show_tween.tween_property(self, "position", Vector2(1232.0, 289), 0.25)
	await show_tween.finished
	await get_tree().create_timer(2).timeout
	var hide_tween = create_tween()
	hide_tween.tween_property(self, "position", Vector2(1400.0, 289), 1)
