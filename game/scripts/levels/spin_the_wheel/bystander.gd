extends Area2D

@onready var anim: AnimationPlayer = $anim

func _on_body_entered(body: Node2D) -> void:
	if body is RigidBody2D:
		anim.play("die")
