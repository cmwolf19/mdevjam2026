@icon("res://Modules/Scene Switcher/camera_move.png")
class_name SceneSwitcher extends Node

#region Script Description
## A node to handle switching between "main" scenes.
## 
## This script tweens the progress value of the transition_shader and
## then loads a scene from a scene_path using Load_Scene(path).
##
## ATTENTION: Set the scene_holder and configure the transition_shader before use.
## INFO: Uses the Universal Transition Shader by Cashew Old Dew
#endregion

#region Variable Declaration
static var instance : SceneSwitcher ## Singleton.
@export var scene_holder : Node ## Node that holds the active scene.

@export var transition_duration : float ## How long should each step of the fade take?
@export var progress_end : float = 4.0 ## Final progress value the shader should reach.
@onready var transition_target = $"Transition Layer/Transition Target"
var transition_shader : ShaderMaterial ## Reference to the [ShaderMaterial] to animate.

static var loading : bool ## Is the [SceneSwitcher] actively loading a new scene?
#endregion

#region Signal Declaration
signal OnSwitchStarted() ## We have just called LoadScene and are about to start loading.
signal OnScreenCovered() ## The fade in has completed, and we are about to instantiate/queue free.
signal OnSceneLoaded() ## The new scene has been instantiated.
signal OnSwitchEnded() ## The fade out has completed, and we are done loading.
#endregion

## Sets the singleton "instance" for outside use.
func _init() -> void:
	instance = self

## Gets a reference to the transition shader.
func _ready() -> void:
	if scene_holder == null:
		push_error("SceneSwitcher does not have a Scene Holder set. It will not function.")
		return

	transition_shader = get_node("Transition Layer/Transition Target").material
	transition_target.hide()

## Switches the active scene out with the scene at [param scene_path].
func Load_Scene(scene_path : String):
	if scene_holder == null:
		push_error("SceneSwitcher does not have a Scene Holder set. It will not function.")
		return

	if loading :
		push_error("Attempted to load scene \"%s\" but SceneSwitcher was busy:" % scene_path)
		return
	loading = true
	OnSwitchStarted.emit()

	var packed_scene : PackedScene = load(scene_path)

	# Transition in.
	var in_tween : Tween = create_tween()
	in_tween.tween_method(
		func (value): transition_shader.set_shader_parameter("progress", value),
		0.0, progress_end, transition_duration
	)
	transition_target.show()
	await in_tween.finished

	# Transition out.
	OnScreenCovered.emit()
	if scene_holder.get_child_count() > 0 : scene_holder.get_child(0).queue_free()
	var new_scene = packed_scene.instantiate()
	scene_holder.add_child(new_scene)
	OnSceneLoaded.emit()

	var out_tween : Tween = create_tween()
	out_tween.tween_method(
		func (value): transition_shader.set_shader_parameter("progress", value),
		progress_end, 0.0, transition_duration
	)
	await out_tween.finished
	transition_target.hide()

	loading = false
	OnSwitchEnded.emit()
