class_name Cowboy extends Node2D

var draw_clip: AudioStream = preload("uid://dx7y56uj637yu")
var die_clip: AudioStream = preload("uid://817wgqe5amuu")
var lose_clip: AudioStream = preload("uid://b56vxyeibidfv")
var shot_clip: AudioStream = preload("uid://bojuk0bkq71cn")

@export var draw_time: float = 1

@onready var anim: AnimationPlayer = $anim
@onready var hitbox: Area2D = $hitbox

signal died
signal shot_player

var dead: bool

func draw() -> void:
	AudioManager.play_clip(draw_clip)
	anim.play("draw")
	await get_tree().create_timer(draw_time, false).timeout
	shoot()

func shoot() -> void:
	if dead:
		return
	anim.play("shoot")
	AudioManager.play_clip(shot_clip)
	shot_player.emit()

func die() -> void:
	dead = true
	died.emit()
	anim.play("die")
	hitbox.queue_free()
	AudioManager.play_clip(lose_clip)
	await anim.animation_finished
	AudioManager.play_clip(die_clip)

func _on_hitbox_area_entered(_area: Area2D) -> void:
	die()
