extends TextureRect

@export var frames: Array[Texture2D]

var main_menu_scene: PackedScene = preload("uid://vstl3bg568s7")

func _ready() -> void:
	var anim_texture := AnimatedTexture.new()
	anim_texture.frames = len(frames)
	for i in range(0, len(frames)):
		anim_texture.set_frame_texture(i, frames[i])
		anim_texture.set_frame_duration(i, 0.5)
	texture = anim_texture

func _process(delta: float) -> void:
	if texture is AnimatedTexture:
		if texture.current_frame >= len(frames) - 1:
			skip()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") or event.is_action_pressed("ui_accept"):
		skip()

func skip() -> void:
	SceneManager.change_scene(main_menu_scene, true)
