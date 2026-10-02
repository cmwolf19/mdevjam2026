extends Sprite2D
const BATTER = preload("uid://ba8qjmav0073")
const LOOK_BATTER = preload("uid://cwcybjibwmo8l")
const SWING_BATTER = preload("uid://dhqw5mrxuxgam")

var wiggle : bool = false

func _ready() -> void:
	Global.CallBall.connect(Call_Ball)
	Global.CallStrike.connect(Call_Strike)
	Global.WiggleBatter.connect(Wiggle)
	Global.CallHit.connect(SuperSwing)
	Global.CallOut.connect(Call_Out)

func Call_Ball():
	if wiggle:
		Swing()
		return

	texture = BATTER

func Call_Out():
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1,1,1,0), 0.5)
	await tween.finished
	await get_tree().create_timer(1.5).timeout
	if GameManager.outs >= 3 : return
	var in_tween = create_tween()
	in_tween.tween_property(self, "modulate", Color(1,1,1,1), 0.5)

func Swing():
	texture = SWING_BATTER
	await get_tree().create_timer(1).timeout
	texture = BATTER

func SuperSwing():
	texture = SWING_BATTER
	

func Call_Strike():
	if wiggle:
		Swing()
		return

	texture = LOOK_BATTER
	await get_tree().create_timer(2).timeout
	texture = BATTER

func Wiggle(do_wiggle : bool):
	wiggle = do_wiggle
	var wiggle_count := 0
	while wiggle:
		match wiggle_count:
			0: offset += Vector2.UP*8
			1: offset += Vector2.RIGHT*8
			2: offset += Vector2.DOWN*8
			3: offset += Vector2.LEFT*8
		wiggle_count += 1
		await get_tree().create_timer(0.1).timeout
		if wiggle_count >= 4 : wiggle_count = 0
