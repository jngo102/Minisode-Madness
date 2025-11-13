extends MinigameLevel

@export var max_cook_time: float = 3.0

@onready var anim: AnimationPlayer = $anim

var meat_clip: AudioStream = preload("uid://cgh07bwrotbw2")

var cook_time: float

func _ready() -> void:
	await super._ready()
	await _start_game(max_cook_time / MinigameManager.level, randf_range(4, 8))
	$spacebar.show()
	anim.play("cook")

func _process(delta: float) -> void:
	if started:
		cook_time += delta
		if cook_time > max_cook_time / MinigameManager.level:
			anim.play("burn")
			lose()

func _input(event: InputEvent) -> void:
	if not finished and event.is_action_pressed("ui_accept"):
		if cook_time > 0:
			anim.play("flip_good")
			win()
		else:
			anim.play("flip_bad")
			lose()
		MinigameManager.end_game()

func play_meat() -> void:
	AudioManager.play_clip(meat_clip)
