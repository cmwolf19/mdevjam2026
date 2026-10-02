extends PanelContainer
@onready var suspicion_meter: ProgressBar = %"Suspicion Meter"

func _process(delta: float) -> void:
	var fill_percent := suspicion_meter.value / suspicion_meter.max_value
	offset_transform_position = Vector2(randi_range(-5, 5), randi_range(-5, 5)) * fill_percent
