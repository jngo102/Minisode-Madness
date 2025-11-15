class_name MinigameLevel extends Control

enum ControlScheme {
	KEYS,
	MOUSE,
}

@export var instruction: String = ""
@export var start: String = "START!"
@export var control_scheme: ControlScheme
@export var music: MusicTrack

@onready var label: Label = $ui/label
@onready var control: TextureRect = $ui/control_indicator
@onready var level_timer: LevelTimer = $ui/level_timer

var keys_texture: Texture2D = preload("uid://5gaofps6x30n")
var mouse_texture: Texture2D = preload("uid://cnjg3mdf30pgg")

signal won
signal lost
signal game_ended
var started: bool
var finished: bool
var won_game: bool

var cam_shaker: Shaker:
	get:
		return $game_camera/shaker

func _ready() -> void:
	AudioManager.play_music(music, 0, 0.5)
	
	label.text = instruction
	await get_tree().create_timer(0.5, false).timeout
	var label_tween: Tween = create_tween()
	label_tween.tween_property(label, "position", Vector2(Globals.SCREEN_WIDTH / 2 - label.size.x / 2, 64), 0.5).from(Vector2(Globals.SCREEN_WIDTH / 2 - label.size.x, -128)).set_trans(Tween.TRANS_LINEAR)
	label_tween.parallel().tween_property(label, "scale", Vector2.ONE, 0.5).from(Vector2.ONE * 2).set_trans(Tween.TRANS_LINEAR)
	label_tween.tween_property(label, "self_modulate", Color.TRANSPARENT, 2).from(Color.WHITE).set_trans(Tween.TRANS_LINEAR)
	
	match control_scheme:
		ControlScheme.KEYS:
			control.texture = keys_texture
		ControlScheme.MOUSE:
			control.texture = mouse_texture

	var control_tween: Tween = create_tween()
	control_tween.tween_property(control, "position:y", 276, 0.5).from(540).set_trans(Tween.TRANS_LINEAR)
	control_tween.tween_property(control, "position:y", 540, 0.5).from_current().set_delay(2).set_trans(Tween.TRANS_LINEAR)

func _start_game(time: float = 10, initial_wait: float = 2) -> void:
	await get_tree().create_timer(initial_wait, false).timeout
	if not finished:
		MinigameManager.level_timer.start(time / MinigameManager.level)
		level_timer.in_progress = true
		started = true
	label.text = start
	var label_tween: Tween = create_tween()
	label_tween.tween_property(label, "position", Vector2(Globals.SCREEN_WIDTH / 2 - label.size.x / 2, 64), 0.25).from(Vector2(Globals.SCREEN_WIDTH / 2 - label.size.x, 64)).set_trans(Tween.TRANS_LINEAR)
	label_tween.parallel().tween_property(label, "scale", Vector2.ONE, 0.25).from(Vector2.ONE * 2).set_trans(Tween.TRANS_LINEAR)
	label_tween.parallel().tween_property(label, "self_modulate", Color.TRANSPARENT, 1).from(Color.WHITE).set_trans(Tween.TRANS_LINEAR)

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
	level_timer.in_progress = false
	game_ended.emit()
	if won_game:
		won.emit()
	else:
		lost.emit()
