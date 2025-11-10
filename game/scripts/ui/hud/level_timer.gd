class_name LevelTimer extends TextureRect

@export var countdown_textures: Array[Texture2D]

var level_started: bool

func _process(_delta: float) -> void:
	if level_started:
		texture = countdown_textures[int(MinigameManager.time_left_in_level / MinigameManager.level_duration * len(countdown_textures))]
