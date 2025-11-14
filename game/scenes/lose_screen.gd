extends Control

var main_menu_scene: PackedScene = preload("uid://vstl3bg568s7")
var lose_music: MusicTrack = preload("uid://brl5ymr6jg00w")

func _ready() -> void:
	AudioManager.play_music(lose_music)
	await get_tree().create_timer(4, false).timeout
	SceneManager.change_scene_fade(main_menu_scene, 0.5)
