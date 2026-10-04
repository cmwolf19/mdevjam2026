extends Button
@export var audio : AudioStreamPlayer
@export var scene_id : String
func _ready() -> void:
	pressed.connect(Switch_Scene)

func Switch_Scene():
	if audio: audio.play()
	SceneSwitcher.instance.Load_Scene(scene_id)
