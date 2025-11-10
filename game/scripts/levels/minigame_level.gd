class_name MinigameLevel extends Control

@export var instruction: String = ""

@onready var label: Label = $label

signal won
signal lost
signal game_ended
var started: bool
var finished: bool
var won_game: bool

func _ready() -> void:
	label.text = instruction
	await get_tree().create_timer(0.5, false).timeout
	var label_tween: Tween = create_tween()
	label_tween.tween_property(label, "position", Vector2(Globals.SCREEN_WIDTH / 2 - label.size.x / 2, 64), 0.5).from(Vector2(Globals.SCREEN_WIDTH / 2 - label.size.x, -128)).set_trans(Tween.TRANS_LINEAR)
	label_tween.parallel().tween_property(label, "scale", Vector2.ONE, 0.5).from(Vector2.ONE * 2).set_trans(Tween.TRANS_LINEAR)
	label_tween.tween_property(label, "self_modulate", Color.TRANSPARENT, 2).from(Color.WHITE).set_trans(Tween.TRANS_LINEAR)

func _start_game(time: float = 10, initial_wait: float = 2) -> void:
	await get_tree().create_timer(initial_wait, false).timeout
	MinigameManager.level_timer.start(time / MinigameManager.level)
	label.text = "START!"
	var label_tween: Tween = create_tween()
	label_tween.tween_property(label, "position", Vector2(Globals.SCREEN_WIDTH / 2 - label.size.x / 2, 64), 0.25).from(Vector2(Globals.SCREEN_WIDTH / 2 - label.size.x, -128)).set_trans(Tween.TRANS_LINEAR)
	label_tween.parallel().tween_property(label, "scale", Vector2.ONE, 0.25).from(Vector2.ONE * 2).set_trans(Tween.TRANS_LINEAR)
	label_tween.tween_property(label, "self_modulate", Color.TRANSPARENT, 1).from(Color.WHITE).set_trans(Tween.TRANS_LINEAR)
	started = true

func win() -> void:
	if finished:
		return
	print("WIN")
	finished = true
	won_game = true

func lose() -> void:
	if finished:
		return
	print("LOSE")
	finished = true
	won_game = false

func end_game() -> void:
	game_ended.emit()
	if won_game:
		won.emit()
	else:
		lost.emit()
