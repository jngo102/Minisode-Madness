## Manages loading and unloading of scenes
extends Node

## The screen that levels are rendered to
@onready var screen: SubViewport = get_node("/root/main/screen_container/screen")

## Emitted whenever a scene changes
signal scene_changed(new_scene_name: String)

## The currently-loaded level
var current_level: Node:
	get:
		return screen.get_child(0);

## Generic scene change function
func change_scene(scene: PackedScene) -> MinigameLevel:
	var transition_screen: TransitionScreen = UIManager.open_ui(TransitionScreen)
	await transition_screen.transitioned
	current_level.queue_free()
	var level = scene.instantiate()
	screen.add_child(level)
	scene_changed.emit(scene.resource_name)
	transition_screen.close()
	return level
