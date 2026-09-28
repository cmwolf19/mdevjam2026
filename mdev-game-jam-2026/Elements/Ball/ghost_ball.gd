extends Node2D

func _ready() -> void:
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1,1,1,0), 0.5)
	await tween.finished
	queue_free()
