extends AudioStreamPlayer

@onready var game_manager: GameManager = $"../Game Manager"

func _ready() -> void:
	Global.CallWin.connect(Fade_Out)
	Global.CallCaught.connect(Fade_Out)
	Global.CallNoBox.connect(Fade_Out)
	Global.CallWalk.connect(Fade_Out)

func Fade_Out():
	var tween = create_tween()
	tween.tween_property(self, "volume_linear", 0, 1)

func _on_finished() -> void:
	if game_manager.game_over : return
	play()
