extends Sprite2D

func _ready() -> void:
	while true:
		await get_tree().create_timer(0.1).timeout
		offset = Vector2(randi_range(-4, 4), randi_range(-4, 4))
