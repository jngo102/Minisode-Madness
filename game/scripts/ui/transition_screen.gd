class_name TransitionScreen extends BaseUI
## Displays when transitioning between screens

@export var music_list: Array[MusicTrack]

@onready var video_player: VideoStreamPlayer = $video_player

var current_track: MusicTrack

## Emitted when the screen finishes transitioning in
signal transitioned

func open() -> void:
	super.open()
	var track: MusicTrack = music_list[randi() % len(music_list)]
	while track == current_track:
		track = music_list[randi() % len(music_list)]
	AudioManager.play_music(track, 0, 0.25)
	current_track = track
	video_player.play()

func _on_video_player_finished() -> void:
	transitioned.emit()
