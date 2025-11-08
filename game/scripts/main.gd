## The main scene that contains the current level
extends Control

## The root viewport
@onready var root: Viewport = get_tree().get_root()
## The sub-viewport containing the current level
@onready var screen: SubViewport = $screen_container/screen

func _ready():
	root.size_changed.connect(_on_root_size_changed)

func _on_root_size_changed() -> void:
	screen.size = root.size
