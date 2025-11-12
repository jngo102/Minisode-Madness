## Represents a settings file on the user's disk
class_name Settings extends Resource

## The overall master volume
@export var master_volume: float = 1:
	set(value):
		var mapped_value: float = remap(value, 0, 1, AudioManager.audio_off_db, 0)
		AudioManager.current_music_player.volume_db = mapped_value * music_volume
		master_volume = value

## Volume of music in-game
@export var music_volume: float = 1:
	set(value):
		var mapped_value: float = remap(value, 0, 1, AudioManager.audio_off_db, 0)
		AudioManager.current_music_player.volume_db = mapped_value * master_volume
		music_volume = value

## Volume of sound effects in-game
@export var sfx_volume: float = 1
