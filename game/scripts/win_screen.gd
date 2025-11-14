extends Control

var credits_scene: PackedScene = preload("uid://bfeqdnb6xaqbb")
var win_music: MusicTrack = preload("uid://b1skua23ru2nt")

func _ready() -> void:
	AudioManager.play_music(win_music)
	await get_tree().create_timer(4, false).timeout
	SceneManager.change_scene_fade(credits_scene, 0.5)
