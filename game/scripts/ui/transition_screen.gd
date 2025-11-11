class_name TransitionScreen extends BaseUI
## Displays when transitioning between screens

@export var portraits: Array[Texture2D]
@export var music_list: Array[MusicTrack]

@onready var anim: AnimationPlayer = $anim
@onready var video_player: VideoStreamPlayer = $video_player
@onready var portrait: TextureRect = $portrait

var last_track: MusicTrack
var last_portrait: Texture2D

## Emitted when the screen finishes transitioning in
signal transitioned

func open() -> void:
	super.open()
	anim.play("tilt")
	var track: MusicTrack = music_list[randi() % len(music_list)]
	while track == last_track:
		track = music_list[randi() % len(music_list)]
	var texture: Texture2D = portraits[randi() % len(portraits)]
	while texture == last_portrait:
		texture = portraits[randi() % len(portraits)]
	AudioManager.play_music(track, 0, 0.25)
	last_track = track
	portrait.texture = texture
	last_portrait = texture
	video_player.play()

func _on_video_player_finished() -> void:
	transitioned.emit()
