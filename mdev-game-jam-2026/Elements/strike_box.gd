extends Polygon2D
class_name StrikeBox
var held : bool = true
var draw_target : Vector2
var suspicion : int
var slide : bool = false

@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
@onready var area_2d: Area2D = $Area2D
var caught_ball : bool
var slide_origin : Vector2

@export var sus_gradient : GradientTexture1D

func _ready() -> void:
	Global.CaughtBall.connect(on_caught_ball)
	Global.BallStop.connect(on_stop_ball)
	await get_tree().create_timer(4).timeout
	if caught_ball : return
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1, 0), 1)
	await tween.finished
	queue_free()

func on_stop_ball():
	if held : 
		queue_free()
		return
	area_2d.monitorable = true
	area_2d.monitoring = true

func _input(event: InputEvent) -> void:
	if !held : return
	if event.is_action_released("left_click"):
		Lock_Box()
	if event.is_action_pressed("right_click"):
		slide = true
		slide_origin = get_global_mouse_position()
	if event.is_action_released("right_click"):
		slide = false

func _process(delta: float) -> void:
	if slide: 
		global_position += get_global_mouse_position() - slide_origin
		slide_origin = get_global_mouse_position()
	if !held : return
	draw_target = get_local_mouse_position()
	Redraw_Box()

func Lock_Box():
	held = false 
	slide = false
	modulate = Color(0.0, 0.683, 1.0, 0.75)
	var collision_rect := RectangleShape2D.new()
	collision_rect.size = Vector2i(abs(draw_target.x), abs(draw_target.y))
	collision_shape_2d.shape = collision_rect
	if collision_rect.size.length() < 10 : 
		queue_free()
		return
	area_2d.position = draw_target/2
	var size_sus := 0
	var x_sus := 0
	var y_sus := 0
	var pitch_sus := -1
	if abs(collision_rect.size.x-collision_rect.size.y) > 30 : 
		size_sus = int(abs(collision_rect.size.x-collision_rect.size.y) / 30)
	if collision_rect.size.x > 172 || collision_rect.size.y > 172 : 
		x_sus = int(collision_rect.size.x / 172)
		y_sus = int(collision_rect.size.y / 172)
	
	var pitch_distance = abs(area_2d.global_position.distance_to(Pitch.current_pitch.global_position))
	if pitch_distance > 100 : pitch_sus += 1
	if pitch_distance > 300 : pitch_sus += 1
	if pitch_distance > 500 : pitch_sus += 1
	
	var final_sus = size_sus + x_sus + y_sus + pitch_sus
	final_sus = min(final_sus, 5)
	final_sus = max(final_sus, 0)
	suspicion += final_sus
	
func Redraw_Box():
	var new_poly : PackedVector2Array
	new_poly.append(Vector2(draw_target.x, 0))
	new_poly.append(Vector2.ZERO)
	new_poly.append(Vector2(0, draw_target.y))
	new_poly.append(draw_target)
	set_polygon(new_poly)

func on_caught_ball():
	caught_ball = true
	modulate = sus_gradient.gradient.sample(suspicion / 5.0)
	await get_tree().create_timer(1).timeout
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(0, 1, 0, 0), 1)
	await tween.finished
	queue_free()	
