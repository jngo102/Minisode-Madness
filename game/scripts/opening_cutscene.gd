extends TextureRect

@export var frames: Array[Texture2D]

var main_menu_scene: PackedScene = preload("uid://vstl3bg568s7")
var music: MusicTrack = preload("uid://dobsqjdtm61fm")

var show_skip: bool
var fading: bool

func _ready() -> void:
	AudioManager.play_music(music)
	var anim_texture := AnimatedTexture.new()
	anim_texture.frames = len(frames)
	for i in range(0, len(frames)):
		anim_texture.set_frame_texture(i, frames[i])
		anim_texture.set_frame_duration(i, 0.5)
	texture = anim_texture

func _process(delta: float) -> void:
	if texture is AnimatedTexture:
		if texture.current_frame >= len(frames) - 1 and not fading:
			SceneManager.change_scene_fade(main_menu_scene, 2)

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		if not show_skip:
			show_skip = true
			$skip.show()
		else:
			fading = true
			SceneManager.change_scene_fade(main_menu_scene, 2)
