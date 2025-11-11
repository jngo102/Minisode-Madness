extends MinigameLevel

@export var textures: Array[Texture2D]

@onready var bg: TextureRect = $background
@onready var yapper: Node2D = $yapper
@onready var yapper_anim: AnimationPlayer = yapper.get_node_or_null("anim")
@onready var voice: AudioStreamPlayer2D = yapper.get_node_or_null("voice")
@onready var panel: Panel = yapper.get_node_or_null("panel")

var mute_bg: Texture2D = preload("uid://bt6jr558643on")

func _ready() -> void:
	await super._ready()
	await _start_game(6)
	panel.show()
	yapper_anim.play("yap")
	voice.play()

func _process(delta: float) -> void:
	if not finished:
		bg.texture = textures[int(1 - MinigameManager.time_left_in_level / MinigameManager.level_duration * len(textures))]

func _exit_tree() -> void:
	AudioManager.current_music_player.volume_db = 0
	Engine.time_scale = 1

func lose() -> void:
	super.lose()
	panel.queue_free()

func _on_value_slider_value_changed(value: float) -> void:
	voice.volume_db = value
	if value <= AudioManager.audio_off_db:
		yapper_anim.play("mute")
		win()
		bg.texture = mute_bg
		MinigameManager.end_game()
		panel.queue_free()
