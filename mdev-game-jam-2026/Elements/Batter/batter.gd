extends Sprite2D
const BATTER = preload("uid://ba8qjmav0073")
const LOOK_BATTER = preload("uid://cwcybjibwmo8l")

func _ready() -> void:
	Global.CallBall.connect(Call_Ball)
	Global.CallStrike.connect(Call_Strike)

func Call_Ball():
	texture = BATTER

func Call_Strike():
	texture = LOOK_BATTER
	await get_tree().create_timer(2).timeout
	texture = BATTER
