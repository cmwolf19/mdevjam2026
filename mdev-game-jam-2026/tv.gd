extends ColorRect
var shader_mat : ShaderMaterial
func _ready() -> void:
	show()
	shader_mat = material as ShaderMaterial
	Global.CallHit.connect(Fizz_Out)
	Global.CallCaught.connect(Fizz_Out)
	Global.CallWin.connect(Fizz_Out)
	Global.CallWalk.connect(Fizz_Out)

func Fizz_Out():
	await get_tree().create_timer(2)
	var tween = create_tween()
	tween.tween_method(Set_Fizz, 0.65, 8, 4)

func Set_Fizz(fizz : float):
	shader_mat.set_shader_parameter("jitter_px", fizz)
