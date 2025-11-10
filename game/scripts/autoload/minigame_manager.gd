extends Node

@export var levels: Dictionary[String, PackedScene]

@onready var level_timer: Timer = $level_timer

var bg_track: MusicTrack = preload("uid://b5k4swjd25g86")

signal level_changed(new_level: int)

var level: int = 1:
	set(value):
		level = value
		level_changed.emit(value)

var current_level: MinigameLevel

var level_duration: float:
	get:
		return level_timer.wait_time

var time_left_in_level: float:
	get:
		return level_timer.time_left

func load_random_level() -> void:
	var level_index: int = randi() % len(levels)
	var level_name: String = levels.keys()[level_index]
	var next_level: PackedScene = levels.values()[level_index]
	while is_instance_valid(current_level) and current_level.name == level_name:
		level_index = randi() % len(levels)
		level_name = levels.keys()[level_index]
		next_level = levels.values()[level_index]
	current_level = await SceneManager.change_scene(next_level)
	current_level.game_ended.connect(_on_game_end)
	play_game_music()
	if level < 3:
		level += 1

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

func end_game() -> void:
	level_timer.stop()
	if not current_level.won_game:
		current_level.lose()
	current_level.end_game()

func _on_level_timer_timeout() -> void:
	end_game()
