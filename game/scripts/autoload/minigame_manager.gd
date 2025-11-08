extends Node

@export var levels: Dictionary[String, PackedScene]

@onready var level_timer: Timer = $level_timer

var bg_track: MusicTrack = preload("uid://b5k4swjd25g86")

var current_level: MinigameLevel

var level_duration: float:
	get:
		return level_timer.wait_time

var time_left_in_level: float:
	get:
		return level_timer.time_left

func load_random_level() -> void:
	var level_index: int = randi() % (len(levels) - 1)
	var level_name: String = levels.keys()[level_index]
	var next_level: PackedScene = levels.values()[level_index]
	while is_instance_valid(current_level) and current_level.name == level_name:
		level_index = randi() % (len(levels) - 1)
		level_name = levels.keys()[level_index]
		next_level = levels.values()[level_index]
	current_level = await SceneManager.change_scene(next_level)
	current_level.game_ended.connect(_on_game_end)
	play_game_music()

func play_game_music() -> void:
	var start_time: float = 0
	if AudioManager.current_track != null:
		start_time = fmod(Time.get_ticks_msec() / 1000, bg_track.music_clip.get_length())
	AudioManager.play_music(bg_track, start_time)

func start(time: float = 8) -> void:
	level_timer.start(time)

func _on_game_end() -> void:
	await get_tree().create_timer(2, false).timeout
	current_level.game_ended.disconnect(_on_game_end)
	load_random_level()

func _on_level_timer_timeout() -> void:
	current_level.end_game()
