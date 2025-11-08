extends MinigameLevel

@export var min_time: float = 1
@export var max_time: float = 4

var kill_each_other_clip: AudioStream = preload("uid://psyam32srtqq")
var gun_scene: PackedScene = preload("uid://b135bdgtq6c2i")

@onready var cowboy: Cowboy = $cowboy

var player_gun: Gun

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	await super._ready()
	AudioManager.play_clip(kill_each_other_clip)
	var wait: float = randf_range(min_time, max_time)
	await get_tree().create_timer(wait, false).timeout
	MinigameManager.start(cowboy.draw_time)
	_start_game()
	player_gun = gun_scene.instantiate()
	player_gun.global_position = Globals.random_position_on_screen()
	add_child(player_gun)
	cowboy.draw()
	cowboy.died.connect(win)

func _on_cowboy_shot_player() -> void:
	player_gun.queue_free()
	lose()
