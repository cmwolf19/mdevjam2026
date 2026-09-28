extends Polygon2D
class_name StrikeBox
var held : bool = true
var draw_target : Vector2
var suspicion : int

@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
@onready var area_2d: Area2D = $Area2D
var caught_ball : bool

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
	area_2d.monitorable = true
	area_2d.monitoring = true

func _input(event: InputEvent) -> void:
	if !held : return
	if event is InputEventMouseButton:
		if event.is_action_released("left_click"):
			Lock_Box()

func _process(delta: float) -> void:
	if !held : return
	draw_target = get_local_mouse_position()
	Redraw_Box()

func Lock_Box():
	held = false 
	
	var collision_rect := RectangleShape2D.new()
	collision_rect.size = Vector2i(abs(draw_target.x), abs(draw_target.y))
	collision_shape_2d.shape = collision_rect
	
	area_2d.position = draw_target/2
	print(collision_rect.size)
	if abs(collision_rect.size.x-collision_rect.size.y) > 30 : suspicion += 1
	if collision_rect.size.x > 172 || collision_rect.size.y > 172 : suspicion += 1
	

func Redraw_Box():
	var new_poly : PackedVector2Array
	new_poly.append(Vector2(draw_target.x, 0))
	new_poly.append(Vector2.ZERO)
	new_poly.append(Vector2(0, draw_target.y))
	new_poly.append(draw_target)
	set_polygon(new_poly)

func on_caught_ball():
	caught_ball = true
	modulate = Color.GREEN
	await get_tree().create_timer(1).timeout
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(0, 1, 0, 0), 1)
	await tween.finished
	queue_free()	
