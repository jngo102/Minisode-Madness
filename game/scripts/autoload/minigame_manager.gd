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
		if value > 1 and value <= 3:
			level_changed.emit(value)

var current_level: Node
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
	if current_level is MinigameLevel:
		current_level.game_ended.connect(_on_game_end)
	previous_levels.append(level_name)
	if len(previous_levels) >= len(levels) - 1:
		previous_levels.remove_at(0)

func start(time: float = 15) -> void:
	level_timer.start(time)

func _on_game_end() -> void:
	await get_tree().create_timer(4, false).timeout
	last_game_won = current_level.won_game
	if last_game_won:
		games_won += 1
	else:
		lives_left -= 1
	if lives_left <= 0:
		game_over()
		return
	if is_instance_valid(current_level) and current_level is MinigameLevel:
		current_level.game_ended.disconnect(_on_game_end)
	if last_game_won and games_won > 0 and games_won % speed_up_num_rounds == 0:
		speed_up()
	if level > 3:
		game_win()
		return
	load_random_level()

func speed_up() -> void:
	if level <= 3:
		level += 1

func end_game() -> void:
	level_timer.stop()
	if is_instance_valid(current_level) and current_level is MinigameLevel:
		if not current_level.won_game:
			current_level.lose()
		current_level.end_game()

func game_over() -> void:
	print("GAME OVER")
	current_level = null
	SceneManager.change_scene_fade(load("uid://bnnfg7a0fbpyn"))

func game_win() -> void:
	print("VICTORY")
	await get_tree().create_timer(4, false).timeout
	SceneManager.change_scene_fade(load("uid://f4p1cmxnhbta"))

func _on_level_timer_timeout() -> void:
	end_game()
