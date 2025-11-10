extends MinigameLevel

@onready var ui: CanvasLayer = $ui
@onready var pause_button: Button = ui.get_node_or_null("pause_button")
@onready var pause_menu: Panel = ui.get_node_or_null("pause_menu")
@onready var sliders: VBoxContainer = ui.get_node_or_null("pause_menu/margins/settings/sliders")
@onready var voice: AudioStreamPlayer2D = $annoying_thing/voice

func _on_pause_button_pressed() -> void:
	pause_menu.show()

func _ready() -> void:
	await super._ready()
	await _start_game(6)
	pause_button.show()
	voice.play()
	for slider in sliders.get_children():
		var random_index: int = randi() % sliders.get_child_count()
		sliders.move_child(slider, random_index)

func _exit_tree() -> void:
	AudioManager.current_music_player.volume_db = 0
	Engine.time_scale = 1

func lose() -> void:
	super.lose()
	ui.queue_free()

func _on_music_value_slider_value_changed(value: float) -> void:
	AudioManager.current_music_player.volume_db = remap(value, AudioManager.audio_off_db, 0, 0, 1)

func _on_voice_value_slider_value_changed(value: float) -> void:
	voice.volume_db = value
	if value <= AudioManager.audio_off_db:
		win()
		MinigameManager.end_game()
		ui.queue_free()

func _on_speed_value_slider_value_changed(value: float) -> void:
	Engine.time_scale = 4 - value
