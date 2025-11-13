extends MinigameLevel

@export var min_time: float = 2
@export var max_time: float = 4

var kill_each_other_clip: AudioStream = preload("uid://psyam32srtqq")
var gun_scene: PackedScene = preload("uid://b135bdgtq6c2i")

@onready var background: Sprite2D = $background
@onready var cowboy: Cowboy = $cowboy
@onready var gun_container: Node2D = $gun_container

var player_gun: Gun

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	await super._ready()
	var bg_tween: Tween = create_tween()
	bg_tween.tween_property(background, "self_modulate", Color.TRANSPARENT, 1).from(Color(1, 1, 1, 0.4)).set_trans(Tween.TRANS_LINEAR)
	AudioManager.play_clip(kill_each_other_clip)
	var wait: float = randf_range(min_time, max_time)
	await get_tree().create_timer(wait, false).timeout
	cowboy.draw_time /= MinigameManager.level
	_start_game(cowboy.draw_time * MinigameManager.level, 0)
	player_gun = gun_scene.instantiate()
	player_gun.global_position = Globals.random_position_on_screen()
	player_gun.fired.connect(_on_player_gun_fire)
	gun_container.add_child(player_gun)
	cowboy.draw()
	cowboy.died.connect(func():
		win()
		MinigameManager.end_game()
	)

func _on_player_gun_fire() -> void:
	cam_shaker.shake(1, 0.1, true)

func _exit_tree() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_cowboy_shot_player() -> void:
	player_gun.queue_free()
	lose()
