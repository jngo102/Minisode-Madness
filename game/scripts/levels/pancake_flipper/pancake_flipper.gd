extends MinigameLevel

@export var max_cook_time: float = 3.0

@onready var anim: AnimationPlayer = $anim

var flip_clip: AudioStream = preload("uid://bu30ortmy1iku")
var meat_clip: AudioStream = preload("uid://cgh07bwrotbw2")
var bam_clip: AudioStream = preload("uid://j3jm2m5noih2")

var cook_time: float

func _ready() -> void:
	await super._ready()
	await _start_game(max_cook_time / MinigameManager.level, randf_range(4, 8))
	$spacebar.show()
	anim.play("cook")
	MinigameManager.level_timer.timeout.connect(_on_timeout)

func _on_timeout() -> void:
	anim.play("burn")

func _input(event: InputEvent) -> void:
	if not finished and event.is_action_pressed("ui_accept"):
		if not MinigameManager.level_timer.is_stopped():
			anim.play("flip_good")
			AudioManager.play_clip(flip_clip)
			win()
			MinigameManager.end_game()
			await anim.animation_finished
			AudioManager.play_clip(bam_clip)
		else:
			anim.play("flip_bad")
			AudioManager.play_clip(flip_clip)
			lose()
			MinigameManager.end_game()

func play_meat() -> void:
	AudioManager.play_clip(meat_clip)
