## Manages loading and unloading of scenes
extends Node

## The screen that levels are rendered to
@onready var screen: SubViewport = get_node("/root/main/screen_container/screen")

## Emitted whenever a scene changes
signal scene_changed(new_scene_name: String)

## The currently-loaded level
var current_level: Node:
	get:
		return screen.get_child(0)
	set(value):
		current_level = value
		screen.add_child(value)

## Generic scene change function
func change_scene(scene: PackedScene, no_transition: bool = false) -> Node:
	var transition_screen: TransitionScreen = UIManager.get_ui(TransitionScreen)
	if not no_transition:
		transition_screen.open()
	current_level.queue_free()
	if not no_transition:
		await transition_screen.transitioned
	current_level = scene.instantiate()
	scene_changed.emit(scene.resource_name)
	if not no_transition:
		transition_screen.close()
	return current_level
	
func change_scene_fade(scene: PackedScene, fade_in_speed: float = 1, fade_out_speed: float = 1) -> void:
	var fader: Fader = UIManager.get_ui(Fader)
	fader.speed = fade_in_speed
	fader.open()
	await fader.faded_in
	current_level.queue_free()
	current_level = scene.instantiate()
	scene_changed.emit(scene.resource_name)
	fader.speed = fade_out_speed
	fader.close()
	await fader.faded_out
	
