extends Node2D
class_name Pitch

static var current_pitch : Pitch

@export var fly_time : float = 2
@export var spin_strength : float = 2
@export var final_position : Vector2 = Vector2(0, 100)
@export var ball_target : Global.eBallTargets

@onready var area_2d: Area2D = $Area2D
@onready var sprite_2d: Sprite2D = $Sprite2D
const GHOST_BALL = preload("uid://m61r28p2jo3h")
var stopped : bool
var hit : bool
func _ready() -> void:
	current_pitch = self
	Spawn_Ghosts()
	Global.current_target = ball_target
	area_2d.area_entered.connect(Catch_Ball)
	
	scale = Vector2.ZERO
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ONE, fly_time)
	
	var spin_tween = create_tween()
	spin_tween.tween_property(sprite_2d, "rotation_degrees", 720*spin_strength, fly_time)
	await get_tree().process_frame
	Throw()
	await spin_tween.finished
	Global.BallStop.emit()
	stopped = true
	await get_tree().create_timer(0.5).timeout
	if hit : return
	var die_tween = create_tween()
	die_tween.tween_property(self, "modulate", Color(1,1,1,0), 0.5)
	await die_tween.finished
	queue_free()

func Spawn_Ghosts():
	while !stopped:
		await get_tree().create_timer(0.1).timeout
		var new_ghost = GHOST_BALL.instantiate()
		add_sibling(new_ghost)
		new_ghost.scale = scale
		new_ghost.rotation = sprite_2d.rotation
		new_ghost.global_position = global_position

func Throw():
	var throw_tween = create_tween()
	throw_tween.set_trans(Tween.TRANS_QUART)
	throw_tween.set_ease(Tween.EASE_IN)
	var target_position = global_position + final_position
	throw_tween.tween_property(self, "global_position", target_position, fly_time)

func Catch_Ball(ball):
	Global.CaughtBall.emit()
	await get_tree().process_frame
	if hit : return
	modulate = Color.GREEN
	await get_tree().create_timer(1).timeout
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(0, 1, 0, 0), 1)
	await tween.finished
	queue_free()
