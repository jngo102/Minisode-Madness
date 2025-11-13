class_name Fader extends BaseUI

@onready var anim: AnimationPlayer = $anim

signal faded_in
signal faded_out

var speed: float = 1

func open() -> void:
	super.open()
	anim.play("fade_in", 0, speed)
	await anim.animation_finished
	faded_in.emit()

func close() -> void:
	anim.play("fade_out", 0, speed)

func _on_anim_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fade_out":
		super.close()
		faded_out.emit()
