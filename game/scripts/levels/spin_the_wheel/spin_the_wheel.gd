extends MinigameLevel

@onready var ferris_wheel: FerrisWheel = $ferris_wheel

var cursor_scene: PackedScene = preload("uid://bbvasjlghjsv0")

func _ready() -> void:
	await super._ready()
	await _start_game()

func _start_game(time: float = 10, initial_wait: float = 2) -> void:
	await super._start_game(time, initial_wait)
	var cursor: Node2D = cursor_scene.instantiate()
	add_child(cursor)

func lose() -> void:
	super.lose()
	ferris_wheel.grab_collision.disabled = true

func _on_ferris_wheel_unhinge() -> void:
	win()
	MinigameManager.end_game()
