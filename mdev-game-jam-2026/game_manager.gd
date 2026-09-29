extends Node

@onready var box_drawer: BoxDrawer = $"../Box Drawer"
@onready var ball_thrower: BallThrower = $"../Ball Thrower"
@onready var pitch_callout: RichTextLabel = $"../CanvasLayer/Pitch Callout"
@onready var timer: Timer = $Timer
@onready var ball_count_label: Label = %BallCountLabel
@onready var strike_count_label: Label = %StrikeCountLabel
@onready var out_count_label: Label = %OutCountLabel
@onready var suspicion_meter: ProgressBar = %"Suspicion Meter"
@onready var pitch_call_label: Label = %PitchCallLabel
@onready var result_label: Label = %ResultLabel
@onready var suspicion_display: VBoxContainer = %SuspicionDisplay
@onready var text_display: VBoxContainer = %TextDisplay

var outs := 0
var strikes := 0
var balls := 0

var suspicion : int = 0

var live_boxes : Array[StrikeBox]
var live_ball : bool = false
var caught : bool = false

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
	Global.CaughtBall.connect(Add_Suspicion)
	Global.BallStop.connect(Call_Ball)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug"):
		Throw_Ball()

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
	tween.tween_property(label, "visible_characters", message.length(), 1)

func Cue_Suspicion():
	suspicion_display.show()
	text_display.hide()

func Cue_Text():
	suspicion_display.hide()
	pitch_call_label.text = ""
	result_label.text = ""
	text_display.show()

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
	
	if suspicion >= 5:
		Tween_Line(pitch_call_label, "Wait a minute! That umpire is...")
		await get_tree().create_timer(3)
		Tween_Line(result_label, "CHEATING AT BASEBALL!")
		timer.stop()
		return
	
	if suspicion-old_sus > 1:
		Tween_Line(result_label, Get_Line(sus_strike_lines))
		Global.CueSFX.emit("Sus")
	else:
		Tween_Line(result_label, Get_Line(good_strike_lines))
	strikes += 1
	Global.CueSFX.emit("Strike"+str(strikes))
	Update_Scoreboard()
	await Show_Suspicion()
	timer.start()

func Call_Ball():
	await get_tree().process_frame
	await get_tree().process_frame
	if caught : 
		caught = false
		return
	Tween_Line(result_label, Get_Line(ball_lines))
	balls += 1
	Global.CueSFX.emit("Ball"+str(balls))
	Global.CallBall.emit()
	Update_Scoreboard()
	live_ball = false
	live_boxes.clear()
	suspicion -= balls
	
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

	ball_count_label.text = str(balls)
	strike_count_label.text = str(strikes)
	out_count_label.text = str(outs)
	
	if outs == 3:
		pitch_callout.text = "[wave]That's the ballgame!"
		timer.stop()
		return
	
	if balls == 4:
		pitch_callout.text = "A tragic loss tonight, folks..."
		timer.stop()
		return
	
	await get_tree().create_timer(1).timeout
	pitch_callout.hide()

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
