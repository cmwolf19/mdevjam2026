extends Area2D
class_name ToggleArea

var covered : bool

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)

func _on_area_entered(area: Area2D) -> void:
	covered = true


func _on_area_exited(area: Area2D) -> void:
	covered = false
