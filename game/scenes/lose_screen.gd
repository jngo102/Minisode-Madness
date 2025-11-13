extends Control

var main_menu_scene: PackedScene = preload("uid://vstl3bg568s7")

func _ready() -> void:
	await get_tree().create_timer(4, false).timeout
	SceneManager.change_scene_fade(main_menu_scene, 0.5)
