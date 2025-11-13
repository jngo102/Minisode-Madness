extends MinigameLevel

@export var textures: Array[Texture2D]

@onready var bg: TextureRect = $background
@onready var yapper: Node2D = $yapper
@onready var yapper_anim: AnimationPlayer = yapper.get_node_or_null("anim")
@onready var voice: AudioStreamPlayer2D = yapper.get_node_or_null("voice")
@onready var panel: Panel = yapper.get_node_or_null("panel")

var mute_bg: Texture2D = preload("uid://bt6jr558643on")
var mute_zip: AudioStream = preload("uid://buy3u8tqd54mc")

func _ready() -> void:
	await super._ready()
	await _start_game(8 - MinigameManager.level * 3.0)
	panel.show()
	yapper_anim.play("yap")
	voice.play()

func _process(delta: float) -> void:
	if not finished:
		bg.texture = textures[int(1 - MinigameManager.time_left_in_level / MinigameManager.level_duration * len(textures))]

func win() -> void:
	super.win()
	yapper_anim.play("mute")
	AudioManager.play_clip(mute_zip)
	bg.texture = mute_bg
	panel.queue_free()

func lose() -> void:
	super.lose()
	panel.queue_free()

func _on_value_slider_value_changed(value: float) -> void:
	voice.volume_db = value
	if value <= AudioManager.audio_off_db:
		win()
		MinigameManager.end_game()
