extends Control

var credits_scene: PackedScene = preload("uid://bfeqdnb6xaqbb")

func _ready() -> void:
	await get_tree().create_timer(4, false).timeout
	SceneManager.change_scene_fade(credits_scene, 0.5)
