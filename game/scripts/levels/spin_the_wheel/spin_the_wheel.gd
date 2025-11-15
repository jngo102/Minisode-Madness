extends MinigameLevel

@onready var ferris_wheel: FerrisWheel = $ferris_wheel
@onready var rotate_dir: Sprite2D = $rotate_direction

var cursor_scene: PackedScene = preload("uid://bbvasjlghjsv0")

var scream_clip: AudioStream = preload("uid://ci2ytpvgmqv0q")

func _ready() -> void:
	ferris_wheel.unhinge_angular_velocity += MinigameManager.level * 3
	await super._ready()
	await _start_game(15)

func _process(delta: float) -> void:
	var amount: float = 2 * (ferris_wheel.body.angular_velocity / ferris_wheel.unhinge_angular_velocity)
	cam_shaker.shake(amount, delta, true)

func _start_game(time: float = 10, initial_wait: float = 2) -> void:
	await super._start_game(time, initial_wait)
	var cursor: Node2D = cursor_scene.instantiate()
	add_child(cursor)

func lose() -> void:
	super.lose()
	ferris_wheel.stop_spin_sound()
	ferris_wheel.is_grabbing = false
	ferris_wheel.grab_collision.disabled = true

func _on_ferris_wheel_unhinge() -> void:
	AudioManager.play_clip(scream_clip, 0.85, 1.15, 0.85)
	rotate_dir.hide()
	win()
	MinigameManager.end_game()
