extends Panel

@onready var settings_list: VBoxContainer = $content/options_list
@onready var master_volume_slider: HSlider = settings_list.get_node_or_null("master_volume/value_slider")
@onready var music_volume_slider: HSlider = settings_list.get_node_or_null("music_volume/value_slider")
@onready var sfx_volume_slider: HSlider = settings_list.get_node_or_null("sfx_volume/value_slider")

func _ready() -> void:
	master_volume_slider.value = SaveManager.settings.master_volume
	music_volume_slider.value = SaveManager.settings.music_volume
	sfx_volume_slider.value = SaveManager.settings.sfx_volume

func _on_master_volume_value_slider_value_changed(value: float) -> void:
	SaveManager.settings.master_volume = value

func _on_music_volume_value_slider_value_changed(value: float) -> void:
	SaveManager.settings.music_volume = value

func _on_sfx_volume_value_slider_value_changed(value: float) -> void:
	SaveManager.settings.sfx_volume = value

func _on_back_button_pressed() -> void:
	hide()
