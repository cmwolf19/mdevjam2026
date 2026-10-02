extends PanelContainer
@onready var title_label: Label = $MarginContainer/VBoxContainer/TitleLabel
@onready var description_label: Label = $MarginContainer/VBoxContainer/DescriptionLabel
@onready var menu_button: Button = $"../MenuButton"

func _ready() -> void:
	menu_button.hide()
	hide()
	Global.CallWin.connect(Win)
	Global.CallHit.connect(Hit_Loss)
	Global.CallWalk.connect(Walk_Loss)
	Global.CallCaught.connect(Sus_Loss)

func _process(delta: float) -> void:
	global_position += Vector2.UP * sin(Time.get_ticks_msec()/1000.0)/4

func Win():
	title_label.text = "you win!"
	description_label.text = "Cheaters always win!"
	Show_Panel()

func Hit_Loss():
	title_label.text = "you lose!"
	description_label.text = "Batter hit a homer."
	Show_Panel()

func Walk_Loss():
	title_label.text = "you lose!"
	description_label.text = "Batter walked in."
	Show_Panel()

func Sus_Loss():
	title_label.text = "you lose!"
	description_label.text = "You got caught!"
	Show_Panel()

func Show_Panel():
	Global.CueSFX.emit("Lose")
	await get_tree().create_timer(4).timeout
	modulate = Color(1,1,1,0)
	show()
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, 2)
	await get_tree().create_timer(4).timeout
	menu_button.show()
	
