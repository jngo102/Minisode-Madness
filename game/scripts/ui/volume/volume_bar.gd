class_name VolumeBar extends Control

@onready var segments_container: TextureRect = $volume3

func _ready() -> void:
	MinigameManager.level_changed.connect(_on_level_change)

func set_volume(amount: int) -> void:
	for i in range(4, min(10, amount + 1)):
		await get_tree().create_timer(0.125, false).timeout
		segments_container.find_child("volume%d" % i).show()

func _on_level_change(level: int) -> void:
	var new_volume: int = level * 3
	set_volume(new_volume)
