class_name Cowboy extends Node2D

var shot_clip: AudioStream = preload("uid://bincgosrpahaa")

@export var draw_time: float = 1

@onready var anim: AnimationPlayer = $anim
@onready var hitbox: Area2D = $hitbox

signal died
signal shot_player

var dead: bool

func draw() -> void:
	await get_tree().create_timer(draw_time, false).timeout
	shoot()

func shoot() -> void:
	if dead:
		return
	AudioManager.play_clip(shot_clip)
	anim.play("draw")
	shot_player.emit()

func die() -> void:
	dead = true
	died.emit()
	anim.play("die")
	hitbox.queue_free()

func _on_hitbox_area_entered(_area: Area2D) -> void:
	die()
