extends Area2D

@export var sprites: Array[Texture2D]

@onready var anim: AnimationPlayer = $anim
@onready var sprite: Sprite2D = $sprite

func _ready() -> void:
	sprite.texture = sprites[randi() % len(sprites)]

func _on_body_entered(body: Node2D) -> void:
	if body is RigidBody2D:
		anim.play("die")
