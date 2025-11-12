extends Area2D

@export var sprites: Array[Texture2D]

@onready var anim: AnimationPlayer = $anim
@onready var sprite: Sprite2D = $sprite

var squish_clip: AudioStream = preload("uid://hmj4wf3jrl8y")

func _ready() -> void:
	sprite.texture = sprites[randi() % len(sprites)]

func _on_body_entered(body: Node2D) -> void:
	if body is RigidBody2D:
		anim.play("die")
		AudioManager.play_clip(squish_clip)
