class_name LevelTimer extends TextureRect

@export var countdown_textures: Array[Texture2D]

var explosion_clip: AudioStream = preload("uid://dg8f0xgkaq6pl")

var exploded: bool

var in_progress: bool:
	set(value):
		in_progress = value
		if value:
			exploded = false
		else:
			texture = null

func _process(_delta: float) -> void:
	if in_progress and not exploded:
		var index := int(MinigameManager.time_left_in_level / MinigameManager.level_duration * len(countdown_textures))
		texture = countdown_textures[index]
		if index <= 0:
			AudioManager.play_clip(explosion_clip)
			exploded = true
