class_name LevelTimer extends TextureRect

@export var countdown_textures: Array[Texture2D]

var in_progress: bool:
	set(value):
		in_progress = value
		if not value:
			texture = null

func _process(_delta: float) -> void:
	if in_progress:
		texture = countdown_textures[int(MinigameManager.time_left_in_level / MinigameManager.level_duration * len(countdown_textures))]
