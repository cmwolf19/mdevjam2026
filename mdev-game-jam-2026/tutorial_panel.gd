extends Panel

func _ready() -> void:
	Global.BallStop.connect(fade)

func fade():
	modulate.a -= 0.2
