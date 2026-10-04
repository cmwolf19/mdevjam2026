extends PanelContainer
@onready var title_label: Label = $MarginContainer/VBoxContainer/TitleLabel
@onready var description_label: Label = $MarginContainer/VBoxContainer/DescriptionLabel
@onready var menu_button: Button = $"../Lose Options/MenuButton"
@onready var play_again: Button = $"../Lose Options/Play Again"
@onready var hint_label: RichTextLabel = %"Hint Label"
@onready var hint_panel: PanelContainer = %HintPanel
@onready var lose_options: Control = $"../Lose Options"
@onready var money: GPUParticles2D = $"../Money"


func _ready() -> void:
	play_again.hide()
	menu_button.hide()
	hint_label.hide()
	hint_panel.hide()
	hide()
	Global.CallWin.connect(Win)
	Global.CallHit.connect(Hit_Loss)
	Global.CallWalk.connect(Walk_Loss)
	Global.CallCaught.connect(Sus_Loss)
	Global.CallNoBox.connect(No_Box_Loss)

func _process(delta: float) -> void:
	global_position += Vector2.UP * sin(Time.get_ticks_msec()/1000.0)/4

func Win():
	Global.CueSFX.emit("Win")

	title_label.text = "you win!"
	description_label.text = "Cheaters always win!"
	hint_label.text = "The umpire became a rich guy\n and married into the mafia."
	Show_Panel()
	
	money.emitting = true
	
func Hit_Loss():
	Global.CueSFX.emit("Lose")

	title_label.text = "you lose!"
	description_label.text = "Batter hit a homer."
	hint_label.text = "When the batter is [shake]READY[/shake],\n draw a strike box AWAY FROM THE BALL."
	Show_Panel()

func No_Box_Loss():
	Global.CueSFX.emit("Lose")

	title_label.text = "you lose!"
	description_label.text = "Batter hit a homer."
	hint_label.text = "You have to draw a box for each pitch!"
	Show_Panel()

func Walk_Loss():
	Global.CueSFX.emit("Lose")

	title_label.text = "you lose!"
	description_label.text = "Batter walked in."
	hint_label.text = "Getting four balls lets the batter walk to base." 
	Show_Panel()

func Sus_Loss():
	Global.CueSFX.emit("Lose")
	
	title_label.text = "you lose!"
	description_label.text = "You got caught!"
	hint_label.text = "Keep [b]SUSPICION[/b] low by throwing balls\n and drawing good strike boxes." 
	Show_Panel()

func Show_Panel():
	await get_tree().create_timer(4).timeout
	modulate = Color(1,1,1,0)
	show()
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, 2)
	await get_tree().create_timer(4).timeout
	lose_options.modulate = Color(1,1,1,0)
	hint_label.show()
	menu_button.show()
	play_again.show()
	hint_panel.show()
	var fade_tween = create_tween()
	fade_tween.tween_property(lose_options, "modulate", Color.WHITE, 1)
	
