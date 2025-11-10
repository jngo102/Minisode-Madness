extends MinigameLevel

@onready var yapper: Node2D = $yapper
@onready var anim: AnimationPlayer = yapper.get_node_or_null("anim")
@onready var voice: AudioStreamPlayer2D = yapper.get_node_or_null("voice")
@onready var panel: Panel = yapper.get_node_or_null("panel")

func _ready() -> void:
	await super._ready()
	await _start_game(6)
	panel.show()
	anim.play("yap")
	voice.play()

func _exit_tree() -> void:
	AudioManager.current_music_player.volume_db = 0
	Engine.time_scale = 1

func lose() -> void:
	super.lose()
	panel.queue_free()

func _on_value_slider_value_changed(value: float) -> void:
	voice.volume_db = value
	if value <= AudioManager.audio_off_db:
		anim.play("mute")
		win()
		MinigameManager.end_game()
		panel.queue_free()
