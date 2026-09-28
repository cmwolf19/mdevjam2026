@tool
extends Node2D
class_name BallThrower

@export var throw_range : Vector2i:
	set(value):
		throw_range = value
		queue_redraw()

@export var balls : Array[PackedScene]

func Pick_Ball():
	var new_ball = balls[randi_range(0, balls.size()-1)].instantiate()
	return new_ball

func Throw_Ball():
	Global.PitchBall.emit()
	await get_tree().create_timer(1).timeout
	var new_ball = Pick_Ball()
	add_child(new_ball)
	var offset := Vector2(randi_range(-throw_range.x, throw_range.x), randi_range(-throw_range.y, throw_range.y))
	new_ball.position = offset/2
	print(offset)

func _draw() -> void:
	if Engine.is_editor_hint() == false : return
	draw_rect(Rect2i(-throw_range/2, throw_range), Color.BLUE, false)
	
	
	
	
