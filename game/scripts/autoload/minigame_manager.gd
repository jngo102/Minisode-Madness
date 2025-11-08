extends Node

@export var levels: Dictionary[String, PackedScene]

@onready var level_timer: Timer = $level_timer

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

func start(time: float = 8) -> void:
	level_timer.start(time)

func _on_game_end() -> void:
	await get_tree().create_timer(2, false).timeout
	current_level.game_ended.disconnect(_on_game_end)
	load_random_level()

func _on_level_timer_timeout() -> void:
	current_level.end_game()
