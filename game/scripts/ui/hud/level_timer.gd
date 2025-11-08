extends Control

@onready var progress: TextureProgressBar = $progress

func _process(_delta: float) -> void:
	progress.value = MinigameManager.time_left_in_level / MinigameManager.level_duration
