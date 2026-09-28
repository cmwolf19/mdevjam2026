extends AudioStreamPlayer

@export var key : String

func _ready() -> void:
	Global.CueSFX.connect(Listen)

func Listen(effect_key : String):
	if key == effect_key:
		play()
