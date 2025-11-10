class_name VolumeBar extends Control

@export var full_segment_count: int = 9

@onready var segments_container: HBoxContainer = $segments_container

var segment_scene: PackedScene = preload("uid://wer374lemwqk")

@export var initial_volume: int

var current_volume: int:
	get:
		var value: int = 0
		for segment in segments_container.get_children():
			if segment is VolumeBarSegment:
				if segment.on:
					value += 1
		return value
	set(value):
		var index: int = 0
		for segment in segments_container.get_children():
			if segment is VolumeBarSegment:
				segment.on = index < value
			index += 1

func _ready() -> void:
	for segment_index in range(0, full_segment_count):
		var segment: Control = segment_scene.instantiate()
		segments_container.add_child(segment)
	current_volume = MinigameManager.level * 3
	MinigameManager.level_changed.connect(_on_level_change)

func raise_volume(amount: int) -> void:
	for i in range(0, amount):
		await get_tree().create_timer(0.25, false).timeout
		current_volume += 1

func lower_volume(amount: int) -> void:
	for i in range(0, amount):
		await get_tree().create_timer(0.25, false).timeout
		current_volume -= 1

func _on_level_change(level: int) -> void:
	var new_volume: int = level * 3
	if new_volume < current_volume:
		lower_volume(current_volume - new_volume)
	elif new_volume > current_volume:
		raise_volume(new_volume - current_volume)
