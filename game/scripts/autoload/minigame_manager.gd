extends Node

@export var speed_up_num_rounds: int = 2

@export var levels: Dictionary[String, PackedScene]

@export var tracks: Dictionary[String, MusicTrack]

@onready var level_timer: Timer = $level_timer

signal level_changed(new_level: int)

var lives_left: int

var level: int = 1:
	set(value):
		level = value
		if value > 1:
			level_changed.emit(value)

var current_level: MinigameLevel
var last_game_won: bool
var games_won: int

var previous_levels: Array[String]

var level_duration: float:
	get:
		return level_timer.wait_time

var time_left_in_level: float:
	get:
		return level_timer.time_left

func reset() -> void:
	games_won = 0
	level = 1
	last_game_won = false
	lives_left = 4

func load_random_level() -> void:
	var level_index: int = randi() % len(levels)
	var level_name: String = levels.keys()[level_index]
	var next_level: PackedScene = levels.values()[level_index]
	while previous_levels.has(level_name):
		level_index = randi() % len(levels)
		level_name = levels.keys()[level_index]
		next_level = levels.values()[level_index]
	current_level = await SceneManager.change_scene(next_level)
	current_level.game_ended.connect(_on_game_end)
	previous_levels.append(level_name)
	if len(previous_levels) >= len(levels) / 2:
		previous_levels.remove_at(0)

func start(time: float = 15) -> void:
	level_timer.start(time)

func _on_game_end() -> void:
	await get_tree().create_timer(4, false).timeout
	if is_instance_valid(current_level):
		current_level.game_ended.disconnect(_on_game_end)
	if games_won > 0 and games_won % speed_up_num_rounds == 0:
		speed_up()
	if level > 3:
		game_win()
		return
	if lives_left > 0:
		load_random_level()
	else:
		game_over()

func speed_up() -> void:
	if level <= 3:
		level += 1

func end_game() -> void:
	level_timer.stop()
	if is_instance_valid(current_level) and not current_level.won_game:
		current_level.lose()
	last_game_won = current_level.won_game
	if last_game_won:
		games_won += 1
	current_level.end_game()

func game_over() -> void:
	print("GAME WIN")
	current_level = null
	SceneManager.change_scene(load("uid://vstl3bg568s7"))

func game_win() -> void:
	print("VICTORY")
	SceneManager.change_scene(load("uid://vstl3bg568s7"))

func _on_level_timer_timeout() -> void:
	end_game()
