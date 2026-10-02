extends Label

func _process(delta: float) -> void:
	# Get frames per second
	var fps := Engine.get_frames_per_second()
	
	# Get frame time in seconds, then convert to milliseconds (ms)
	var frame_time := Performance.get_monitor(Performance.TIME_PROCESS) * 1000.0
	
	# Update the label text
	text = "FPS: %d\nFrame Time: %.2f ms" % [fps, frame_time]
