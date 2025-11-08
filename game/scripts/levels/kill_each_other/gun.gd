class_name Gun extends Node2D

var shot_clip: AudioStream = preload("uid://bincgosrpahaa")
var shot_scene: PackedScene = preload("uid://b8vq7o15kshs6")

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		global_position = Vector2(
			clampf(global_position.x + event.relative.x, 0, Globals.SCREEN_WIDTH), 
			clampf(global_position.y + event.relative.y, 0, Globals.SCREEN_HEIGHT))
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		fire()

func fire() -> void:
	AudioManager.play_clip(shot_clip)
	var shot: Node2D = shot_scene.instantiate()
	add_child(shot)
	shot.global_rotation_degrees = randf_range(0, 360)
	move_child(shot, 0)
	await get_tree().create_timer(0.25, false).timeout
	shot.queue_free()
