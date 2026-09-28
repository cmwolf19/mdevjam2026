extends Sprite2D

const PITCHER_ANTICIPATE = preload("uid://dk04q7l1rva0v")
const PITCHER_HOLD = preload("uid://dnyury2bcubw")
const PITCHER_THROW = preload("uid://cqqd7ow4ylwdu")

func _ready() -> void:
	Global.PitchBall.connect(Pitch)

func Pitch():
	texture = PITCHER_ANTICIPATE
	var squash_tween = create_tween()
	squash_tween.tween_property(self, "scale", Vector2(0.15, 0.075), 1)
	await get_tree().create_timer(1).timeout
	var bounce_tween = create_tween()
	bounce_tween.tween_property(self, "scale", Vector2(0.1, 0.1), .2)
	texture = PITCHER_THROW
	await get_tree().create_timer(1).timeout
	texture = PITCHER_HOLD
