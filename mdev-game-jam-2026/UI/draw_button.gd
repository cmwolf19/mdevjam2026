extends Node2D

@export var scene_id : String
var areas_covered : Array[Area2D]
var triggered : bool
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

func _ready() -> void:
	for child in get_children():
		if child is Area2D:
			areas_covered.append(child)
			child.area_entered.connect(Check_Covered)
	
func Check_Covered(_strikearea : Area2D):
	await get_tree().process_frame
	for child in areas_covered:
		if child.covered == false:
			print(child.name + " not covered.")
			return
	Switch_Scene()

func Switch_Scene():
	if audio_stream_player.playing == false:
		audio_stream_player.play()
	SceneSwitcher.instance.Load_Scene(scene_id)
