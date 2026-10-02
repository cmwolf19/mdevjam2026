extends Node
class_name GameManager
@onready var box_drawer: BoxDrawer = $"../Box Drawer"
@onready var ball_thrower: BallThrower = $"../Ball Thrower"
@onready var timer: Timer = $Timer
@onready var ball_count_label: Label = %BallCountLabel
@onready var strike_count_label: Label = %StrikeCountLabel
@onready var out_count_label: Label = %OutCountLabel
@onready var suspicion_meter: ProgressBar = %"Suspicion Meter"
@onready var pitch_call_label: Label = %PitchCallLabel
@onready var result_label: Label = %ResultLabel
@onready var suspicion_display: VBoxContainer = %SuspicionDisplay
@onready var text_display: VBoxContainer = %TextDisplay
@onready var flash: ColorRect = $"../CanvasLayer/Flash"

static var outs := 0
var strikes := 0
var balls := 0

var suspicion : int = 0

var live_boxes : Array[StrikeBox]
var live_ball : bool = false
var caught : bool = false

var batter_ready : bool = false

var pitch_lines = [
	"And here's the pitch...",
	"Here it comes!",
	"Pitcher is ready...",
	"Coming in hot!"
]

var good_strike_lines = [
	"Zinger!",
	"What an arm!",
	"It's a strike!",
	"STRRRRIKE!",
]

var sus_strike_lines = [
	"Ball. No? A strike!",
	"A strike?! Unbelievable!",
	"It's... a strike?",
	"Strike? Sure, ump..."
]

var ball_lines = [
	"It's a ball...",
	"Just a ball...",
	"There's a ball...",
	"And a ball..."
]

func _ready() -> void:
	Cue_Text()
	box_drawer.spawn_box.connect(Add_Box)
	Global.CaughtBall.connect(Caught_Ball)
	Global.BallStop.connect(Missed_Ball)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug"):
		Global.CallOut.emit()

func Add_Box(new_box : StrikeBox):
	live_boxes.append(new_box)

func Get_Line(array : Array) -> String:
	return array[randi_range(0, array.size()-1)]

func Tween_Line(label : Label, message : String):
	label.text = ""
	await get_tree().process_frame
	label.visible_characters = 0
	label.text = message
	var tween = create_tween()
	var callable = Update_Visible.bind(label)
	tween.tween_method(callable, 0, label.text.length(), 1)
#	tween.tween_property(label, "visible_characters", message.length(), 1)

func Update_Visible(characters : int, label : Label):
	if characters >= label.text.length()+1 : return
	if label.text[characters-1] != ' ':
		Global.CueSFX.emit("Chirp")
	label.visible_characters = characters

func Cue_Suspicion():
	suspicion_display.show()
	text_display.hide()

func Cue_Text():
	suspicion_display.hide()
	pitch_call_label.text = ""
	result_label.text = ""
	text_display.show()

func Caught_Ball():
	Global.CueSFX.emit("Catch")
	
	if !batter_ready : Add_Suspicion()
	else: Batter_Hit()

func Missed_Ball():
	await get_tree().process_frame
	await get_tree().process_frame
	if caught : 
		caught = false
		return
	Global.CueSFX.emit("Catch")
	if batter_ready && live_boxes.size() > 0: 
		Add_Suspicion()
	elif live_boxes.size() == 0: Batter_Hit()
	else : Call_Ball()

func Add_Suspicion():
	Global.CallStrike.emit()
	live_ball = false
	caught = true
	var old_sus : int = suspicion
	for box in live_boxes:
		if box == null : 
			live_boxes.erase(box)
			continue
		suspicion += box.suspicion
		live_boxes.erase(box)
	suspicion = max(suspicion, 0)
	if suspicion >= 10:
		Tween_Line(pitch_call_label, "Wait a minute! That umpire is...")
		await get_tree().create_timer(2).timeout
		Tween_Line(result_label, "CHEATING AT BASEBALL!")
		Global.CueSFX.emit("Cheating")
		timer.stop()
		Global.CallCaught.emit()
		return
	
	if suspicion-old_sus > 2:
		Tween_Line(result_label, Get_Line(sus_strike_lines))
		Global.CueSFX.emit("Sus")
	else:
		Tween_Line(result_label, Get_Line(good_strike_lines))
	
	strikes += 1
	Global.CueSFX.emit("Strike"+str(strikes))
	
	Update_Scoreboard()
	await get_tree().create_timer(2).timeout
	await Show_Suspicion()
	timer.start()
	live_boxes.clear()

func Call_Ball():
	Tween_Line(result_label, Get_Line(ball_lines))
	balls += 1
	Global.CueSFX.emit("Ball"+str(balls))
	Global.CallBall.emit()
	Update_Scoreboard()
	live_ball = false
	live_boxes.clear()
	suspicion -= balls
	await get_tree().create_timer(2).timeout
	await Show_Suspicion()
	timer.start()
	
func Throw_Ball():
	live_ball = true
	caught = false
	ball_thrower.Throw_Ball()

func Update_Scoreboard():
	if strikes == 3:
		outs += 1
		strikes = 0
		balls = 0
		Global.CallOut.emit()

	ball_count_label.text = "0"+str(balls)
	strike_count_label.text = "0"+str(strikes)
	out_count_label.text = "0"+str(outs)
	
	if outs == 3:
		Tween_Line(pitch_call_label, "That's the ballgame!")
		timer.start(99)
		timer.stop()
		Global.CallWin.emit()
		return
	
	if balls == 4:
		Tween_Line(pitch_call_label, "A tragic walk, folks...")
		timer.stop()
		Global.CallWalk.emit()
		return
	
	await get_tree().create_timer(1).timeout
	
	if batter_ready == false : 
		batter_ready = (randi_range(0,3) >= 1)
	else:
		batter_ready = false
	Global.WiggleBatter.emit(batter_ready)

func Batter_Hit():
	flash.show()
	Global.CueSFX.emit("Hit")
	Global.CallHit.emit()
	caught = true
	timer.stop()
	Pitch.current_pitch.hit = true
	await get_tree().create_timer(0.1).timeout
	flash.hide()
	Tween_Line(pitch_call_label, "Oh! It's outta here!")
	var pos_tween = create_tween()
	pos_tween.set_ease(Tween.EASE_OUT)
	pos_tween.tween_property(Pitch.current_pitch, "global_position", Pitch.current_pitch.global_position+Vector2.UP*400, 1)
	var scale_tween = create_tween()
	scale_tween.set_ease(Tween.EASE_OUT)
	scale_tween.tween_property(Pitch.current_pitch, "scale", Vector2.ZERO, 2)

	await get_tree().create_timer(1).timeout
	Tween_Line(result_label, "A tragic loss, folks...")

func Show_Suspicion():
	Cue_Suspicion()
	await get_tree().create_timer(1).timeout
	var tween = create_tween()
	tween.tween_property(suspicion_meter, "value", suspicion, 1)
	await get_tree().create_timer(2).timeout

func _on_timer_timeout() -> void:
	Cue_Text()
	Tween_Line(pitch_call_label, Get_Line(pitch_lines)) 
	await get_tree().create_timer(2).timeout
	Throw_Ball()
