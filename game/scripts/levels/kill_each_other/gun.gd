class_name Gun extends Node2D

signal fired

var shot_clip: AudioStream = preload("uid://bojuk0bkq71cn")
var shot_scene: PackedScene = preload("uid://b8vq7o15kshs6")

func fire() -> void:
	fired.emit()
	AudioManager.play_clip(shot_clip)
	var shot: Node2D = shot_scene.instantiate()
	add_child(shot)
	shot.global_rotation_degrees = randf_range(0, 360)
	move_child(shot, 0)
	await get_tree().create_timer(0.25, false).timeout
	shot.queue_free()

func _on_mouse_tracker_clicked() -> void:
	fire()
