class_name TransitionScreen extends BaseUI
## Displays when transitioning between screens

@export var portraits: Array[Texture2D]
@export var music_list: Array[MusicTrack]

@onready var anim: AnimationPlayer = $anim
@onready var video_player: VideoStreamPlayer = $video_player
@onready var portrait: TextureRect = $portrait
@onready var lives: Control = $lives
@onready var win: TextureRect = $transitions/win
@onready var lose: TextureRect = $transitions/lose
@onready var speed_up: AnimationPlayer = $speed_up

var last_track: MusicTrack
var last_portrait: Texture2D

## Emitted when the screen finishes transitioning in
signal transitioned

func _ready() -> void:
	MinigameManager.level_changed.connect(_on_level_change)

func open() -> void:
	super.open()
	anim.play("tilt")
	for i in range(0, lives.get_child_count()):
		var life_texture: TextureRect = lives.get_child(i)
		if i < MinigameManager.lives_left:
			life_texture.show()
		else:
			life_texture.hide()
		
	var track: MusicTrack = music_list[randi() % len(music_list)]
	while track == last_track:
		track = music_list[randi() % len(music_list)]
	var texture: Texture2D = portraits[randi() % len(portraits)]
	while texture == last_portrait:
		texture = portraits[randi() % len(portraits)]
	AudioManager.play_music(track, 0, 0, true)
	last_track = track
	portrait.texture = texture
	last_portrait = texture
	video_player.play()
	$static.show()
	if is_instance_valid(MinigameManager.current_level):
		if MinigameManager.last_game_won:
			lose.show()
			win.hide()
		else:
			win.show()
			lose.hide()

func _on_video_player_finished() -> void:
	transitioned.emit()
	$static.hide()

func _on_level_change(new_level: int) -> void:
	speed_up.play("show")
