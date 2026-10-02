extends Button

@export var scene_id : String
func _ready() -> void:
	pressed.connect(Switch_Scene)

func Switch_Scene():
	SceneSwitcher.instance.Load_Scene(scene_id)
